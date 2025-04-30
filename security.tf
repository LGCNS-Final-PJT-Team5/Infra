##############################
# outer_EC2_sg: API Gateway, Config, Eureka 용
##############################

resource "aws_security_group" "outer_ec2_sg" {
  name        = "outer-ec2-sg"
  description = "Allow external access to API Gateway and internal access to inner EC2"
  vpc_id      = aws_vpc.main_vpc.id

  # 인바운드 규칙
  # SSM 전용이므로 인바운드 규칙 필요 없음

  # 아웃바운드 규칙
  # inner EC2와 통신 포함한 모든 아웃바운드 허용 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "outer-ec2-sg"
  }
}

##############################
# inner_EC2_sg: 내부 마이크로서비스 (auth, user, 등)
##############################

resource "aws_security_group" "inner_ec2_sg" {
  name        = "inner-ec2-sg"
  description = "Allow traffic from outer EC2, and allow access to RDS"
  vpc_id      = aws_vpc.main_vpc.id

  # 인바운드 규칙
  # outer EC2에서 들어오는 요청만 허용
  ingress {
    description     = "Allow traffic from outer EC2"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.outer_ec2_sg.id]
  }

  # 아웃바운드 규칙
  # RDS와 통신 포함한 모든 아웃바운드 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "inner-ec2-sg"
  }
}

##############################
# rds_sg
##############################

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  vpc_id      = aws_vpc.main_vpc.id

  # 인바운드 규칙
  # inner_sg를 가진 인스턴스만 MySQL 포트(3306)로 접근 가능
  ingress {
    description     = "MySQL access from inner EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.inner_ec2_sg.id]
  }

  # 아웃바운드 규칙
  # inner EC2 응답 포함한 모든 아웃바운드 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}
