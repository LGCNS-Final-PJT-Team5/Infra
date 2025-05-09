# S3 Bucket for Kinesis Firehose Delivery
resource "aws_s3_bucket" "kinesis_bucket" {
  bucket = "modive-kinesis-bucket"

  tags = {
    Name        = "modive-kinesis-bucket"
    Environment = "dev"
  }
}
# Public Access Block 설정
resource "aws_s3_bucket_public_access_block" "kinesis_block" {
  bucket = aws_s3_bucket.kinesis_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
