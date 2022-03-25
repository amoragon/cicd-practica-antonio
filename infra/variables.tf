variable "bucket" {
  type = map(any)
  default = {
    dev  = "kc-acme-storage-dev"
    prod = "kc-acme-storage-prod"
  }
}

variable "environment" {
  description = "dev or prod values"
  type        = string
}
