# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = ""
  secret_key = ""
  region = "us-east-1"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "udacityT2" {
  ami = "ami-0742b4e673072066f"
  instance_type = "t2.micro"
   count = 4

}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "udacityM4" {
  ami = "ami-0742b4e673072066f"
  instance_type = "m4.large"
   count = 2

}