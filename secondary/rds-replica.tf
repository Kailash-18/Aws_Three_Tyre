data "aws_db_instance" "primary" {
  provider               = aws.primary
  db_instance_identifier = "kailash-db"
}

resource "aws_db_subnet_group" "replica" {
  name       = "${var.project_name}-secondary-db-subnet-group"
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name = "${var.project_name}-secondary-db-subnet-group"
  }
}

resource "aws_db_instance" "replica" {
  identifier = "kailash-db-replica"

  engine         = "mysql"
  instance_class = "db.t3.micro"

  replicate_source_db = data.aws_db_instance.primary.arn

  db_subnet_group_name   = aws_db_subnet_group.replica.name
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = false

  storage_encrypted = true

  backup_retention_period = var.backup_retention_days
  copy_tags_to_snapshot   = true
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name   = "${var.project_name}-secondary-read-replica"
    DBRole = "read-replica"
  }
}
