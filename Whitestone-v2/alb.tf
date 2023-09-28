module node_alb {
    source = "./modules/terraform-aws-loadbalancer"


     lb_name             = "whitestone-nats-alb"
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

    tags = {
      "Name" = "whitestone-nats-alb"
    }

    #tags                = each.value["tags"]
}