module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.10.0"

  name = "${var.meta.project_slug}-${var.meta.environment}"
  cidr = var.vpc_config.cidr

  azs             = var.vpc_config.azs
  public_subnets  = var.vpc_config.public_subnet.cidr
  private_subnets = var.vpc_config.private_subnet.cidr

  enable_nat_gateway  = var.vpc_config.nat.enabled
  single_nat_gateway  = var.vpc_config.nat.single_nat_gateway
 # reuse_nat_ips       = var.vpc_config.nat.reuse_nat_ips
 # external_nat_ip_ids = aws_eip.nat.*.id

  enable_dns_hostnames = var.vpc_config.vpc.enable_dns_hostnames
  enable_dns_support   = var.vpc_config.vpc.enable_dns_support
}