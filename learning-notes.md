# Learning Notes — Platform Infrastructure as Code

## What I Built

Full AWS infrastructure provisioned with Terraform using a modular design:
VPC (networking) + EKS (Kubernetes cluster) + RDS (managed PostgreSQL).

---

## Key Things I Learned

### 1. Modules Are the Most Important Terraform Concept
Before this project, I thought Terraform was just writing resource blocks.
The real power is modules — reusable, composable infrastructure components.
My VPC module can be used by any project that needs networking.
My EKS module just needs a vpc_id and subnet_ids — it doesn't care how they were created.
This is how real platform teams share infrastructure code across dozens of services.

### 2. Output Chaining Makes Modules Powerful
The VPC module outputs vpc_id and private_subnet_ids.
The EKS module takes those as inputs.
The RDS module takes those as inputs too.
This means changing the VPC CIDR in one place automatically flows
through to every resource that depends on it. No copy-pasting values.

### 3. Sensitive Variables Need Special Handling
db_password is marked sensitive = true in variables.tf.
This means Terraform never prints it in plan or apply output.
In a real team, you'd inject it from AWS Secrets Manager or a CI/CD vault,
never hardcode it in terraform.tfvars committed to Git.

### 4. multi_az and deletion_protection for Production
I used conditional logic for production safety:
- multi_az = true only in production (costs more but survives AZ failure)
- deletion_protection = true in production (prevents accidental destroy)
- skip_final_snapshot = false in production (keeps a backup before delete)
  This is real production thinking, not just writing resources that work.

### 5. The S3 Backend Is Critical for Teams
The remote state backend (S3 + DynamoDB lock) means:
- State is shared — everyone on the team sees the same infrastructure state
- DynamoDB prevents two people running terraform apply simultaneously
- State is encrypted at rest in S3
  Without this, two engineers running terraform apply at the same time
  would corrupt the state file and break everything.

### 6. deploy.sh and destroy.sh Are About Safety
The destroy script has a production safety check — you have to type
"destroy-production" to confirm. This prevents accidents.
The deploy script runs validate before plan before apply.
Real platform teams wrap terraform commands in scripts like these
so junior engineers can't accidentally skip steps.

---

## Connecting This to My Real Work

At Advance Auto Parts, our infrastructure is managed by a platform team.
I always wondered how they provision new environments so consistently.
Building this taught me — it's Terraform modules with remote state.
Every new environment is terraform apply -var="environment=staging".

---

## What I'd Add Next

- Terragrunt for DRY multi-environment management
- AWS Secrets Manager integration for db_password
- VPC Flow Logs for network traffic monitoring
- EKS add-ons: CoreDNS, kube-proxy, VPC CNI via Terraform
- GitHub Actions pipeline to run terraform plan on every PR