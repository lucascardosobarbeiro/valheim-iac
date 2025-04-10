variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
  default     = "server-valheim-iac-v2" # <- Alocado aqui!
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "vm_name" {
  default = "valheim-server"
}
