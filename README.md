# RoboShop Azure Infrastructure via Terraform

[![Terraform](https://img.shields.io/badge/Terraform-%235843D9.svg?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=flat&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/)
[![Ansible](https://img.shields.io/badge/Ansible-%23EE0000.svg?style=flat&logo=ansible&logoColor=white)](https://www.ansible.com/)

This repository contains the Infrastructure as Code (IaC) configuration in Terraform (HCL) to provision and manage the infrastructure for the **RoboShop** microservices-based application on Microsoft Azure.

The architecture utilizes a hybrid deployment model:
1. **Stateful Database Services** (MySQL, MongoDB, Valkey, RabbitMQ) run on isolated **Azure Linux Virtual Machines (VMs)**.
2. **Stateless Application & Frontend Tiers** (Catalogue, User, Cart, Shipping, Payment, Orders, Ratings, Frontend) run on an **Azure Kubernetes Service (AKS)** cluster.

---

## 📌 Architecture Overview

```mermaid
graph TD
    subgraph Azure Cloud Environment
        subgraph VNet (test-virtual-network)
            subgraph Default Subnet
                NAT[NAT Gateway] -->|Egress| Internet[Public Internet]
                AKS[Azure Kubernetes Cluster]
                
                subgraph Database Virtual Machines
                    MySQL[MySQL VM]
                    Mongo[MongoDB VM]
                    Valkey[Valkey VM]
                    Rabbit[RabbitMQ VM]
                end
            end
        end

        DNS[Azure DNS Zone: naresh-training.online]
        ACR[Azure Container Registry: nareshroboshop]
        PIP[Static Public IP]
    end

    %% Network relationships
    AKS -->|Role Assignment: Network Contributor| VNet
    AKS -->|Role Assignment: AcrPull| ACR
    PIP -->|Maps Ingress| DNS
    MySQL -->|Bootstrap: ansible-pull| MySQL
    Mongo -->|Bootstrap: ansible-pull| Mongo
    Valkey -->|Bootstrap: ansible-pull| Valkey
    Rabbit -->|Bootstrap: ansible-pull| Rabbit
```

- **Egress Gateway**: A NAT Gateway associated with the default subnet provides secure, outbound-only internet connectivity for the virtual machines and Kubernetes cluster node pool.
- **Service Resolution**: MySQL, MongoDB, Valkey, and RabbitMQ have DNS A records mapped inside the `naresh-training.online` zone. Within the AKS cluster, microservices resolve each other internally via Kubernetes DNS.
- **Permissions**: AKS uses Managed Identities to pull container images from the Azure Container Registry (`nareshroboshop.azurecr.io`) via `AcrPull` role assignments and modify network resources via a `Network Contributor` assignment.

---

## 📂 Repository Structure

```plaintext
├── environment/                # Environment-specific configuration and backend state files
│   ├── dev/
│   │   ├── dev.tfvars          # Variables for the Development environment (e.g., env = "dev")
│   │   └── state.tfvars        # Remote backend state configuration (Storage Account, container, key)
│   ├── qa/
│   │   └── qa.tfvars           # Variables for the QA environment
│   └── prod/
│       └── prod.tfvars         # Variables for the Production environment
├── modules/                    # Reusable modular infrastructure components
│   ├── aks/                    # Provisions Azure Kubernetes Service (AKS) with System-Assigned identity
│   ├── dns/                    # Manages Private/Public DNS A records in the dns zone
│   ├── networking/             # Creates Network Interfaces (NIC), Security Groups (NSG) and Public IPs
│   ├── vm/                     # Deploys Linux VMs using custom shared gallery images (roboshopGallery/roboshopImage)
│   ├── lb/                     # [Legacy] Infrastructure for Load Balancer setups (commented out, kept for reference)
│   └── vmss/                   # [Legacy] Infrastructure for Virtual Machine Scale Sets (commented out, kept for reference)
├── main.tf                     # Main orchestration file mapping modules, NAT gateways, role assignments & VM provisioners
├── locals.tf                   # Shared local definitions (project name, resource tags)
├── variables.tf                # Variable declarations and default VM sizing details
├── provider.tf                 # Terraform provider block and Azure storage backend settings
├── data.tf                     # Data resources (fetches subnet, resource group, and container registry details)
├── output.tf                   # Outputs resource group name and region location
├── requirements.yml            # Ansible Galaxy requirements (MySQL collection)
└── Makefile                    # Automates deployment tasks (Terraform init, apply, destroy)
```

---

## ⚙️ Configuration & Variables

### Input Variables (`variables.tf`)

Key configuration parameters that can be overridden:

| Name | Type | Default Value | Description |
|------|------|---------------|-------------|
| `resource_group_name` | `string` | `"denmark-east"` | The target Azure Resource Group. |
| `env` | `string` | *Required (no default)* | Environment identifier (e.g., `dev`, `qa`, `prod`). |
| `mysql` | `map` | `{ mysql = "Standard_B1s" }` | Instance size for MySQL DB server. |
| `db` | `map` | MongoDB, Valkey, RabbitMQ mapping to `"Standard_B1s"` | VM sizes for non-relational database components. |
| `img_id` | `string` | Custom shared image gallery resource ID | Shared image reference used to provision Linux VM instances. |
| `public_ip_enabled` | `bool` | `false` | Enable public IP mapping for network interface cards. |

### Local Variables (`locals.tf`)

Defines unified resource tags:
```hcl
locals {
  project = "roboshop"
  common_tags = {
    name = local.project
    env  = var.env
  }
}
```

---

## 🛠 Database Provisioning & Bootstrap

The virtual machines are configured post-creation using a hybrid approach combining Terraform `remote-exec` provisioners and Ansible:

1. **Requirements Setup**: The root `requirements.yml` lists the `community.mysql` galaxy collection.
2. **File Copy**: Terraform uses an SSH connection (username: `devops`, password-based auth) to copy `requirements.yml` to `/home/devops/requirements.yml` on the MySQL VM.
3. **Ansible Pull**: 
   - **MySQL VM**: Connects via SSH, installs `ansible-core`, `git`, `python3-pip`, and `PyMySQL`, installs the galaxy collection, and executes `ansible-pull` against the [roboshop-azure-ansible](https://github.com/nareshgantala/roboshop-azure-ansible.git) repository.
   - **Other Database VMs** (MongoDB, Valkey, RabbitMQ): Connects via SSH, installs `ansible-core` and `git`, and executes `ansible-pull` directly to configure the services.

---

## 🚀 Execution & Deployment Workflow

A `Makefile` is provided to simplify initialization and environment orchestration.

### Prerequisites

Ensure you have the following installed locally:
- **Terraform** (v1.5.0+)
- **Azure CLI** (Authenticated via `az login`)
- Access to the target subscription and Resource Group (`denmark-east`)

### Run Deployment (Development Environment)

To initialize Terraform with remote backend state storage and apply changes automatically:

```bash
make dev-apply
```

This target runs:
```bash
terraform init -backend-config=environment/dev/state.tfvars
terraform apply -auto-approve -var-file=environment/dev/dev.tfvars
```

### Tear Down Deployment

To destroy the provisioned infrastructure:

```bash
make dev-destroy
```

This target runs:
```bash
terraform init -backend-config=environment/dev/state.tfvars
terraform destroy -auto-approve -var-file=environment/dev/dev.tfvars
```

---

## 🔐 Security Best Practices

- **Dynamic Access Control**: A Network Security Group (NSG) named `allow-all` is resolved from data sources and mapped to all VM network interfaces. Ensure this NSG is configured with appropriate IP rules in production.
- **Egress Network Protection**: All private VMs are locked inside a secure subnet with outbound traffic route-mapped through the NAT Gateway.
- **Secrets Management**: Secrets (such as the default VM password `Devops@12345`) are shown in plaintext inside this codebase for educational and demo configurations. For staging or production, replace password auth with SSH key pairs or store secrets in **Azure Key Vault**.
