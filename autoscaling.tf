resource "aws_autoscaling_group" "ec2_auto-scaling" {
  max_size            = 3
  min_size            = 2
  desired_capacity    = 2
  name                = "my-web-server-asg"
  target_group_arns   = [aws_lb_target_group.target.arn]
  vpc_zone_identifier = [aws_subnet.private_subnet1.id, aws_subnet.private_submet2.id]

  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }
  health_check_type = "EC2"
}
