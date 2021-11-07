locals {
  sg_rules = {
    http = {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
    }
    http-8080 = {
      from_port = 8080
      to_port   = 8080
      protocol  = "tcp"
    }
    https = {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
    }
    ssh = {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
    }
  }

  normalized_sg_ingress_rules = flatten([
    for key, sg in var.app_config.security_groups : [
      for rule in sg.ingress_rules : {
        rule                = rule
        sg_key              = key
        from_port           = local.sg_rules[rule].from_port
        to_port             = local.sg_rules[rule].to_port
        protocol            = local.sg_rules[rule].protocol
        ingress_cidr_blocks = sg.ingress_cidr_blocks
        security_group_id   = aws_security_group.sgs[key].id
      }
    ]
  ])
}

resource "aws_security_group" "sgs" {
  for_each    = var.app_config.security_groups
  name_prefix = "${var.meta.project_slug}-${var.meta.environment}-${each.key}"
  description = each.value.description
  vpc_id      = var.provisioned_vpc.vpc_id
}

resource "aws_security_group_rule" "ingress" {
  for_each          = { for rule in local.normalized_sg_ingress_rules : "${rule.sg_key}-i-${rule.rule}" => rule }
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = lookup(each.value, "ingress_cidr_blocks", [])
  security_group_id = aws_security_group.sgs[each.value.sg_key].id
}

# This is default AWS rule. Terraform remove it intentionally, let's add it back to every SG
resource "aws_security_group_rule" "allow_all_egress" {
  for_each          = var.app_config.security_groups
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sgs[each.key].id
}
