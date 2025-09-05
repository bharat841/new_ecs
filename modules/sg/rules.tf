resource "aws_security_group_rule" "ingress" {
  for_each = {
    for sg_key, sg_data in var.security_groups :
    for rule_index, rule in sg_data.ingress_rules :
    "${sg_key}_ingress_${rule_index}" => {
      sg_id = aws_security_group.sgs[sg_key].id
      rule  = rule
    }
  }

  type                     = "ingress"
  from_port                = each.value.rule.from_port
  to_port                  = each.value.rule.to_port
  protocol                 = each.value.rule.protocol
  security_group_id        = each.value.sg_id
  cidr_blocks              = lookup(each.value.rule, "cidr_blocks", [])
  source_security_group_id = try(each.value.rule.security_groups[0], null)
}
resource "aws_security_group_rule" "egress" {
  for_each = {
    for sg_key, sg_data in var.security_groups :
    for rule_index, rule in sg_data.egress_rules :
    "${sg_key}_egress_${rule_index}" => {
      sg_id = aws_security_group.sgs[sg_key].id
      rule  = rule
    }
  }

  type                     = "egress"
  from_port                = each.value.rule.from_port
  to_port                  = each.value.rule.to_port
  protocol                 = each.value.rule.protocol
  security_group_id        = each.value.sg_id
  cidr_blocks              = lookup(each.value.rule, "cidr_blocks", [])
  source_security_group_id = try(each.value.rule.security_groups[0], null)
}
