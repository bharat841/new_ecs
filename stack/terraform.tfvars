##ecr repo

ecr_repo_name = "sameer-repo"
aws_region = "ap-south-1"
ecr_image_tag  = "MUTABLE"            # or use a specific tag like "v1.0.0"
ecr_env        = "dev"               # or "prod", "staging", etc.
ecr_project    = "my-ecr-project"

##task definition

role_name  = "ecs-app"  # base name, used to create ecs-app-execution and ecs-app-task roles

task_definitions = {
  frontend = {
    family_name = "frontend"
    image_url   = "498473768265.dkr.ecr.ap-south-1.amazonaws.com/sameer-repo:frontend"
    port        = 5000
    cpu         = 256
    memory      = 512
    log_group   = "/ecs/frontend"
    environment = [
      {
        name  = "REACT_APP_BACKEND_URL"
        value = "http://localhost:8080"
      }
    ]
  }

  backend = {
    family_name = "backend"
    image_url   = "498473768265.dkr.ecr.ap-south-1.amazonaws.com/sameer-repo:backend"
    port        = 8080
    cpu         = 512
    memory      = 1024
    log_group   = "/ecs/backend"
    environment = [
      { name = "REDIS_HOST",         value = "redis" },
      { name = "POSTGRES_HOST",      value = "postgres" },
      { name = "POSTGRES_USER",      value = "postgres" },
      { name = "POSTGRES_PASSWORD",  value = "postgres" },
      { name = "POSTGRES_DATABASE",  value = "postgres" },
      { name = "REQUEST_ORIGIN",     value = "http://localhost" }
    ]
  }

  redis = {
    family_name = "redis"
    image_url   = "498473768265.dkr.ecr.ap-south-1.amazonaws.com/sameer-repo:redis"
    port        = 6379
    cpu         = 256
    memory      = 512
    log_group   = "/ecs/redis"
    environment = []
  }

  postgres = {
    family_name = "postgres"
    image_url   = "498473768265.dkr.ecr.ap-south-1.amazonaws.com/sameer-repo:postgres"
    port        = 5432
    cpu         = 512
    memory      = 1024
    log_group   = "/ecs/postgres"
    environment = [
      { name = "POSTGRES_PASSWORD", value = "postgres" }
    ]
  }

  reverse_proxy = {
    family_name = "reverse-proxy"
    image_url   = "498473768265.dkr.ecr.ap-south-1.amazonaws.com/sameer-repo:nginx"
    port        = 80
    cpu         = 256
    memory      = 512
    log_group   = "/ecs/reverse-proxy"
    environment = [
      { name = "NGINX_PORT", value = "80" }
    ]
  }
}

## vpc 

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.101.0/24",
  "10.0.102.0/24"
]

tags = {
  Environment = "dev"
  Project     = "ecs-app"
}

##sg

vpc_id = "vpc-053667bab8da65260"
frontend = { 
  name = "frontend-sg" 
  description = "SG for frontend" 
  ingress = [ { from_port = 5000, to_port = 5000, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }, 
  { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
  { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }, ]
  egress = [ { from_port = 8080, to_port = 8080, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
   ]
  } 
backend = { 
  name = "backend-sg" 
  description = "SG for backend" 
  ingress = [ { from_port = 8080, to_port = 8080, protocol = "tcp",cidr_blocks = ["0.0.0.0/0"] },
  { from_port = 6379, to_port = 6379, protocol = "tcp",cidr_blocks = ["0.0.0.0/0"]},
  ]
  egress = [ { from_port = 5432, to_port = 5432, protocol = "tcp",cidr_blocks = ["0.0.0.0/0"]}, 
  ] 
  }
postgres = { 
  name = "postgres-sg" 
  description = "SG for postgres" 
  ingress = [ { from_port = 5432, to_port = 5432, protocol = "tcp",cidr_blocks = ["0.0.0.0/0"]}, ] 
  egress = [ { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }, 
    ] 
  } 
redis = { 
  name = "redis-sg" 
  description = "SG for redis" 
  ingress = [ { from_port = 6379, to_port = 6379, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }, ] 
  egress = [ { from_port = 5432, to_port = 5432, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"]}, ] 
} 
nginx = { 
  name = "nginx-sg" 
  description = "SG for nginx" 
  ingress = [ { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }, ] 
  egress = [ { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }, ] 
}