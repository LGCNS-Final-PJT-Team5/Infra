# Outer EC2 (Config, API Gateway, Eureka)
resource "aws_instance" "outer_ec2" {
  ami                         = "ami-0fd38d354368dd848"
  instance_type               = "t4g.small"
  subnet_id                   = aws_subnet.private_subnet_app.id
  vpc_security_group_ids      = [aws_security_group.outer_ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ssm_ec2_profile.name
  associate_public_ip_address = false

  tags = {
    Name = "outer-ec2"
  }
}

# Inner EC2 (MSA 서비스)
resource "aws_instance" "inner_ec2" {
  ami                         = "ami-0fd38d354368dd848"
  instance_type               = "t4g.small"
  subnet_id                   = aws_subnet.private_subnet_app.id
  vpc_security_group_ids      = [aws_security_group.inner_ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ssm_ec2_profile.name
  associate_public_ip_address = false

  tags = {
    Name = "inner-ec2"
  }
}
