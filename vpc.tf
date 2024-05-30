module "primary_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "test1"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
}

module "secondary_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "test2"
  cidr = "10.1.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]

  enable_nat_gateway = true
}

resource "aws_vpc_peering_connection" "primary_to_secondary" {
  vpc_id      = module.primary_vpc.vpc_id
  peer_vpc_id = module.secondary_vpc.vpc_id
  auto_accept = true
}

resource "aws_route" "primary_to_secondary" {
  for_each                  = toset([module.primary_vpc.private_route_table_ids[0]])
  route_table_id            = each.key
  destination_cidr_block    = module.secondary_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
}

resource "aws_route" "secondary_to_primary" {
  for_each                  = toset([module.secondary_vpc.private_route_table_ids[0]])
  route_table_id            = each.key
  destination_cidr_block    = module.primary_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
}

