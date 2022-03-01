provider "aws" {

    region = "ap-south-1"
    access_key = ""
    secret_key = ""

}


resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
      Name: "${var.env_prifix}-vpc"
    }
  
}

module "myapp-subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  avai_zone = var.avai_zone
  env_prifix = var.env_prifix
  vpc_id = aws_vpc.myapp-vpc.id
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}


module "myapp-server" {
  source = "./modules/webserver"
  vpc_id = aws_vpc.myapp-vpc.id
  my_ip = var.my_ip
  env_prefix = var.env_prefix
  image_name = var.image_name
  associate_public_ip_address = var.public_key_location
  instance_type = var.instance_type
  subnet_id = module.myapp
  avail_zone = var.avail_zone
}
