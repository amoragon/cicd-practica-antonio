all: all-dev all-prod
clean: clean-dev clean-prod

#############################
## DEV ENVIRONMENT TARGETS ##
#############################

all-dev: clean-dev dev

# ----------------------------
# 1.- Creation bucket process
# ----------------------------

# Creates DEV workspace and bucket 
dev: create-ws-dev bucket-dev

# Creates DEV workspace
create-ws-dev:
	cd infra && \
	[ $$(terraform workspace list | grep dev | wc -w) -lt 1 ] && \
	terraform workspace new dev

# Creates DEV S3 bucket
bucket-dev:
	cd infra && \
	terraform workspace select dev && \
	terraform apply -var="environment=dev" -auto-approve
	
# ----------------------------
# 2.- Creation bucket process
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

####################################
## PRODUCTION ENVIRONMENT TARGETS ##
####################################

all-prod: clean-prod prod

# ----------------------------
# 1.- Creation bucket process
# ----------------------------

# Creates PROD workspace and bucket 
prod: create-ws-prod bucket-prod

# Creates PROD workspace
create-ws-prod:
	cd infra && \
	[ $$(terraform workspace list | grep prod | wc -w) -lt 1 ] && \
	terraform workspace new prod

# Creates PROD S3 bucket
bucket-prod:
	cd infra && \
	terraform workspace select prod && \
	terraform apply -var="environment=prod" -auto-approve

# ----------------------------
# 2.- Creation bucket process
# ----------------------------

# Clean PROD environment
clean-prod: remove-objects-prod remove-ws-prod

# Removes objects in PROD S3 bucket
remove-objects-dev:
	@echo "Borrando objetos del bucket kc-acme-storage-prd..." && \
	[[ $$(aws s3 ls s3://kc-acme-storage-prod 2>&1 | grep "NoSuchBucket" | wc -l) -eq 0 ]] && \
    aws s3 rm s3://kc-acme-storage-prod --recursive  || \
    echo "No existe el bucket" 

# Removes PROD bucket and workspace, if workspace exists
remove-ws-prod:
	@cd infra && \
	[[ $$(terraform workspace list | grep prod | wc -w) -gt 0 ]] && \
	terraform workspace select prod && \
	terraform destroy -var="environment=prod" -auto-approve && \
	terraform workspace select default && \
	terraform workspace delete prod || \
	echo "No existe el workspace prod. No se puede eliminar."

