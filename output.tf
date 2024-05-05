output "public_subnets" {
  value = module.vpc.public_subnets
}

output "default_vpc_id" {
  value = module.vpc.default_vpc_id
}


output "ec2_instance_prod" {
  value = module.ec2_instance_prod["zabbix"].public_ip
}

