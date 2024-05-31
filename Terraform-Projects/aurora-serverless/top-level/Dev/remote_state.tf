data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket  = "<bucket name from where to import state>"
    key     = "env:/${local.environment}/................."
    region  = "eu-west-2"
    profile = "<your profile here>"
  }
}
