module "ecr"{
    source = "../modules/ecr"
    ecr_repo_name = var.ecr_repo_name
    ecr_image_tag = var.ecr_image_tag
    ecr_env = var.ecr_env
    ecr_project = var.ecr_project
}
module "iam" {
  source    = "../modules/iamrole"
  aws_region = var.aws_region
  role_name = var.role_name
}
module "taskdefinition" {
  source          = "../modules/taskdefinition"
  aws_region      = var.aws_region
  role_name       = var.role_name
  task_definitions = var.task_definitions
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn
}
module "vpc" {
  source               = "../modules/vpc"
  aws_region           = var.aws_region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = var.tags
}
# --- FRONTEND ---
module "frontend_sg" {
  source = "../modules/sg"
  name = var.frontend["name"] 
  description = var.frontend["description"] 
  vpc_id = var.vpc_id 
  ingress_rules = var.frontend["ingress"] 
  egress_rules = var.frontend["egress"] 
}
module "backend_sg" { 
  source = "../modules/sg" 
  name = var.backend["name"] 
  description = var.backend["description"] 
  vpc_id = var.vpc_id 
  ingress_rules = var.backend["ingress"] 
  egress_rules = var.backend["egress"] 
} 
module "postgres_sg" {
  source = "../modules/sg" 
  name = var.postgres["name"] 
  description = var.postgres["description"] 
  vpc_id = var.vpc_id 
  ingress_rules = var.postgres["ingress"] 
  egress_rules = var.postgres["egress"] 
  } 
module "redis_sg" { 
  source = "../modules/sg" 
  name = var.redis["name"] 
  description = var.redis["description"] 
  vpc_id = var.vpc_id 
  ingress_rules = var.redis["ingress"] 
  egress_rules = var.redis["egress"] 
}
module "nginx_sg" { 
  source = "../modules/sg" 
  name = var.nginx["name"] 
  description = var.nginx["description"] 
  vpc_id = var.vpc_id 
  ingress_rules = var.nginx["ingress"] 
  egress_rules = var.nginx["egress"] 
}
module "ecs_cluster" {
  source       = "../modules/cluster"
  aws_region   = var.aws_region
  ecs_cluster_name = var.ecs_cluster_name
  
}
module "frontend_service" {
  source             = "../modules/service"
  service_name       = "frontend-service"
  task_definition_arn= frontend_task_definition.task_definition_arn
  cluster_id         = module.ecs_cluster.ecs_cluster_id
  subnet_ids         = var.public_subnet_cidrs
  sg_ids             = [module.frontend_sg.sg_id]
  desired_count      = 2
  assign_public_ip   = true
  tags               = var.tags
}
module "backend_service" {
  source             = "../modules/service"
  service_name       = "backend-service"
  task_definition_arn= backend_task_definition.task_definition_arn
  cluster_id         = module.ecs_cluster.ecs_cluster_id
  subnet_ids         = var.private_subnet_cidrs
  sg_ids             = [module.backend_sg.sg_id]
  desired_count      = 2
  assign_public_ip   = false
  tags               = var.tags
}
module "redis_service" {
  source             = "../modules/service"
  service_name       = "redis-service"
  task_definition_arn= redis_task_definition.task_definition_arn
  cluster_id         = module.ecs_cluster.ecs_cluster_id
  subnet_ids         = var.private_subnet_cidrs
  sg_ids             = [module.redis_sg.sg_id]
  desired_count      = 1
  assign_public_ip   = false
  tags               = var.tags
}
module "postgres_service" {
  source             = "../modules/service"
  service_name       = "postgres-service"
  task_definition_arn= postgres_task_definition.task_definition_arn
  cluster_id         = module.ecs_cluster.ecs_cluster_id
  subnet_ids         = var.private_subnet_cidrs
  sg_ids             = [module.postgres_sg.sg_id]
  desired_count      = 1
  assign_public_ip   = false
  tags               = var.tags
}
module "nginx_service" {
  source             = "../modules/service"
  service_name       = "nginx-service"
  task_definition_arn= nginx_task_definition.task_definition_arn
  cluster_id         = module.ecs_cluster.ecs_cluster_id
  subnet_ids         = var.public_subnet_cidrs
  sg_ids             = [module.nginx_sg.sg_id]
  desired_count      = 2
  assign_public_ip   = true
  tags               = var.tags
}
