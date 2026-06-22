terraform {
  backend "s3" {
    bucket = "rjnoord-ecs-tf-state"
    key    = "ecs-fargate/terraform.tfstate"
    region = "us-east-1"

  }
}

