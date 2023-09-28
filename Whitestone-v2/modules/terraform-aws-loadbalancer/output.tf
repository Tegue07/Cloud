output lb_dns_name {
  value = aws_lb.loadbalancer.dns_name
}

output lb_zone_id {
  value = aws_lb.loadbalancer.zone_id
}

output lb_arn {
  value = aws_lb.loadbalancer.arn
}

output lb_target_group_arns {
  value = toset([
    for tg_group in aws_lb_target_group.lb_target_group : tg_group.arn
  ])
}

output lb_name {
  value = aws_lb.loadbalancer.name
}

# output "sg_id" {
#   value = aws_security_group.load_balancer_security_group[0].id
# }

output "sg_id" {
  value = var.lb_type == "application" ? aws_security_group.load_balancer_security_group[0].id : ""
}

# output target_group_http_arn {
#   value = aws_lb_target_group.lb_target_group
# }

output target_group_http_arn {
  value = try(aws_lb_target_group.lb_target_group["80"].arn, "")
}