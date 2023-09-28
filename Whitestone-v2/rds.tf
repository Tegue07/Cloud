
# module "node_rds" {
#     source = "../modules/terraform-aws-rds"
#     identifier = "${var.application_name}-${var.environment}-rds"
#     engine = var.db_engine
#     instance_class = var.db_instance_class
#     major_engine_version = var.db_major_engine_version
#     family = var.db_instance_fammily
#     multi_az = var.multi_az
#     allocated_storage = 20
#     port = 3306
#     db_name  = "NodeDB" 
#     username = "admin"
#     #username = jsondecode(data.aws_secretsmanager_secret_version.node_rds_db_credentials.secret_string)["username"]
   
#     vpc_security_group_ids   = [aws_security_group.rds_sg.id] 
#     subnet_ids               = module.node_vpc.private_subnets 
   
#     create_db_subnet_group   = true
#     deletion_protection      = true 
#     tags = merge(var.tags,{
#         Name = local.node_rds_instance_name
#     })
# }