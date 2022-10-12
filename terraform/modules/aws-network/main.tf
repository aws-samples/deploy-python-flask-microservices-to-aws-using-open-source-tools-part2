resource "aws_vpc" "vpc" {
  cidr_block                 = var.aws_vpc_cidr
  enable_dns_support         = "true"
  enable_dns_hostnames       = "true"
}

resource "aws_internet_gateway" "igw" {
  vpc_id                     = aws_vpc.vpc.id
}

resource "aws_subnet" "private_subnet_1" {
  map_public_ip_on_launch    = "true"
  availability_zone          = var.availability_zone_1
  vpc_id                     = aws_vpc.vpc.id
  cidr_block                 = var.private_subnet_1_cidr_block
}

resource "aws_subnet" "private_subnet_2" {
  map_public_ip_on_launch    = "true"
  availability_zone          = var.availability_zone_2
  vpc_id                     = aws_vpc.vpc.id
  cidr_block                 = var.private_subnet_2_cidr_block
}

resource "aws_subnet" "public_subnet_1" {
  map_public_ip_on_launch    = "true"
  availability_zone          = var.availability_zone_1
  vpc_id                     = aws_vpc.vpc.id
  cidr_block                 = var.public_subnet_1_cidr_block
}

resource "aws_subnet" "public_subnet_2" {
  map_public_ip_on_launch    = "true"
  availability_zone          = var.availability_zone_2
  vpc_id                     = aws_vpc.vpc.id
  cidr_block                 = var.public_subnet_2_cidr_block
}

resource "aws_route_table" "aws_route_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_eip" "nat_1" {
  vpc = true
}

resource "aws_nat_gateway" "ngw_1" {
  subnet_id                  = aws_subnet.public_subnet_1.id
  allocation_id              = aws_eip.nat_1.id
  depends_on                 = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_1" {
  vpc_id                     = aws_vpc.vpc.id
}

resource "aws_route_table" "private_2" {
  vpc_id                     = aws_vpc.vpc.id
}

resource "aws_route" "private_1" {
  route_table_id             = aws_route_table.private_1.id
  destination_cidr_block     = "0.0.0.0/0"
  nat_gateway_id             = aws_nat_gateway.ngw_1.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id                  = aws_subnet.private_subnet_1.id
  route_table_id             = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id                  = aws_subnet.private_subnet_2.id
  route_table_id             = aws_route_table.private_2.id
}

resource "aws_route_table" "public" {
  vpc_id                     = aws_vpc.vpc.id
}

resource "aws_route" "public" {
  route_table_id             = aws_route_table.public.id
  destination_cidr_block     = "0.0.0.0/0"
  gateway_id                 = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id                  = aws_subnet.public_subnet_1.id
  route_table_id             = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id                  = aws_subnet.public_subnet_2.id
  route_table_id             = aws_route_table.public.id
}

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_network_acl_rule" "public_ingress" {
  network_acl_id             = aws_network_acl.public.id
  rule_number                = 100
  protocol                   = "-1"
  rule_action                = "allow"
  cidr_block                 = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_egress" {
  network_acl_id             = aws_network_acl.public.id
  rule_number                = 100
  egress                     = true
  protocol                   = "-1"
  rule_action                = "allow"
  cidr_block                 = "0.0.0.0/0"

}

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_network_acl_rule" "private_ingress" {
  network_acl_id             = aws_network_acl.private.id
  rule_number                = 100
  protocol                   = "-1"
  rule_action                = "allow"
  cidr_block                 = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_egress" {
  network_acl_id             = aws_network_acl.private.id
  rule_number                = 100
  egress                     = true
  protocol                   = "-1"
  rule_action                = "allow"
  cidr_block                 = "0.0.0.0/0"
}
