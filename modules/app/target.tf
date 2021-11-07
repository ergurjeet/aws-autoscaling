resource "aws_lb_target_group" "http_80" {
  name     = "${var.meta.project_slug}-${var.meta.environment}-http80-${substr(uuid(), 0, 3)}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.provisioned_vpc.vpc_id

  health_check {
    path                = "/"
    interval            = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 3
  }
  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_autoscaling_attachment" "http_80_app" {
  autoscaling_group_name = aws_autoscaling_group.dynamic.id
  alb_target_group_arn   = aws_lb_target_group.http_80.arn
}
