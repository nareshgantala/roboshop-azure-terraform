RoboShop Azure Infrastructure via Terraform
This repository contains the Infrastructure as Code (IaC) written in Terraform (HCL) to provision and manage the RoboShop application infrastructure on Microsoft Azure. It uses a modular approach to set up network components, virtual machines, and Virtual Machine Scale Sets (VMSS) required for the multi-tier application.

📌 Project Overview
RoboShop is a microservices-based e-commerce application. This project automates the creation of its cloud infrastructure on Azure, ensuring consistent environments across development, testing, and production phases.

📂 Repository Structure
The project is structured with a root configuration calling reusable modules:

Plaintext
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
🛠 Prerequisites
Before deploying this infrastructure, ensure you have the following tools installed and configured:

Terraform: Version 1.5.0+ recommended.

Azure CLI: Logged into your target Azure Subscription (az login).

SSH Key Pair: An SSH public/private key pair for securing Linux virtual instances.

🚀 Deployment Steps
1. Clone the Repository
Bash
git clone https://github.com/nareshgantala/roboshop-azure-terraform.git
cd roboshop-azure-terraform
2. Initialize Terraform
Initialize the working directory to download the required AzureRM providers and modules:

Bash
terraform init
3. Plan the Deployment
Run a dry run to verify what resources Terraform will create, modify, or destroy. Pass your environment variable file if applicable:

Bash
terraform plan -var-file="environment/dev.tfvars"
4. Apply Changes
Deploy the infrastructure to Azure. Confirm the action by typing yes when prompted:

Bash
terraform apply -var-file="environment/dev.tfvars"
5. Tear Down Infrastructure (Optional)
To delete all managed resources and avoid ongoing Azure costs:

Bash
terraform destroy -var-file="environment/dev.tfvars"
⚙️ Configuration & Customization
locals.tf: Modify this file to update project naming schemas, default resource tags, and global variables.

environment/: Create or edit .tfvars files in this directory to manage separate environments (e.g., changing instance sizes between dev and prod).
