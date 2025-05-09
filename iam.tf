data "aws_caller_identity" "current" {}

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



###################################
# IoT core -> Kinesis 전송용 IAM Role
###################################

# 1. IAM Role 
resource "aws_iam_role" "iot_to_kinesis_role" {
  name = "iot-to-kinesis-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "iot.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

# 2. IAM Policy (Kinesis로 Put 할 수 있는 권한)
resource "aws_iam_policy" "iot_kinesis_policy" {
  name = "iot-to-kinesis-policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ],
        "Resource": [
          "arn:aws:kinesis:ap-northeast-2:${data.aws_caller_identity.current.account_id}:stream/sensor-data-stream",
          "arn:aws:kinesis:ap-northeast-2:${data.aws_caller_identity.current.account_id}:stream/event-data-stream"
        ]
      }
    ]
  })
}

# 3. Role에 Policy 연결
resource "aws_iam_role_policy_attachment" "attach_iot_kinesis_policy" {
  role       = aws_iam_role.iot_to_kinesis_role.name
  policy_arn = aws_iam_policy.iot_kinesis_policy.arn
}
