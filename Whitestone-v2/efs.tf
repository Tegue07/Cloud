# resource "aws_efs_file_system" "node_efs" {
#   creation_token = "whitestone-efs"

#   encrypted = true

#   tags = merge(
#     var.tags,
#     {
#       Name = "whitestone-efs"
#     }
#   )
# }

# resource "aws_efs_mount_target" "efs_mount_target_1a" {
#   file_system_id  = aws_efs_file_system.node_efs.id
#   subnet_id       = data.aws_subnet.alpha_private_subnet_1a.id
#   security_groups = [aws_security_group.allow_tfs.id]
# }

# resource "aws_efs_mount_target" "efs_mount_target_1b" {
#   file_system_id  = aws_efs_file_system.node_efs.id
#   subnet_id       = data.aws_subnet.alpha_private_subnet_1b.id
#   security_groups = [aws_security_group.allow_tfs.id]
# }