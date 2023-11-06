resource "aws_launch_template" "amazon_linux" {
  name_prefix          = "test-node"
  image_id             = data.aws_ami.amazon_linux.id
  instance_type        = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
  }

  user_data = filebase64("userdata.tpl")
}

resource "aws_autoscaling_group" "test_ag" {
  name                 = "test-ag"
  desired_capacity     = 2
  min_size             = 1
  max_size             = 3
  health_check_type    = "EC2"
  vpc_zone_identifier  = [aws_subnet.public1.id, aws_subnet.public2.id]
  termination_policies = ["OldestInstance"]

  launch_template {
    id      = aws_launch_template.amazon_linux.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "test_policy" {
  name                   = "test-policy"
  autoscaling_group_name = aws_autoscaling_group.test_ag.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.test_policy.arn]
  alarm_name          = "test_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "25"
  evaluation_periods  = "5"
  period              = "30"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.test_ag.name
  }
}