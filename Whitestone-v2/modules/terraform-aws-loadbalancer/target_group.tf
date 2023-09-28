resource "aws_lb_target_group" "lb_target_group" {
  for_each = var.ports

  name     = "${var.target_group_name}-${each.key}"
  port     = each.value
  #protocol = var.lb_type == "application" ? each.key == 443 ? "HTTP" : "HTTPS" : "TCP"
  protocol = var.lb_type == "application" ? each.key == 443 ? "HTTPS" : "HTTP" : "TCP"

  vpc_id   = var.vpc_id

  health_check {
    path = var.health_check_path
  }

  tags = var.tags
  lifecycle {
      create_before_destroy = true
  }
}

# resource "aws_lb_target_group_attachment" "tg_attachment" {
#   for_each = var.ports

#   target_group_arn = aws_lb_target_group.lb_target_group[each.key].arn
#   target_id        = var.instance_id
#   port             = each.value
# }

# resource "aws_autoscaling_attachment" "asg_attachment" {
#   for_each =  var.ports
#   autoscaling_group_name = var.asg_id
#   lb_target_group_arn    = aws_lb_target_group.lb_target_group[each.key].arn
# }