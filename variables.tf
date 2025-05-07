variable "rds_password" {
  description = "Password for the RDS master user"
  type        = string
  sensitive   = true
}
