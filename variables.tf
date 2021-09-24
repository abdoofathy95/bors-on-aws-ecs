variable "vpc_id" {}
variable "name" {}
variable "bors_image" {}
variable "bors_image_tag" {}
variable "container_name" {}
variable "container_port" {}
variable "health_check_path" {}
variable "public_port" {}
variable "public_protocol" {}
variable "public_host" {}
variable "database_ssl" {}

variable "database_url_arn" {}
variable "database_auto_migrate" {}
variable "command_trigger" {}

variable "secret_key_base_arn" {}
variable "github_client_id_arn" {}
variable "github_client_secret_arn" {}
variable "github_integration_id_arn" {}
variable "github_integration_pem_arn" {}
variable "github_webhook_secret_arn" {}

variable "tags" {}

variable "route53_zone_name" {}
variable "webhook_ssm_parameter_name" {}
variable "bors_ng_task_execution_role" {}
variable "private_subnet_ids" {}
variable "public_subnet_ids" {}
variable "cloudwatch_log_retention_in_days" {}
variable "lb_arn" {}
variable "lb_listener_arn" {}
variable "ecs_service_assign_public_ip" {}

variable "ecs_task_cpu" {}
variable "ecs_task_memory" {}

variable "ecs_cluster_id" {}

variable "alb_ingress_cidr_blocks" {}
variable "aws_region" {}

variable "alb_http_sg" {}
variable "alb_https_sg" {}
variable "bors_sg" {}