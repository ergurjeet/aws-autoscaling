resource "aws_lb" "alb" {
  name               = "${var.meta.project_slug}-${var.meta.environment}"
  internal           = false
  load_balancer_type = "application"
  subnets                   = var.provisioned_vpc.public_subnets
  security_groups           = [aws_security_group.sgs["alb"].id]

  # enable_deletion_protection = true
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http_80.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Well, our nodes do not accept that connection yet :("
      status_code  = "200"
    }
  }
}
