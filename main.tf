locals {
  vpc           = "vpc-usa"
  AmbienteProd  = "Producao"
  AmbienteTest  = "Testes"
  AmbienteHomol = "Homolocacao"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  providers = {
    aws = aws.prod
  }

  name = local.vpc
  cidr = "10.0.0.0/16"

  azs            = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Environment = local.AmbienteProd
  }
}

module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  providers = {
    aws = aws.prod
  }

  name                = "web-server"
  description         = "Security group for web-server with HTTP ports open for everyone"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Environment = local.AmbienteProd
  }

}


module "remote_server_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ssh-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id


  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      description = "Grafana"
      cidr_blocks = "0.0.0.0/0"
    },

  ]
}


data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}





module "ec2_instance_prod" {
  source = "terraform-aws-modules/ec2-instance/aws"

  providers = {
    aws = aws.prod
  }

  for_each = toset(["zabbix"])

  name = "instance-${each.key}"

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = "key-name"
  monitoring                  = false
  vpc_security_group_ids      = [module.web_server_sg.security_group_id, module.remote_server_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("zabbix.sh")



  tags = {
    Environment = local.AmbienteProd
  }
}
