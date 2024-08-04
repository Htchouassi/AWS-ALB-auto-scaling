resource "aws_launch_template" "ec2_launch_template" {
  name          = "my_web_server_template"
  image_id      = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  network_interfaces {
    associate_public_ip_address = false
    security_groups              = [aws_security_group.ec2-sg.id]
  }
  user_data = filebase64("userdata.sh")
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "my-ec2-web-server"
    }
  }
}