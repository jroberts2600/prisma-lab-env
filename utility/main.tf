provider "aws" {
  region = "us-east-1"
}

resource "random_pet" "pet_name" {
  length    = 3
  separator = "-"
}
