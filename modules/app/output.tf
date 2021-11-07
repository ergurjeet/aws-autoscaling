output "elb_zone_id" {
  description = "ELB zond_id"
  value       = aws_lb.alb.zone_id
}

output "elb_dns_name" {
  description = "ELB elb_dns_name"
  value       = aws_lb.alb.dns_name
}
