resource "aws_lb_target_group" "demo_tg" {
  name        = "demo-tg"
  port        = 80
  vpc_id      = aws_vpc.demo.id
  protocol    = "HTTP"

  health_check {
    path = "/"
  }
}

resource "aws_lb" "demo_lb" {
  name               = "demo-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.demo_sg.id]
  subnets            = [aws_subnet.lb1.id, aws_subnet.lb2.id]

  tags = {
    Name = "demo-lb"
  }
}

resource "aws_autoscaling_attachment" "attach" {
  autoscaling_group_name = aws_autoscaling_group.test_ag.name
  lb_target_group_arn = aws_lb_target_group.demo_tg.arn
}

resource "aws_lb_listener" "demo-listen" {
  load_balancer_arn = aws_lb.demo_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo_tg.arn
  }
}