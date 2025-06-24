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

resource "aws_iam_policy" "ingest_policy" {
  name = "${var.project_name}-ingest-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Resource = [
          aws_s3_bucket.documents.arn,
          "${aws_s3_bucket.documents.arn}/*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ingest_attach" {
  role       = aws_iam_role.ingest_lambda_role.name
  policy_arn = aws_iam_policy.ingest_policy.arn
}

resource "aws_ecr_repository" "ingest_repo" {
  name = "${var.project_name}-ingest"  
  image_tag_mutability = "MUTABLE"
  tags = {
    Environment = "dev"
    Project     = var.project_name
  }
}

resource "aws_lambda_function" "ingest" {
  function_name = "${var.project_name}-ingest"
  package_type  = "Image"  
  image_uri     = "${aws_ecr_repository.ingest_repo.repository_url}:latest"
  role = aws_iam_role.ingest_lambda_role.arn
  architectures = ["arm64"]
  
  timeout     = 30
  memory_size = 512

  depends_on = [
    aws_iam_role_policy_attachment.ingest_attach
  ]
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ingest.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.documents.arn
}

resource "aws_s3_bucket_notification" "on_upload" {
  bucket = aws_s3_bucket.documents.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.ingest.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
