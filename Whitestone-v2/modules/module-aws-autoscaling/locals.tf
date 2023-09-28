locals {
  autoscaling_enabled = var.create_asg && var.create_asg_policy
  autoscaling_enabled_mem = var.create_asg && var.create_asg_policy_mem
  
  create_default_alarms = var.default_alarms_enabled
  create_default_alarms_mem = var.default_alarms_mem_enabled

  default_ec2_alarms_mem = {
    mem_high = {
      alarm_name                = "${aws_autoscaling_group.this[0].name}-mem-utilization-high"
      comparison_operator       = "GreaterThanOrEqualToThreshold"
      evaluation_periods        = var.mem_utilization_high_evaluation_periods
      metric_name               = "mem_used_percent"
      namespace                 = "CWAgent"
      period                    = var.mem_utilization_high_period_seconds
      statistic                 = var.mem_utilization_high_statistic
      threshold                 = var.mem_utilization_high_threshold_percent
      dimensions_name           = "AutoScalingGroupName"
      dimensions_target         = aws_autoscaling_group.this[0].name
      alarm_description         = "Scale up if MEMORY utilization is above ${var.mem_utilization_high_threshold_percent} for ${var.mem_utilization_high_period_seconds} * ${var.mem_utilization_high_evaluation_periods} seconds"
      alarm_actions             = [join("", aws_autoscaling_policy.scale_up_mem.*.arn)]
      treat_missing_data        = "missing"
      ok_actions                = []
      insufficient_data_actions = []
    },
    mem_low = {
      alarm_name                = "${aws_autoscaling_group.this[0].name}-mem-utilization-low"
      comparison_operator       = "LessThanOrEqualToThreshold"
      evaluation_periods        = var.mem_utilization_low_evaluation_periods
      metric_name               = "mem_used_percent"
      namespace                 = "CWAgent"
      period                    = var.mem_utilization_low_period_seconds
      statistic                 = var.mem_utilization_low_statistic
      threshold                 = var.mem_utilization_low_threshold_percent
      dimensions_name           = "AutoScalingGroupName"
      dimensions_target         = aws_autoscaling_group.this.*.name
      alarm_description         = "Scale down if the MEMORYutilization is below ${var.mem_utilization_low_threshold_percent} for ${var.mem_utilization_low_period_seconds} * ${var.mem_utilization_high_evaluation_periods} seconds"
      alarm_actions             = [join("", aws_autoscaling_policy.scale_down_mem.*.arn)]
      treat_missing_data        = "missing"
      ok_actions                = []
      insufficient_data_actions = []
    }
  }
  default_alarms_mem = local.create_default_alarms_mem ? local.default_ec2_alarms_mem : null
  all_alarms_mem     = var.create_asg  ? merge(local.default_alarms_mem, var.custom_alarms) : null

}