variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
  default     = "server-valheim-iac-v2" # <- Alocado aqui!
}

variable "region" {
  default = "southamerica-east1"
}

variable "zone" {
  default = "southamerica-east1-a"
}

variable "vm_name" {
  default = "valheim-server"
}

variable "server_name" {
  default = "Servidor Valheim"
}

variable "world_name" {
  default = "MundoDosDeuses"
}

variable "server_pass" {
  default     = "senhaSegura123"
  sensitive   = true
}

variable "machine_type" {
  description = "Tipo de máquina da VM"
  type        = string
  default     = "e2-standard-2" # ou outro tipo como n1-standard-1, e2-standard-2 etc.
}


variable "server_password" {
  description = "Senha do servidor Valheim"
  type        = string
  sensitive   = true
}
