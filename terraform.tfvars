# AWS CONFIGS
vpc_id = "<YOUR_VPC_ID>"
aws_region = "<AWS_REGION>"


# bors related configs
name="<NAME>"
bors_image = "<BORS_IMAGE>"
bors_image_tag = "<TAG>"

container_name = "bors"
container_port = "4000"
public_port = "443"
public_host = "<PUBLIC_HOST_NAME>"
public_protocol = "https"
health_check_path = "/health"

database_ssl = false
database_url_arn = "<AWS_DATABASE_URL> (EXAMPLE: arn:aws:ssm:REGION:ACC_NUM:parameter/bors-ng/database/url)"
database_auto_migrate = true
command_trigger = "<HOW_YOU_WANT_TO_ADDRESS_BORS>"

# github related configs (SECRETS ON AWS PARAMETER STORE)
github_webhook_secret_arn = ""
github_client_id_arn = ""
github_client_secret_arn = ""
github_integration_id_arn = ""
github_integration_pem_arn = ""
secret_key_base_arn = ""
webhook_ssm_parameter_name = "/bors-ng/github/webhook/secret"

private_subnet_ids = ["PRIVATE_SUBNET_ID"]
public_subnet_ids = ["PUBLIC_SUBNET_ID"]

# Different security groups, OR BETTER handle in through TF ALSO
alb_http_sg = []
alb_https_sg = []
bors_sg = []

lb_arn = "<LOAD_BALANCER_ARN>"
lb_listener_arn = "<LOAD_BALANCER_LISTENER_ARN>"
route53_zone_name = "<HOSTING_ZONE_NAME>"

# ECS Service and Task
ecs_service_assign_public_ip = true
ecs_cluster_id = "<ECS_CLUSTER_ARN>"

ecs_task_cpu=4096
ecs_task_memory=8192

alb_ingress_cidr_blocks = [
  # Github webhooks Source: https://api.github.com/meta
  "140.82.112.0/20",
  "143.55.64.0/20",
  "185.199.108.0/22",
  "192.30.252.0/22",
]

bors_ng_task_execution_role = "<BORS_NG_EXECUTION_ROLE_ARN>"
cloudwatch_log_retention_in_days = 7

tags = {
  owner: "BORS_IS_AWESOME"
}
