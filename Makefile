dev-apply:
	terraform init -backend-config=environment/dev/state.tfvars
	terraform apply -auto-approve -var-file=environment/dev/dev.tfvars