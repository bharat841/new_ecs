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
module "security_groups" {
  source           = "/home/sameer/Desktop/new_ecs/modules/sg"
  vpc_id           = var.vpc_id
  security_groups  = var.security_groups
}
