resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_rds_b.id,
    aws_subnet.private_subnet_rds_c.id,
  ]

  tags = {
    Name = "modive-rds-subnet-group"
  }
}

resource "aws_db_instance" "rds" {
  identifier              = "modive-rds"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t4g.small"
  allocated_storage       = 100
  storage_type            = "gp2"
  username                = "modive"
  password                = var.rds_password

  # 두 개 AZ에 속한 서브넷을 포함
  db_subnet_group_name    = aws_db_subnet_group.rds.name

  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  multi_az                = false
  skip_final_snapshot     = true
  publicly_accessible     = false
  deletion_protection     = false

  tags = {
    Name = "modive-rds"
  }
}
