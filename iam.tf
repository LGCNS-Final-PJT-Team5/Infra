##########################
# EC2->SSM 접속용 IAM Role
##########################
resource "aws_iam_role" "ssm_ec2_role" {
  name = "ssm-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}
# IAM Role에 SSM 권한 정책 연결
resource "aws_iam_role_policy_attachment" "ssm_ec2_attach" {
  role       = aws_iam_role.ssm_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# EC2에 붙일 IAM 인스턴스 프로파일 생성
resource "aws_iam_instance_profile" "ssm_ec2_profile" {
  name = "ssm-ec2-instance-profile"
  role = aws_iam_role.ssm_ec2_role.name
}
