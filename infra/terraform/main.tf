resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "documents" {
  bucket = "${var.project_name}-docs-${random_id.suffix.hex}"

  tags = {
    Name        = "Document Bucket"
    Environment = "dev"
  }
}

resource "aws_iam_role" "ingest_lambda_role" {
  name = "${var.project_name}-ingest-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}
