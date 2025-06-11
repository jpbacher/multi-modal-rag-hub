resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "documents" {
  bucket = "${var.project_name}-docs-${random_id.suffix.hex}"
  acl    = "private"

  tags = {
    Name        = "Document Bucket"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_acl" "documents_acl" {
  bucket = aws_s3_bucket.documents.id
  acl    = "private"
}
