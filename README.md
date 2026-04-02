# Azure Secure 3-Tier Web Architecture

Infrastructure as Code project provisioning a secure, scalable 3-tier web architecture on Azure using Terraform. Built to demonstrate Azure cloud engineering competencies aligned with enterprise and regulated-industry standards.

## Architecture
```
Internet
    |
Azure Load Balancer (public subnet 10.0.1.0/24)
    |
VM Scale Set — 2 to 5 instances (private subnet 10.0.2.0/24)
    |
Key Vault + Data tier (private subnet 10.0.3.0/24)
```

## What this provisions

**Networking**
- Virtual Network (VNet) — 10.0.0.0/16
- 3 subnets: public, app tier, data tier
- Network Security Groups on every subnet with least-privilege rules
- Public subnet: allows ports 80 and 443 from internet only
- App subnet: allows port 80 from public subnet only
- Data subnet: allows port 5432 from app subnet only

**Compute**
- Azure Load Balancer with public IP and HTTP health probe
- Linux VM Scale Set running Ubuntu 22.04 with nginx
- Autoscaling: scales out at 75% CPU, scales in at 25% CPU, min 2 max 5 instances

**Security**
- Azure Key Vault with soft delete and access policies
- Secrets stored in Key Vault, not in code
- NSGs enforce network segmentation at every tier
- Service principal with Contributor role scoped to subscription

**Observability**
- Log Analytics workspace with 30-day retention
- Azure Monitor metric alert — fires when CPU exceeds 80%
- Monitor action group for alert routing

**CI/CD**
- GitHub Actions pipeline runs on every push to main
- Steps: terraform fmt, init, validate, plan
- Azure credentials stored as GitHub secrets, never in code

## Tech stack

- Azure (VNet, Load Balancer, VMSS, Key Vault, Monitor, Log Analytics)
- Terraform — modular structure with networking, compute, and database modules
- GitHub Actions
- Ubuntu 22.04, nginx

## Repository structure
```
.
├── main.tf                  # Root module, provider config
├── variables.tf             # Input variable declarations
├── outputs.tf               # Root outputs
├── modules/
│   ├── networking/          # VNet, subnets, NSGs
│   ├── compute/             # Load balancer, VMSS, autoscaling
│   └── database/            # Key Vault, Log Analytics, Monitor
└── .github/
    └── workflows/
        └── terraform.yml    # CI/CD pipeline
```

## How to deploy

Prerequisites: Azure CLI, Terraform, an Azure subscription.
```bash
# Authenticate to Azure
az login

# Create a service principal
az ad sp create-for-rbac \
  --name "terraform-sp" \
  --role="Contributor" \
  --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"

# Add credentials to terraform.tfvars (never commit this file)
subscription_id = "your-subscription-id"
tenant_id       = "your-tenant-id"
client_id       = "your-client-id"
client_secret   = "your-client-secret"

# Deploy
terraform init
terraform apply

# Tear down
terraform destroy
```

## Alignment with enterprise cloud standards

| Requirement | Implementation |
|---|---|
| Infrastructure as Code | All resources provisioned via Terraform, zero manual portal clicks |
| Network segmentation | 3-tier subnet model with NSG rules enforcing least-privilege traffic flow |
| Secrets management | Azure Key Vault — no credentials stored in code or state |
| High availability | VMSS across multiple instances with load balancer health probes |
| Auto scaling | CPU-based autoscale rules, 2 to 5 instances |
| Observability | Azure Monitor alerts and Log Analytics workspace |
| CI/CD compliance | GitHub Actions validates every change before it reaches main |

## Author

Jhumari Thomas — Cloud and DevOps Engineer
[linkedin.com/in/jhumarithomas](https://linkedin.com/in/jhumarithomas) | [github.com/JJThomas1](https://github.com/JJThomas1)
