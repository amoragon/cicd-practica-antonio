all: clean-dev dev
clean: clean-dev

# ----------------------------
# 1.- Creation bucket process
# ----------------------------

# Creates DEV workspace and bucket 
dev: create-ws-dev bucket-dev

# Creates DEV workspace
create-ws-dev:
	cd infra && \
	terraform init && \
	[[ $$(terraform workspace list | grep dev | wc -l) -eq 0 ]] && \
	terraform workspace new dev

# Creates DEV S3 bucket
bucket-dev:
	cd infra && \
	terraform workspace select dev && \
	terraform apply -var="environment=dev" -auto-approve || \
	echo "Ya existe el bucket"
	
# ----------------------------
# 2.- Cleaning bucket process
# ----------------------------

# Clean DEV environment
clean-dev: remove-objects-dev remove-ws-dev

# Removes objects in DEV S3 bucket, if it exists
remove-objects-dev:
	@echo "Borrando objetos del bucket kc-acme-storage-dev..." && \
	[[ $$(aws s3 ls s3://kc-acme-storage-dev 2>&1 | grep "NoSuchBucket" | wc -l) -eq 0 ]] && \
    aws s3 rm s3://kc-acme-storage-dev --recursive  || \
    echo "No existe el bucket" 
	
# Removes DEV bucket and workspace, if workspace exists
remove-ws-dev:
	@cd infra && \
	[[ $$(terraform workspace list | grep dev | wc -w) -gt 0 ]] && \
	terraform workspace select dev && \
	terraform destroy -var="environment=dev" -auto-approve && \
	terraform workspace select default && \
	terraform workspace delete dev || \
	echo "No existe el workspace dev. No se puede eliminar."
