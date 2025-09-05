resource "aws_security_group" "sgs" {
  for_each = var.security_groups

  name        = each.value.sg_name
  description = each.value.sg_description
  vpc_id      = var.vpc_id
}