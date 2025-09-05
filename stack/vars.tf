## ecr

variable "ecr_repo_name"{
    type = string
    description = "ecr repo name"
}
variable "ecr_image_tag"{
    type = string
    description = "image tag mutable or non mutable"
}
variable "ecr_env"{
    type = string
    description = "enironmen tfor ecr"
}
variable "ecr_project"{
    type = string
    description = "project name"
}
variable "aws_region" {
    type = string
    description = "value"
}
## task definition

variable "execution_role_arn" {
  type        = string
  description = "IAM execution role ARN for ECS task definition"
}

variable "task_role_arn" {
  type        = string
  description = "IAM task role ARN for ECS task definition"
}
variable "task_definitions" {
  description = "Map of ECS task definitions for different services"
  type = map(object({
    family_name = string
    image_url   = string
    port        = number
    cpu         = number
    memory      = number
    log_group = string 
    environment = list(object({
      name  = string
      value = string
    }))
  }))
}
variable "role_name"{}

## vpc

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDRs for public subnets"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDRs for private subnets"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
}

##sg 
variable "frontend" {
  type = any
}

variable "backend" {
  type = any
}

variable "postgres" {
  type = any
}

variable "redis" {
  type = any
}

variable "nginx" {
  type = any
}
variable "vpc_id"{
  
}