# ☁️ Projeto Valheim na GCP com Terraform

## Objetivo
Provisionar automaticamente uma VM na Google Cloud para rodar um servidor Valheim usando Docker, com:

- IP fixo
- Firewall configurado
- Persistência com volume Docker
- Métrica personalizada `players_online` no Cloud Monitoring
- Backup automático com Auto Snapshots

---

## Infraestrutura Criada

### Rede
- **VPC personalizada:** `valheim-network`
- **Sub-rede:** `valheim-subnet` com CIDR `10.10.0.0/24`
- **Firewall:**
  - Libera UDP `2456-2458` (porta do Valheim)
  - Libera TCP `22` (SSH)

### VM: `valheim-server`
- **Tipo:** `e2-highmem-2` (2 vCPUs / 16 GB RAM)
- **Imagem:** Ubuntu 22.04
- **Disco:** 20 GB padrão + auto snapshot diário
- **IP externo:** fixo via `google_compute_address`
- **Tag de rede:** `valheim`

### Docker + UFW
- Docker instalado e configurado
- UFW habilitado com portas necessárias
- Container `lloesche/valheim-server` com variáveis:
  - `SERVER_NAME`
  - `WORLD_NAME`
  - `SERVER_PASS`

### Monitoramento
- Cloud Ops Agent instalado
- Script `/opt/monitoring/send_metric.sh`:
  - Executa a cada 5 minutos via cron
  - Envia métrica `custom.googleapis.com/valheim/players_online` com base em conexões na porta UDP 2456

### Backup Automático (Snapshot)
- Política de snapshot diário configurada com retenção de 7 dias: `auto-snapshot-daily`
- Disco da VM vinculado automaticamente à política

---

## Estrutura dos Arquivos

```
.
├── main.tf                 # Infraestrutura principal
├── variables.tf            # Variáveis do projeto
├── startup_script.tmpl     # Script de inicialização da VM
└── terraform.tfvars        # (opcional) valores personalizados
```

---

## Como Usar

```bash
# Inicializa o Terraform
terraform init

# Visualiza o que será criado
terraform plan

# Cria os recursos na GCP
terraform apply
```

---

## Autor
Projeto criado por Lucas, como parte de aprendizado e prática de infraestrutura moderna com GCP e Terraform. ✨

