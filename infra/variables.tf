variable "bucket" {
    type = map
    default = {
        dev =  "kc-acme-storage-dev"
        prod = "kc-acme-storage-prod"
    }
}

variable "environment" {
    description = "dev or prod values"
    type = string
}
