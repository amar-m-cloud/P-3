# Define the provider (AWS)
provider "aws" {
  region = "us-east-1" # Choose your preferred region
}

# Create VPC
module "vpc" {
  source = "./modules/vpc"
}

# Create Subnets
module "subnets" {
  source     = "./modules/subnets"
  vpc_id     = module.vpc.vpc_id
  cidr_block = module.vpc.vpc_cidr_block
}

# Create Internet Gateway
module "internet_gateway" {
  source  = "./modules/internet_gateway"
  vpc_id  = module.vpc.vpc_id
}

# Create Route Tables
module "route_tables" {
  source        = "./modules/route_tables"
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.subnets.subnet_ids
  igw_id        = module.internet_gateway.igw_id
}

# Create Security Group
module "security_group" {
  source   = "./modules/security_group"
  vpc_id   = module.vpc.vpc_id
}

# Create Load Balancer
module "load_balancer" {
  source          = "./modules/load_balancer"
  vpc_id          = module.vpc.vpc_id
  security_group  = module.security_group.security_group_id
  subnet_ids      = module.subnets.subnet_ids
}

# Create Auto Scaling Group and Launch Configuration
module "auto_scaling" {
  source           = "./modules/auto_scaling"
  vpc_id           = module.vpc.vpc_id
  load_balancer    = module.load_balancer.load_balancer_name
}

# Deploy WordPress EC2 Instance
module "wordpress" {
  source        = "./modules/wordpress"
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.subnets.subnet_ids
  security_group= module.security_group.security_group_id
}

# Configure Route 53
module "route53" {
  source = "./modules/route53"
  domain = "example.com" # Replace with your domain
  lb_dns = module.load_balancer.load_balancer_dns_name
}

# Output Load Balancer DNS
output "load_balancer_dns" {
  value = module.load_balancer.load_balancer_dns_name
}

# Output Route 53 Name Servers
output "name_servers" {
  value = module.route53.name_servers
}
