####### VPC A ########

data "aws_vpc" "alpha" {
  id = "vpc-01f8cf2855398cc3c"
}

###### PUB SUB 1A #######

data "aws_subnet" "alpha_public_subnet_1a" {
  id = "subnet-0eeed545965bcc422"
}

###### PUB SUB 1B #######

data "aws_subnet" "alpha_public_subnet_1b" {
  id = "subnet-0aeedf6fc5164356a"
}

###### PRIV SUB 1A ######

data "aws_subnet" "alpha_private_subnet_1a" {
  id = "subnet-0df926d83a7ba1a6e"
}

###### PRIV SUB 1B ######

data "aws_subnet" "alpha_private_subnet_1b" {
  id = "subnet-0c3bb0b2d113f0f57"
}

########## ASG Service ROle ##########

data "aws_iam_role" "asg_service_role" {
  name = "AWSServiceRoleForAutoScaling"
}