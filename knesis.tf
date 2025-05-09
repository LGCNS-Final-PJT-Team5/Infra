# #####################################
# # Kinesis Data stream (sensor, event)
# #####################################
resource "aws_kinesis_stream" "sensor_data_stream" {
  name             = "sensor-data-stream"
  shard_count      = 1
  retention_period = 24

  tags = {
    Environment = "dev"
    Name        = "sensor-data-stream"
  }
}

resource "aws_kinesis_stream" "event_data_stream" {
  name             = "event-data-stream"
  shard_count      = 1
  retention_period = 24

  tags = {
    Environment = "dev"
    Name        = "event-data-stream"
  }
}

# ####################
# # Kinesis FireHose 
# ####################

resource "aws_kinesis_firehose_delivery_stream" "to_s3" {
  name        = "modive-firehose-to-s3"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.sensor_data_stream.arn
    role_arn           = aws_iam_role.firehose_role.arn
  }

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.kinesis_bucket.arn
    buffering_size     = 1
    buffering_interval = 10
    compression_format = "UNCOMPRESSED"
  }

  tags = {
    Environment = "dev"
    Name        = "modive-firehose"
  }
}

