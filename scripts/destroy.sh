#!/bin/bash
# destroy.sh — Full environment teardown
# Usage: ./scripts/destroy.sh [environment]
# WARNING: This destroys ALL infrastructure. Use with caution.

set -e

ENVIRONMENT=${1:-production}
TERRAFORM_DIR="$(dirname "$0")/../terraform"

echo "=========================================="
echo "  Commerce Platform Infrastructure Destroy"
echo "  Environment: $ENVIRONMENT"
echo "=========================================="
echo ""
echo "WARNING: This will destroy ALL infrastructure"
echo "including EKS cluster, RDS database, and VPC."
echo ""

# Safety check for production
if [ "$ENVIRONMENT" == "production" ]; then
  echo "PRODUCTION ENVIRONMENT DETECTED"
  read -p "Type 'destroy-production' to confirm: " CONFIRM
  if [ "$CONFIRM" != "destroy-production" ]; then
    echo "Aborted. No changes made."
    exit 1
  fi
fi

echo ""
echo "Step 1/2 — Planning destroy..."
cd "$TERRAFORM_DIR"
terraform plan -destroy \
  -var="environment=$ENVIRONMENT" \
  -out=destroy-plan

echo ""
echo "Step 2/2 — Destroying infrastructure..."
terraform apply destroy-plan

echo ""
echo "=========================================="
echo "  Destroy Complete. All resources removed."
echo "=========================================="