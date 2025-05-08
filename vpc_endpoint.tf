###########################
# S3 Gateway Endpoint
###########################
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main_vpc.id
  service_name = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.private_rt.id]

  tags = {
    Name = "vpce-s3"
  }
}

###########################
# ECR (Interface Endpoints)
###########################

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.ap-northeast-2.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private_subnet_app.id]
  security_group_ids = [aws_security_group.inner_ec2_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "vpce-ecr-api"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.ap-northeast-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private_subnet_app.id]
  security_group_ids = [aws_security_group.inner_ec2_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "vpce-ecr-dkr"
  }
}

resource "aws_vpc_endpoint" "sts" {
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.ap-northeast-2.sts"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private_subnet_app.id]
  security_group_ids = [aws_security_group.inner_ec2_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "vpce-sts"
  }
}

###########################
# SSM (Session Manager)
###########################

resource "aws_vpc_endpoint" "ssm" { # SSM API 호출
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.ap-northeast-2.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private_subnet_app.id]
  security_group_ids = [aws_security_group.inner_ec2_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "vpce-ssm"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" { # EC2와 메시지 교환
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.ap-northeast-2.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private_subnet_app.id]
  security_group_ids = [aws_security_group.inner_ec2_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "vpce-ssmmessages"
  }
}

resource "aws_vpc_endpoint" "ec2messages" { # EC2 관리 메시지 송수신
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.ap-northeast-2.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private_subnet_app.id]
  security_group_ids = [aws_security_group.inner_ec2_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "vpce-ec2messages"
  }
}

###########################
# Kinesis Interface Endpoint
###########################
resource "aws_vpc_endpoint" "kinesis" {
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.ap-northeast-2.kinesis-streams"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private_subnet_app.id]
  security_group_ids = [aws_security_group.outer_ec2_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "kinesis-interface-endpoint"
  }
}

