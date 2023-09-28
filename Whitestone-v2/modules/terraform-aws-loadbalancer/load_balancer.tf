resource "aws_lb" "loadbalancer" {
  name               = var.lb_name
  internal           = var.internal
  load_balancer_type = var.lb_type

  subnets = var.subnets

  security_groups = var.lb_type != "application" ? [] : concat(
    [aws_security_group.load_balancer_security_group[0].id],
    var.security_groups
  )

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = var.logging_bucket
  #   prefix  = var.lb_logging_prefix
  #   enabled = true
  # }

  tags = var.tags
}

resource "aws_lb_listener" "alb_listeners" {
  for_each = var.lb_type == "application" ? var.ports : {}

  load_balancer_arn = aws_lb.loadbalancer.arn

  port            = each.key
  protocol        = each.key == "443" ? "HTTPS" : "HTTP"
  ssl_policy      = each.key == "443" ? "ELBSecurityPolicy-2016-08" : ""
  certificate_arn = each.key == "443" ? var.lb_certificate_arn : ""

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group[each.key].arn
  }
}

resource "aws_lb_listener" "nlb_listeners" {
  for_each = var.lb_type == "network" ? var.ports : {}

  load_balancer_arn = aws_lb.loadbalancer.arn

  port            = each.key
  protocol        = each.key == "443" ? "TLS" : "TCP"
  ssl_policy      = each.key == "443" ? "ELBSecurityPolicy-2016-08" : ""
  certificate_arn = each.key == "443" ? var.lb_certificate_arn : ""

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group[each.key].arn
  }
}


resource "aws_lb_listener" "port_80_redirect" {
  count             = var.port_80_redirect ? 1 : 0
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}