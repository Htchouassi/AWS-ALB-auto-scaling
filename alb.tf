
resource "aws_lb" "loadbalancer" {
  name                       = "alb-project"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.sg-ALB.id]
  subnets                    = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  depends_on                 = [aws_internet_gateway.intergtw_vpc]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "target" {
  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 100
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 6
    unhealthy_threshold = 3
  }
  tags = {
    Name = "My-alb-ec2-tg"
  }
}


resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target.arn
  }
  tags = {
    Name = "My-alb-listener"
  }
}
