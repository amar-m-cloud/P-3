# Configure the AWS provider
provider "aws" {
  region = "us-east-1"  # Change this to your preferred region
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "my_vpc"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}

# Create a subnet
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"  # Change this to your preferred availability zone

  tags = {
    Name = "my_subnet"
  }
}

# Create a route table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my_route_table"
  }
}

# Associate the subnet with the route table
resource "aws_route_table_association" "my_subnet_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Create a security group for the EC2 instances
resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id

  # Define your security group rules here (e.g., allow HTTP, HTTPS, SSH)
}

# Create an IAM role for EC2 instances (customize as needed)
resource "aws_iam_role" "my_ec2_role" {
  name = "my_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach an IAM policy to the role (customize as needed)
resource "aws_iam_instance_profile" "my_instance_profile" {
  name = "my_instance_profile"

  roles = [aws_iam_role.my_ec2_role.name]
}

# Create an EC2 instance with user data (WordPress installation script)
resource "aws_instance" "my_ec2_instance" {
  ami             = "ami-12345678"  # Replace with the desired AMI ID
  instance_type   = "t2.micro"      # Change this based on your requirements
  key_name        = "your_key_pair_name"  # Replace with your key pair name

  subnet_id       = aws_subnet.my_subnet.id
  security_group  = [aws_security_group.my_security_group.id]
  iam_instance_profile = aws_iam_instance_profile.my_instance_profile.name

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd mysql php php-mysql

              # Download and install WordPress (customize as needed)
              wget https://wordpress.org/latest.tar.gz
              tar -xzf latest.tar.gz -C /var/www/html/
              sudo chown -R apache:apache /var/www/html/wordpress
              sudo chmod -R 755 /var/www/html/wordpress
              sudo service httpd start
              sudo chkconfig httpd on
              EOF

  tags = {
    Name = "my_ec2_instance"
  }
}

# Create a basic Elastic Load Balancer
resource "aws_elb" "my_elb" {
  name               = "my-elb"
  subnets            = [aws_subnet.my_subnet.id]
  security_groups    = [aws_security_group.my_security_group.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

# Create an Auto Scaling Launch Configuration
resource "aws_launch_configuration" "my_launch_config" {
  name = "my-launch-config"
  image_id = "ami-12345678"  # Replace with the desired AMI ID
  instance_type = "t2.micro"  # Change this based on your requirements

  security_groups = [aws_security_group.my_security_group.id]
  iam_instance_profile = aws_iam_instance_profile.my_instance_profile.name

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd mysql php php-mysql
              EOF
}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "my_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  vpc_zone_identifier = [aws_subnet.my_subnet.id]
  launch_configuration = aws_launch_configuration.my_launch_config.id
}

# Create a Route 53 record
resource "aws_route53_record" "my_dns_record" {
  name    = "my-website"
  type    = "A"
  zone_id = "your_zone_id"  # Replace with your Route 53 hosted zone ID

  alias {
    name                   = aws_elb.my_elb.dns_name
    zone_id                = aws_elb.my_elb.zone_id
    evaluate_target_health = true
  }
}

# Output the ELB DNS name
output "elb_dns_name" {
  value = aws_elb.my_elb.dns_name
}
