variable "asg_ebs_volume" {
  type = list(object({
    device_name = string
    ebs = object({
      volume_size           = number
      volume_type           = optional(string, "gp2")
      encrypted             = optional(bool, true)
      delete_on_termination = optional(bool, true)
      iops                  = optional(number, null)
    })
  }))
  default = []
}

variable "application_name" {
  type        = string
  default     = "node"
  description = "name of the application"
}

variable "environment" {
  type        = string
  description = "This is the name of the environment"
  default     = "prod"
}



variable "tags" {
  type    = map(any)
  default = {}
}