resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = "whitetone-asg-service-role"
  tags = {
    Name = "whitetone-asg-service-role"
  }
}