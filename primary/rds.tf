resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-primary-db-subnet-group"
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name = "${var.project_name}-primary-db-subnet-group"
  }
}

resource "aws_db_instance" "primary" {
  identifier = "book-rds"

  engine         = "mysql"
  engine_version = "8.0"
  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  multi_az               = true
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.database.id]

  backup_retention_period = var.backup_retention_days
  copy_tags_to_snapshot   = true
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name     = "${var.project_name}-primary-rds"
    DBRole   = "primary"
    DBEngine = "mysql"
  }
}
