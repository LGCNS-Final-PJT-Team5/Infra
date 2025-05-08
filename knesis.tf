resource "aws_kinesis_stream" "raw_event_stream" {
  name             = "sensor-data-stream"
  shard_count      = 1
  retention_period = 24

  tags = {
    Environment = "dev"
    Name        = "sensor-data-stream"
  }
}

resource "aws_kinesis_stream" "processed_event_stream" {
  name             = "event-data-stream"
  shard_count      = 1
  retention_period = 24

  tags = {
    Environment = "dev"
    Name        = "event-data-stream"
  }
}
