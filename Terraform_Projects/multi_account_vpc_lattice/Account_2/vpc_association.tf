resource "aws_vpclattice_service_network_vpc_association" "vpcl-svc-network-vpc-association" {
  vpc_identifier             = "<<<<VPC iD >>>>>"
  service_network_identifier = "<<<<Service network id>>>>>>>"
  security_group_ids         = [aws_security_group.vpcl-svc-network-sg.id]
}

resource "aws_security_group" "vpcl-svc-network-sg" {
  name        = "-vpcl-svc-network-sg"
  vpc_id      = data.aws_vpc.this.id
  description = "Allow access to subgraphs from Helios"

  ingress {
    description = "Allow HTTPS traffic from VPC"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  ingress {
    description = "Allow HTTP traffic from VPC"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #tags = local.common_tags
}