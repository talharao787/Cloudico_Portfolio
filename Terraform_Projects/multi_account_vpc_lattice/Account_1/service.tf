resource "aws_vpclattice_service" "vpcl-svc" {
  name      = "-vpcl-svc"
  auth_type = "AWS_IAM"
  #custom_domain_name = "example.com"
  #certificate_arn = ""

}

resource "aws_vpclattice_target_group" "vpcl-target-group" {

  name = "-vpcl-target-group"
  type = "ALB"

  config {
    vpc_identifier = "vpc-0c3ea4799ef458315"

    port             = 80
    protocol         = "HTTP"
    protocol_version = "HTTP1"
  }
}

resource "aws_vpclattice_target_group_attachment" "vpcl-target-group-attachment" {
  target_group_identifier = aws_vpclattice_target_group.vpcl-target-group.id

  target {
    id   = "<arn_of_target>"
    port = 80
  }
}

resource "aws_vpclattice_listener" "vpcl-svc-listener" {
  name               = "-vpcl-svc-listener"
  protocol           = "HTTP"
  service_identifier = aws_vpclattice_service.vpcl-svc.id
  default_action {
    forward {
      target_groups {
        target_group_identifier = aws_vpclattice_target_group.vpcl-target-group.id
      }
    }
  }
}

resource "aws_vpclattice_auth_policy" "svc-policy" {
  resource_identifier = aws_vpclattice_service.vpcl-svc.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "*"
        Effect    = "Allow"
        Principal = "*"
        Resource  = "*"
      }
    ]
  })
}