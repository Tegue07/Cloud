module node_nlb {
    source = "./modules/terraform-aws-loadbalancer"


     lb_name             = "whitestone-nats-nlb"
     internal            = false
     lb_type             = "network"

    # # logging_bucket      = "logging-test-bucket-2023091967"
    # # lb_logging_prefix   = ""
     target_group_name   = "whitestone-nlb-tg"
     lb_certificate_arn  = ""

     vpc_id              = data.aws_vpc.alpha.id
     subnets             = [data.aws_subnet.alpha_private_subnet_1a.id, data.aws_subnet.alpha_private_subnet_1b.id]
     ports               = {36125 = 36125, 80 = 80}
     #security_groups     = [aws_security_group.nlb_sg.id]
     health_check_path   = "/healthz.html"

     enable_access_logs  = false

    tags = {
      "Name" = "whitestone-nats-nlb"
    }

    #tags                = each.value["tags"]
}

# resource "aws_lb" "whitestone_nlb" {
#   name               = "whitestone-nlb"
#   internal           = false
#   load_balancer_type = "network"
#   security_groups    = [aws_security_group.nlb_sg.id]
#   subnets            = [data.aws_subnet.alpha_private_subnet_1a.id, data.aws_subnet.alpha_private_subnet_1b.id]

#   enable_deletion_protection = false


#   tags = {
#     Name = "whitestone-nlb"
#   }
# }