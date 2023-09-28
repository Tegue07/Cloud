

variable "scale_up_scaling_adjustment" {
  type        = number
  default     = 1
  description = "The number of instances by which to scale. `scale_up_adjustment_type` determines the interpretation of this number (e.g. as an absolute number or as a percentage of the existing Auto Scaling group size). A positive increment adds to the current capacity and a negative value removes from the current capacity"
}

variable "scale_up_adjustment_type" {
  type        = string
  default     = "ChangeInCapacity"
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are `ChangeInCapacity`, `ExactCapacity` and `PercentChangeInCapacity`"
}

variable "scale_up_policy_type" {
  type        = string
  default     = "SimpleScaling"
  description = "The scaling policy type. Currently only `SimpleScaling` is supported"
}

variable "scale_up_cooldown_seconds" {
  type        = number
  default     = 300
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start"
}

variable "scale_down_scaling_adjustment" {
  type        = number
  default     = -1
  description = "The number of instances by which to scale. `scale_down_scaling_adjustment` determines the interpretation of this number (e.g. as an absolute number or as a percentage of the existing Auto Scaling group size). A positive increment adds to the current capacity and a negative value removes from the current capacity"
}

variable "scale_down_adjustment_type" {
  type        = string
  default     = "ChangeInCapacity"
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are `ChangeInCapacity`, `ExactCapacity` and `PercentChangeInCapacity`"
}

variable "scale_down_policy_type" {
  type        = string
  default     = "SimpleScaling"
  description = "The scaling policy type. Currently only `SimpleScaling` is supported"
}

variable "scale_down_cooldown_seconds" {
  type        = number
  default     = 300
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start"
}



locals {
  default_ec2_alarms = {
    cpu_high = {
      alarm_name                = "${aws_autoscaling_group.this[0].name}-cpu-utilization-high"
      comparison_operator       = "GreaterThanOrEqualToThreshold"
      evaluation_periods        = var.cpu_utilization_high_evaluation_periods
      metric_name               = "CPUUtilization"
      namespace                 = "AWS/EC2"
      period                    = var.cpu_utilization_high_period_seconds
      statistic                 = var.cpu_utilization_high_statistic
      threshold                 = var.cpu_utilization_high_threshold_percent
      dimensions_name           = "AutoScalingGroupName"
      dimensions_target         = aws_autoscaling_group.this[0].name
      alarm_description         = "Scale up if CPU utilization is above ${var.cpu_utilization_high_threshold_percent} for ${var.cpu_utilization_high_period_seconds} * ${var.cpu_utilization_high_evaluation_periods} seconds"
      alarm_actions             = [join("", aws_autoscaling_policy.scale_up.*.arn)]
      treat_missing_data        = "missing"
      ok_actions                = []
      insufficient_data_actions = []
    },
    cpu_low = {
      alarm_name                = "${aws_autoscaling_group.this[0].name}-cpu-utilization-low"
      comparison_operator       = "LessThanOrEqualToThreshold"
      evaluation_periods        = var.cpu_utilization_low_evaluation_periods
      metric_name               = "CPUUtilization"
      namespace                 = "AWS/EC2"
      period                    = var.cpu_utilization_low_period_seconds
      statistic                 = var.cpu_utilization_low_statistic
      threshold                 = var.cpu_utilization_low_threshold_percent
      dimensions_name           = "AutoScalingGroupName"
      dimensions_target         = aws_autoscaling_group.this.*.name
      alarm_description         = "Scale down if the CPU utilization is below ${var.cpu_utilization_low_threshold_percent} for ${var.cpu_utilization_low_period_seconds} * ${var.cpu_utilization_high_evaluation_periods} seconds"
      alarm_actions             = [join("", aws_autoscaling_policy.scale_down.*.arn)]
      treat_missing_data        = "missing"
      ok_actions                = []
      insufficient_data_actions = []
    }
  }

  default_alarms = local.create_default_alarms ? local.default_ec2_alarms : null
  all_alarms     = var.create_asg ? merge(local.default_alarms, var.custom_alarms) : null
}

variable "cpu_utilization_high_evaluation_periods" {
  type        = number
  default     = 2
  description = "The number of periods over which data is compared to the specified threshold"
}

variable "cpu_utilization_high_period_seconds" {
  type        = number
  default     = 300
  description = "The period in seconds over which the specified statistic is applied"
}

variable "cpu_utilization_high_statistic" {
  type        = string
  default     = "Average"
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: `SampleCount`, `Average`, `Sum`, `Minimum`, `Maximum`"
}

variable "cpu_utilization_high_threshold_percent" {
  type        = number
  default     = 75
  description = "The value against which the specified statistic is compared"
}

variable "cpu_utilization_low_evaluation_periods" {
  type        = number
  default     = 2
  description = "The number of periods over which data is compared to the specified threshold"
}

variable "cpu_utilization_low_period_seconds" {
  type        = number
  default     = 300
  description = "The period in seconds over which the specified statistic is applied"
}

variable "cpu_utilization_low_statistic" {
  type        = string
  default     = "Average"
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: `SampleCount`, `Average`, `Sum`, `Minimum`, `Maximum`"
}

variable "cpu_utilization_low_threshold_percent" {
  type        = number
  default     = 40
  description = "The value against which the specified statistic is compared"
}

variable "default_alarms_enabled" {
  type        = bool
  default     = false
  description = "Enable or disable cpu and memory Cloudwatch alarms"
}

variable "custom_alarms" {
  type = map(object({
    alarm_name                = string
    comparison_operator       = string
    evaluation_periods        = string
    metric_name               = string
    namespace                 = string
    period                    = string
    statistic                 = string
    threshold                 = string
    treat_missing_data        = string
    ok_actions                = list(string)
    insufficient_data_actions = list(string)
    dimensions_name           = string
    dimensions_target         = string
    alarm_description         = string
    alarm_actions             = list(string)
  }))
  default     = {}
  description = "Map of custom CloudWatch alarms configurations"
}

resource "aws_cloudwatch_metric_alarm" "all_alarms" {
  for_each                  = local.all_alarms
  alarm_name                = format("%s%s", "${aws_autoscaling_group.this[0].name}-", each.value.alarm_name)
  comparison_operator       = each.value.comparison_operator
  evaluation_periods        = each.value.evaluation_periods
  metric_name               = each.value.metric_name
  namespace                 = each.value.namespace
  period                    = each.value.period
  statistic                 = each.value.statistic
  threshold                 = each.value.threshold
  treat_missing_data        = each.value.treat_missing_data
  ok_actions                = each.value.ok_actions
  insufficient_data_actions = each.value.insufficient_data_actions
  dimensions = {
    "${each.value.dimensions_name}" = "${each.value.dimensions_target}"
    "AutoScalingGroupName" = "${aws_autoscaling_group.this[0].name}"
  }

  alarm_description = each.value.alarm_description
  alarm_actions     = each.value.alarm_actions
  tags              = var.tags_as_map
}

resource "aws_cloudwatch_metric_alarm" "all_alarms_mem" {
  for_each                  = local.all_alarms_mem
  alarm_name                = format("%s%s", "${aws_autoscaling_group.this[0].name}-", each.value.alarm_name)
  comparison_operator       = each.value.comparison_operator
  evaluation_periods        = each.value.evaluation_periods
  metric_name               = each.value.metric_name
  namespace                 = each.value.namespace
  period                    = each.value.period
  statistic                 = each.value.statistic
  threshold                 = each.value.threshold
  treat_missing_data        = each.value.treat_missing_data
  ok_actions                = each.value.ok_actions
  insufficient_data_actions = each.value.insufficient_data_actions
  dimensions = {    
    "AutoScalingGroupName" = "${aws_autoscaling_group.this[0].name}"
  }

  alarm_description = each.value.alarm_description
  alarm_actions     = each.value.alarm_actions
  tags              = var.tags_as_map
}