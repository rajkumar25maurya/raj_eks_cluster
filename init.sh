#!/bin/bash

# Define environment variables
if [ -z "$1" ]; then
  echo "Usage: ./init.sh <environment>"
  exit 1
fi

ENVIRONMENT=$1
BUCKET_NAME="raj-eks-tfstate-${ENVIRONMENT}"
REGION="us-east-1"
apply_or_destroy=$2
TF_VARS=$3

# Validate environment name (should not be empty or whitespace)
if [ -z "$ENVIRONMENT" ] || [ "$ENVIRONMENT" = " " ]; then
  echo "Error: The environment name cannot be empty or all whitespace."
  exit 1
fi

if ! echo "$BUCKET_NAME" | grep -Eq '^[a-z0-9.-]{3,63}$'; then
  echo "Error: The bucket name '$BUCKET_NAME' is not valid."
  exit 1
fi

aws s3api head-bucket --bucket $BUCKET_NAME
if [ $? -eq 0 ]; then
    echo "$$BUCKET_NAME Exist.."
else
    aws s3api create-bucket --bucket $BUCKET_NAME --region ${REGION} &> /dev/null
fi

# Replace placeholder with actual bucket name in backend configuration
sed "s/PLACEHOLDER_BUCKET_NAME/${BUCKET_NAME}/" backend.hcl > backend-config.hcl

# Run terraform init with backend configuration
terraform init \
  -backend-config=backend-config.hcl

terraform $apply_or_destroy -auto-approve --var-file $TF_VARS

#Cleanup
rm -rf backend-config.hcl