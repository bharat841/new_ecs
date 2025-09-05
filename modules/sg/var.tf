variable "security_groups" {
  description = "Map of SG configurations"
  type = map(object({
    sg_name        = string
    sg_description = string
    ingress_rules  = list(object({
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = list(string)
      security_groups = list(string)
    }))
    egress_rules  = list(object({
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = list(string)
      security_groups = list(string)
    }))
  }))
}

variable "vpc_id" {
  type = string
}
