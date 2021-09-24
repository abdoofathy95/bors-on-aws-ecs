[
    {
        "name": "${container_name}",
        "image": "${bors_image}:${bors_image_tag}",
        "requires_compatibilities": "FARGATE",
        "mountPoints": [],
        "volumesFrom": [],
        "essential": true,
        "portMappings": [
            {
              "containerPort": ${port},
              "hostPort": ${port},
              "protocol": "${public_protocol}"
            }
        ],
        "environment": [
            {"name": "PORT", "value": "${port}"},
            {"name": "FORCE_SSL", "value": "false"},
            {"name": "ALLOW_PRIVATE_REPOS", "value": "true"},
            {"name": "PUBLIC_PORT", "value": "${public_port}"},
            {"name": "PUBLIC_PROTOCOL", "value": "${public_protocol}"},
            {"name": "PUBLIC_HOST", "value": "${public_host}"},
            {"name": "DATABASE_USE_SSL", "value": "${database_ssl}"},
            {"name": "DATABASE_AUTO_MIGRATE", "value": "${database_auto_migrate}"},
            {"name": "COMMAND_TRIGGER", "value": "${command_trigger}"},
            {"name": "BORS_LOG_OUTGOING", "value": "true"}
        ],
        "secrets": [
            {"name": "DATABASE_URL", "valueFrom": "${database_url_secret_arn}"},
            {"name": "GITHUB_CLIENT_ID", "valueFrom": "${github_client_id_arn}"},
            {"name": "SECRET_KEY_BASE", "valueFrom": "${secret_key_base_arn}"},
            {"name": "GITHUB_CLIENT_SECRET", "valueFrom": "${github_client_secret_arn}"},
            {"name": "GITHUB_INTEGRATION_ID", "valueFrom": "${github_integration_id_arn}"},
            {"name": "GITHUB_INTEGRATION_PEM", "valueFrom": "${github_integration_pem_arn}"},
            {"name": "GITHUB_WEBHOOK_SECRET", "valueFrom": "${github_webhook_secret_arn}"}
        ],
        "logConfiguration": {
          "logDriver": "awslogs",
          "options":
          {
            "awslogs-group": "${aws_cloudwatch_log_group}",
            "awslogs-region": "${log_region}",
            "awslogs-stream-prefix": "ecs"
          }
        }
    }
  ]