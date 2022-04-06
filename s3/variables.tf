variable "bucket_name" {
  type = string

}

variable "account_id" {
  type    = string
  default = "484942116355"
}

variable "owner" {
  type    = string
  default = "mngmnt_deployment_tf"
}

variable "allowed_roles" {
  type = list(string)
}

variable "actions" {
  type = list(string)
}



