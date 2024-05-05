## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.48.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_instance_prod"></a> [ec2\_instance\_prod](#module\_ec2\_instance\_prod) | terraform-aws-modules/ec2-instance/aws | n/a |
| <a name="module_remote_server_sg"></a> [remote\_server\_sg](#module\_remote\_server\_sg) | terraform-aws-modules/security-group/aws | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |
| <a name="module_web_server_sg"></a> [web\_server\_sg](#module\_web\_server\_sg) | terraform-aws-modules/security-group/aws//modules/http-80 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_vpc_id"></a> [default\_vpc\_id](#output\_default\_vpc\_id) | n/a |
| <a name="output_ec2_instance_prod"></a> [ec2\_instance\_prod](#output\_ec2\_instance\_prod) | n/a |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | n/a |
