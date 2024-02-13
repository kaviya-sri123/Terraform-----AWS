provider "aws" {
  region     = "us-east-1"
 }

resource "aws_vpc" "vpc_task" {
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "prod"
  }
}
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.vpc_task.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-subnet"
  }
}

resource "aws_instance" "ec2task" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"
}

resource "aws_dynamodb_table_item" "dbitems" {
  table_name = aws_dynamodb_table.db.name
  hash_key   = aws_dynamodb_table.db.hash_key

  item = <<ITEM
{
  "exampleHashKey": {"S": "something"},
  "one": {"N": "11111"},
  "two": {"N": "22222"},
  "three": {"N": "33333"},
  "four": {"N": "44444"}
}
ITEM
}

resource "aws_dynamodb_table" "db" {
  name           = "demo db"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "exampleHashKey"

  attribute {
    name = "exampleHashKey"
    type = "S"
  }
}
resource "aws_db_instance" "rds-db" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "postgresql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "kaviya"
  password             = "kaviyasri"
}
resource "aws_s3_bucket" "demos3" {
  bucket = "demos3-bucket"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.demos3.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.demos3.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_opensearch_domain" "example" {
  domain_name    = "example"
  engine_version = "Elasticsearch_7.10"

  cluster_config {
    instance_type = "r4.large.search"
  }

  tags = {
    Domain = "TestDomain"
  }
}
resource "aws_elasticache_cluster" "example" {
  cluster_id           = "cluster-example"
  engine               = "redis"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
}

