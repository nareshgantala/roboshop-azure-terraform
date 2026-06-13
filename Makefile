dev-apply:
    git pull
	terraform init -backend-config=environment/dev/state.tfvars
	terraform apply -auto-approve -var-file=environment/dev/dev.tfvars

dev-destroy:
	terraform init -backend-config=environment/dev/state.tfvars
	terraform destroy -auto-approve -var-file=environment/dev/dev.tfvars