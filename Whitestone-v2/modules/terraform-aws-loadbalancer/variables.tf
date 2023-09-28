variable "tags" {
  type        = map(any)
  description = "Tags to give to the load balancer"
}

# Load Balancer variable
variable "lb_name" {
  type        = string
  description = "Name of the load balancer for quartz gateway"
}

variable "internal" {
  type        = bool
  description = "Internal load balancer or public load balancer"
}

variable "lb_type" {
  type = string

  validation {
    condition = contains(
      [
        "application",
        "gateway",
        "network"
      ],
      var.lb_type
    )

    error_message = "Invalid load balancer type."
  }

  description = "Load balancer type"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet ids to deploy the LB to"
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = "List of additional security group ids of security groups to assign to the LB"
}

variable  "enable_access_logs"{
  type = bool
  default = false
  description = "if true will create access logs for LB"
}

variable "logging_bucket" {
  type        = string
  description = "Name of S3 bucket to store the ALB logs to"
  default     = ""
}

variable "lb_logging_prefix" {
  type        = string
  description = "Prefix for the quartz gateway in the logging bucket"
  default     = ""
}

variable "target_group_name" {
  type        = string
  description = "Name of the target group"
}

variable "lb_certificate_arn" {
  type        = string
  description = "ARN of the certificate to associate with the HTTPS listener"
}

# Security group variables
variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "ingress_cidr" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDR ranges that are allowed to access the load balancer"
}

variable "ports" {
  type        = map(any)
  description = "Ports for the LB to listen on"
}

# variable instance_id {
#   type = string
#   description = "ID or ARN of the target for lb target group"
# }
# variable asg_id {
#   type = string
#   description = "ID of asg to attach"
# }

variable "port_80_redirect" {
  type        = bool
  description = "Enable port 80 to 443 redirection for the loadbalancer"
  default     = false
}

variable "health_check_path" {
  type = string
  description = "Health check path to be used for ALB target group"
  default = ""
}
