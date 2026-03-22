#!/bin/bash
# deploy.sh — Full environment provisioning
# Usage: ./scripts/deploy.sh [environment]

set -e

ENVIRONMENT=${1:-production}
TERRAFORM_DIR="$(dirname "$0")/../terraform"

echo "=========================================="
echo "  Commerce Platform Infrastructure Deploy"
echo "  Environment: $ENVIRONMENT"
echo "=========================================="

# Step 1 — Validate Terraform is installed
if ! command -v terraform &> /dev/null; then
  echo "ERROR: Terraform is not installed"
  echo "Install from: https://developer.hashicorp.com/terraform/downloads"
  exit 1
fi

echo ""
echo "Step 1/4 — Initializing Terraform..."
cd "$TERRAFORM_DIR"
terraform init

echo ""
echo "Step 2/4 — Validating configuration..."
terraform validate

echo ""
echo "Step 3/4 — Planning infrastructure changes..."
terraform plan \
  -var="environment=$ENVIRONMENT" \
  -out=tfplan

echo ""
echo "Step 4/4 — Applying infrastructure..."
terraform apply tfplan

echo ""
echo "=========================================="
echo "  Deploy Complete!"
echo "=========================================="

echo ""
echo "Outputs:"
terraform output

echo ""
echo "Next steps:"
echo "  1. Configure kubectl: aws eks update-kubeconfig --name commerce-platform-$ENVIRONMENT"
echo "  2. Deploy Kubernetes manifests: kubectl apply -f ../kubernetes-platform-lab/"
echo "  3. Verify: kubectl get pods -n commerce"