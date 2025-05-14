variable "project_id" {
  type        = string
  description = "The ID of the project to create the resources in"
  default     = "uec-koken"
}

variable "region" {
  type        = string
  description = "The region to create the resources in"
  default     = "asia-northeast1"
}