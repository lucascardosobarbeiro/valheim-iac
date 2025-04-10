# ☁️ Valheim Dedicated Server on Google Cloud (IaC + Monitoring)

Este projeto provisiona automaticamente um servidor dedicado de **Valheim** utilizando **Google Cloud Platform (GCP)**, com **Terraform**, **Docker**, **monitoramento via Cloud Monitoring**, e automações de startup com scripts bash.

---

## ✅ O que já foi feito

### 🌐 Infraestrutura como Código (IaC)

- Provisionamento de uma VM com Terraform
- Configuração de firewall para liberar as portas UDP 2456–2458 (Valheim)
- Atribuição de um disco persistente e volume Docker para salvar dados do servidor

### 🐳 Docker

- Utilização da imagem [lloesche/valheim-server](https://hub.docker.com/r/lloesche/valheim-server)
- Volume `/opt/valheim-data` configurado para persistir os dados (saves, configs)
- Container configurado com variáveis de ambiente para nome, senha e mundo

### 🚀 Script de Startup

- Script bash automatizado via `metadata_startup_script` no Terraform
- Instalação de dependências e inicialização do servidor Docker automaticamente

### 📊 Monitoramento com Cloud Monitoring

- Script `send_player_count.sh` envia a quantidade de jogadores conectados via métrica customizada do GCP
- Cronjob configurado para execução a cada 5 minutos
- Métrica: `custom.googleapis.com/valheim/players_online`

---

## 🛠️ O que ainda será implementado

- [ ] **Alertas com Cloud Monitoring**
  - Notificações por e-mail quando players entrarem ou o servidor ficar inativo
- [ ] **Bot Discord (Opcional)**
  - Comando para ligar o servidor e exibir status online
- [ ] **Página Web simples**
  - Mostrar o status do servidor e número de jogadores em tempo real
- [ ] **Backup automático para Cloud Storage**
  - Backups dos mundos em GCS com versão e retenção

---

## 📂 Estrutura do Projeto
. ├── main.tf # Infraestrutura principal com Terraform ├── variables.tf # Variáveis utilizadas ├── startup_script.sh # Script de inicialização da VM ├── scripts/ │ └── send_player_count.sh # Script de monitoramento de players └── README.md 
