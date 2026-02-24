variable "token" {
  description = "Timeweb Cloud API token"
  type        = string
  sensitive   = true
}

variable "ssh_private_key_path" {
  description = "Путь до приватного SSH-ключа для provisioner"
  type        = string
  default     = "~/.ssh/id_rsa"
}
