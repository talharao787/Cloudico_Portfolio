resource "aws_ram_resource_share" "svc-network-share" {
  name                      = "svc-service-network-share"
  allow_external_principals = false

}
resource "aws_ram_sharing_with_organization" "oraganization-enabled" {}

resource "aws_ram_resource_association" "svc-network-share-association" {
  resource_arn       = aws_vpclattice_service_network.vpcl-svc-network.arn
  resource_share_arn = aws_ram_resource_share.svc-network-share.arn
}

resource "aws_ram_principal_association" "svc-network-share-principal" {
  principal          = "arn_of_principal"
  resource_share_arn = aws_ram_resource_share.svc-network-share.arn
}