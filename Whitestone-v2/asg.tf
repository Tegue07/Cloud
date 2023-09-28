# module "node_asg" {
#   source = "./modules/module-aws-autoscaling"

#   name                          = "whitestone-asg-1a"
#   use_name_prefix               = false
#   min_size                      = 1
#   max_size                      = 1
#   desired_capacity              = 1
#   health_check_type             = "EC2" #Investigate this
#   wait_for_capacity_timeout     = 0

#   vpc_zone_identifier           = [data.aws_subnet.alpha_private_subnet_1a.id]
  
#   create_lt                     = true
#   use_lt                        = true
#   lt_name                       = "whitestone-lt-1a"
#   image_id                      = "ami-01dd271720c1ba44f"
#   instance_type                 = "t2.micro"

#   update_default_version        = true
#   security_groups               = [aws_security_group.ec2_sg.id]


#   #user_data_base64              = each.value["user_data_base64"]
#   target_group_arns             = module.node_alb.lb_target_group_arns

#   key_name                      = "whitestone-ec2-key"

#   iam_instance_profile_name     = "alpha-ec2-ssm-role"


#   service_linked_role_arn       = aws_iam_service_linked_role.autoscaling.arn

# }
