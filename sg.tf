#1. Create Security Group for ALB ( internet --> ALB)
resource "aws_security_group" "sg-ALB" {
  name        = "ALB-sg"
  vpc_id      = aws_vpc.custom_vpc.id
  description = "Security Group for Application Load Balancer"


  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my-alb-sg"
  }
  depends_on = [aws_vpc.custom_vpc]
}


#2. Security Group for ec2 instances  (ALB --> ec2)
resource "aws_security_group" "ec2-sg" {
  name        = "my-ec2-sg"
  vpc_id      = aws_vpc.custom_vpc.id
  description = "Security Group for ec2 Instances"


  ingress {
    description = "allow http"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.sg-ALB.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my-ec2-sg"
    env  = "Dev"
  }
}

