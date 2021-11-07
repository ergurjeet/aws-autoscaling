variable "meta" {
  type = object({
    project_slug  = string
    environment   = string
    project_tags  = map(string)
  })
}

variable "vpc_config" {
  type = object({
    cidr            = string
    vpc             = object({
      enable_dns_hostnames = bool
      enable_dns_support   = bool
    })
    azs             = list(string)
    public_subnet   = object({
      cidr          = list(string)
    })
    private_subnet  = object({
      cidr          = list(string)
    })
    nat             = object({
      enabled            = bool
      single_nat_gateway = bool
    })
  })
}

variable "app_config" {
  type = object({
    autoscaling = object({
      minimum = number
      desired = number
      maximum = number
    })
    security_groups = map(object({
      description                                     = string
      ingress_cidr_blocks                             = list(string)
      ingress_rules                                   = list(string)
    }))
    template = object({
      ami_id            = string
      instance_type     = string
      user_data_file    = string
      key_name          = string
    })
  })
}
