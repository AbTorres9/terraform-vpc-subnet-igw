provider "aws" {        
  region = "us-east-1"
}


#1. create your VPC
resource "aws_vpc" "MyVpc1" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "MyVpc1"
    }
}   

#2. create a public subnet 
resource "aws_subnet" "PublicSubnet" {
    vpc_id = aws_vpc.MyVpc1.id
    availability_zone = "us-east-1a"
    cidr_block = "10.0.6.0/24"
}

#3. create a private subnet
resource "aws_subnet" "PrivateSubnet" {
    vpc_id = aws_vpc.MyVpc1.id
    cidr_block = "10.0.5.0/24"
    map_public_ip_on_launch = true
}

#4. create an IGW
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.MyVpc1.id
}

#5. route tables for public subnet 
resource "aws_route_table" "PublicRT" {
    vpc_id = aws_vpc.MyVpc1.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myigw.id
    }
}

#6 route table association with public subnet
resource "aws_route_table_association" "PublicRouteTableAssociation" {
  subnet_id = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.PublicRT.id
}

