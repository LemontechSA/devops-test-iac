resource "aws_security_group" "default_elasticache" {
  name_prefix = "test-elasticache"
  vpc_id      = module.secondary_vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "default" {
  name       = "test-cache-subnet"
  subnet_ids = module.secondary_vpc.private_subnets
}

resource "aws_elasticache_cluster" "test" {
  availability_zone    = "us-east-1a"
  az_mode              = "single-az"
  cluster_id           = "test"
  engine               = "redis"
  engine_version       = "6.0"
  node_type            = "cache.m5.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  port                 = 6379

  security_group_ids = [aws_security_group.default_elasticache.id]
  subnet_group_name  = aws_elasticache_subnet_group.default.name
}
