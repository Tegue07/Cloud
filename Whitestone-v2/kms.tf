# resource "aws_kms_key" "alb_logs_key" {
#   description             = "Whitestone Test Key"
#   deletion_window_in_days = 10

#   tags = {
#     Name = "whitestone-alb-logs-key"
#   }
# }