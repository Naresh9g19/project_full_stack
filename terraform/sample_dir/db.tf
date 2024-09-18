
provider "aws" {
  region = var.region["eu"]
  profile                 = "default"
}



resource "aws_security_group" "dbsg" {
  #vpc_id      = "${data.aws_vpc.default.id}"
  name        = "dbsg"
  description = "Allow all inbound for Postgres"
ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_instance" "database_instance" {
  identifier             = "database_instance"
  engine_version       = "14.10"
  db_name              = "sampleDB"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  #PostgreSQL 14.12-R2
  #engine_version         = "14.12"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.dbsg.id]
  username               = "postgres"
  password               = "dhoni777"
}