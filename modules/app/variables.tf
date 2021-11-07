variable "meta" {}

variable "app_config" {}

variable "provisioned_vpc" {
  type        = object({
    vpc_id          = string
    public_subnets  = list(string)
  })
}
