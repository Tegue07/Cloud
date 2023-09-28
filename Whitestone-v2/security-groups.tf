resource "aws_security_group" "ec2_sg" {
  name        = "whitestone-ec2-sg"
  description = "whitestone ec2 sg"
  vpc_id      = data.aws_vpc.alpha.id

  tags = {
      Name = "whitestone-ec2-sg"
    }
  
}

resource "aws_vpc_security_group_ingress_rule" "whitestone_ec2_sg_ingress" {


  security_group_id = aws_security_group.ec2_sg.id

  referenced_security_group_id = module.node_nlb.sg_id #aws_security_group.nlb_sg.id
  from_port                    = "36125"
  to_port                      = "36125"
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "whitestone_ec2_sg_52222_ingress" {


  security_group_id = aws_security_group.ec2_sg.id

  referenced_security_group_id = module.node_nlb.sg_id #aws_security_group.nlb_sg.id
  from_port                    = "80"
  to_port                      = "80"
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "whitestone_ec2_cidr_ingress" {


  security_group_id = aws_security_group.ec2_sg.id

  cidr_ipv4                    = "102.164.29.248/32"
  from_port                    = "22"
  to_port                      = "22"
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "whitestone_ec2_sg_egress" {

  security_group_id = aws_security_group.ec2_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

}

########## NLB SG #########

# resource "aws_security_group" "nlb_sg" {
#   name        = "whitestone-nlb-sg"
#   description = "whitestone nlb sg"
#   vpc_id      = data.aws_vpc.alpha.id

#   tags = {
#       Name = "whitestone-nlb-sg"
#     }
  
# }

# resource "aws_vpc_security_group_ingress_rule" "whitestone_nlb_sg_ingress" {


#   security_group_id = aws_security_group.nlb_sg.id

#   cidr_ipv4                    = "0.0.0.0/0"
#   from_port                    = "36125"
#   to_port                      = "36125"
#   ip_protocol                  = "tcp"
# }

# resource "aws_vpc_security_group_egress_rule" "whitestone_nlb_sg_egress" {


#   security_group_id = aws_security_group.nlb_sg.id

#   cidr_ipv4                    = "0.0.0.0/0"
#   ip_protocol                  = "-1"
# }