locals {
  sg_ports = toset(keys(var.ports))
}

resource "aws_security_group" "load_balancer_security_group" {
  count = var.lb_type == "application" ? 1 : 0

  name        = "${var.lb_name}_sg"
  description = "Security group for load balancer ${var.lb_name}"
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_security_group_rule" "lb_security_groups_ingress" {
  for_each = var.lb_type == "application" ? local.sg_ports : []

  type              = "ingress"
  from_port         = each.key
  to_port           = each.key
  protocol          = "tcp"
  cidr_blocks       = var.ingress_cidr
  security_group_id = aws_security_group.load_balancer_security_group[0].id
}

resource "aws_security_group_rule" "port_80_redirect" {
  count             = var.port_80_redirect ? 1 : 0
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.ingress_cidr
  security_group_id = aws_security_group.load_balancer_security_group[0].id
}

resource "aws_security_group_rule" "lb_security_groups_egress" {
  count = var.lb_type == "application" ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.load_balancer_security_group[0].id
}
