variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  description = "A short, lowercase name for this project"
  type        = string
  default     = "multi-modal-rag-hub"
}
