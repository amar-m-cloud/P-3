variable "vpc_id" {}
variable "load_balancer" {}

resource "aws_launch_configuration" "main" {
  name = "wordpress-launch-config"
  image_id = "ami-0c55b159cbfafe1f0" # Replace with your preferred AMI
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "main" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  health_check_type    = "EC2"
  health_check_grace_period = 300
  force_delete         = true

  launch_configuration = aws_launch_configuration.main.id
  vpc_zone_identifier  = [var.vpc_id]
  load_balancers       = [var.load_balancer]
}
