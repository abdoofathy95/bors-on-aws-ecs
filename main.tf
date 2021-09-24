data "template_file" "bors_template_parameters" {
  template = file("./bors.json.tpl")

vars = {
    container_name = var.container_name
    bors_image = var.bors_image
    bors_image_tag = var.bors_image_tag
    port = var.container_port
    public_port = var.public_port
    public_protocol = var.public_protocol
    public_host = var.public_host
    database_ssl = var.database_ssl
    database_url_secret_arn = var.database_url_arn
    database_auto_migrate = var.database_auto_migrate
    command_trigger = var.command_trigger

    secret_key_base_arn = var.secret_key_base_arn
    github_client_id_arn = var.github_client_id_arn
    github_client_secret_arn = var.github_client_secret_arn
    github_integration_id_arn = var.github_integration_id_arn
    github_integration_pem_arn = var.github_integration_pem_arn
    github_webhook_secret_arn = var.github_webhook_secret_arn

    ecs_task_cpu = var.ecs_task_cpu
    ecs_task_memory = var.ecs_task_memory

    log_region = var.aws_region
    aws_cloudwatch_log_group = aws_cloudwatch_log_group.default.name
  }
}

data "aws_route53_zone" "default" {
    name = var.route53_zone_name
}

###################
# ALB
###################
module "alb" {
    source  = "terraform-aws-modules/alb/aws"
    version = "v5.10.0"

    name     = var.name
    internal = false

    vpc_id  = var.vpc_id
    subnets = var.public_subnet_ids
    security_groups = flatten([var.alb_https_sg, var.alb_http_sg])

    listener_ssl_policy_default = "ELBSecurityPolicy-2016-08"
    https_listeners = [
        {
            target_group_index = 0
            port = 443
            protocol = "HTTPS"
            certificate_arn = module.acm.this_acm_certificate_arn
            action_type = "forward"
        },
    ]

    http_tcp_listeners = [
        {
            port = 80
            protocol = "HTTP"
            action_type = "redirect"
            redirect = {
                port = 443
                protocol = "HTTPS"
                status_code = "HTTP_301"
            }
        },
    ]

    target_groups = [
        {
            name = var.name
            backend_protocol = "HTTP"
            backend_port = var.container_port
            target_type = "ip"
            deregistration_delay = 10
            health_check = {
                enabled = true
                path = var.health_check_path
            }
        },
    ]

    tags = var.tags
}

###################
# ACM (SSL certificate)
###################
module "acm" {
    source  = "terraform-aws-modules/acm/aws"
    version = "v2.12.0"

    create_certificate = true

    domain_name = var.public_host

    zone_id = data.aws_route53_zone.default.zone_id

    tags = var.tags
}

###################
# Route53 record
###################
resource "aws_route53_record" "default" {
    zone_id = data.aws_route53_zone.default.zone_id
    name    = var.name
    type    = "A"

    alias {
        name = module.alb.this_lb_dns_name
        zone_id = module.alb.this_lb_zone_id
        evaluate_target_health = true
    }
}

###################
# ECS
###################
resource "aws_ecs_task_definition" "default" {
    family = var.name
    network_mode = "awsvpc"
    execution_role_arn = var.bors_ng_task_execution_role
    task_role_arn = var.bors_ng_task_execution_role
    cpu = var.ecs_task_cpu
    memory = var.ecs_task_memory
    requires_compatibilities = ["FARGATE"]
    container_definitions = data.template_file.bors_template_parameters.rendered
    tags = var.tags
}

resource "aws_ecs_service" "default" {
    name = var.name
    cluster = var.ecs_cluster_id
    task_definition = aws_ecs_task_definition.default.arn
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
        subnets = var.private_subnet_ids
        security_groups = var.bors_sg
        assign_public_ip = var.ecs_service_assign_public_ip
    }

    load_balancer {
        target_group_arn = element(module.alb.target_group_arns, 0)
        container_name = var.container_name
        container_port = var.container_port
    }

    tags = var.tags
}

###################
# Cloudwatch logs
###################
resource "aws_cloudwatch_log_group" "default" {
    name = var.name
    retention_in_days = var.cloudwatch_log_retention_in_days

    tags = var.tags
}
