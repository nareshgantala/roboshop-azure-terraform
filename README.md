# RoboShop Azure Infrastructure via Terraform

This repository contains the Infrastructure as Code (IaC) written in Terraform (HCL) to provision and manage the RoboShop application infrastructure on Microsoft Azure. It uses a modular approach to set up network components, virtual machines, and Virtual Machine Scale Sets (VMSS) required for the multi-tier application.

---

# 📌 Project Overview

RoboShop is a microservices-based e-commerce application. This project automates the creation of its cloud infrastructure on Azure, ensuring consistent environments across development, testing, and production phases.

---

# 📂 Repository Structure

The project is structured with a root configuration calling reusable modules:

```plaintext
├── environment/          # Environment-specific configuration variables (dev, prod, etc.)
├── modules/              # Reusable infrastructure components
│   ├── vnet/             # Virtual Network and subnet configurations
│   ├── compute/          # Virtual Machines and VMSS setups
│   └── security/         # Network Security Groups (NSG) and firewall rules
├── main.tf               # Primary Terraform execution file orchestrating the modules
├── providers.tf          # AzureRM and backend provider configurations
├── data.tf               # Data sources for fetching existing cloud resources
├── locals.tf             # Local variables for managing tags and naming conventions
├── output.tf             # Outputs exported after a successful deployment
└── requirements.yml      # Ansible roles or dependencies (if configuration management is used)
```

---

# 🛠 Prerequisites

Before deploying this infrastructure, ensure you have the following tools installed and configured:

- Terraform (Version 1.5.0+ recommended)
- Azure CLI (Logged into your Azure Subscription using `az login`)
- SSH Key Pair for Linux virtual machine access

---

# 🚀 Deployment Steps

## 1. Clone the Repository

```bash
git clone https://github.com/nareshgantala/roboshop-azure-terraform.git
cd roboshop-azure-terraform
```

---

## 2. Initialize Terraform

Initialize the working directory to download the required providers and modules.

```bash
terraform init
```

---

## 3. Plan the Deployment

Run a dry run to verify which resources Terraform will create, modify, or destroy.

```bash
terraform plan -var-file="environment/dev.tfvars"
```

---

## 4. Apply Changes

Deploy the infrastructure to Azure.

```bash
terraform apply -var-file="environment/dev.tfvars"
```

Type `yes` when prompted to confirm the deployment.

---

## 5. Destroy Infrastructure (Optional)

Delete all managed Azure resources to avoid unnecessary costs.

```bash
terraform destroy -var-file="environment/dev.tfvars"
```

---

# ⚙️ Configuration & Customization

## `locals.tf`

Modify this file to update:

- Project naming conventions
- Default tags
- Global reusable variables

## `environment/`

Create or modify `.tfvars` files to manage different environments such as:

- Development (`dev.tfvars`)
- Production (`prod.tfvars`)
- Testing (`test.tfvars`)

Example customizations:

- VM sizes
- Scaling configurations
- CIDR ranges
- Resource naming

---

# 🏗 Infrastructure Components

This Terraform project provisions the following Azure resources:

- Virtual Network (VNet)
- Subnets
- Network Security Groups (NSGs)
- Linux Virtual Machines
- Virtual Machine Scale Sets (VMSS)
- Public & Private Networking Components
- Security Rules and Firewall Configurations

---

# 📖 Terraform Workflow

```plaintext
terraform init     -> Initialize providers/modules
terraform plan     -> Preview infrastructure changes
terraform apply    -> Create/update infrastructure
terraform destroy  -> Remove infrastructure
```

---

# 🔐 Security Best Practices

- Never hardcode secrets or credentials in Terraform files.
- Use Azure Key Vault or environment variables for sensitive data.
- Restrict NSG inbound rules wherever possible.
- Store Terraform state securely using remote backends.

---

# 📌 Notes

- This project follows a modular Terraform design for better scalability and reusability.
- Separate environment variable files help maintain isolated configurations across environments.
- Infrastructure can be extended easily by adding new modules under the `modules/` directory.

---

# 🤝 Contributing

Contributions, improvements, and suggestions are welcome.

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Open a Pull Request

---

# 📄 License

This project is licensed under the MIT License.

---
