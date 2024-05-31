resource "aws_vpclattice_service_network" "vpcl-svc-network" {
  name      = "vpcl-svc-network"
  auth_type = "AWS_IAM"
}
resource "aws_vpclattice_auth_policy" "svc-network-policy" {
  resource_identifier = aws_vpclattice_service_network.vpcl-svc-network.arn
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

resource "aws_vpclattice_service_network_service_association" "example" {
  service_identifier         = aws_vpclattice_service.vpcl-svc.id
  service_network_identifier = aws_vpclattice_service_network.vpcl-svc-network.id
}