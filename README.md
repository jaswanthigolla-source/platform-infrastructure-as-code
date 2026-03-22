# Platform Infrastructure as Code

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=flat&logo=amazonaws&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat&logo=kubernetes&logoColor=white)
![EKS](https://img.shields.io/badge/Amazon_EKS-FF9900?style=flat&logo=amazonaws&logoColor=white)

Production AWS infrastructure provisioned entirely with Terraform.
Modular design provisions a full platform stack: VPC networking,
EKS Kubernetes cluster, and RDS managed database.

Companion infrastructure for the
[Kubernetes Platform Lab](https://github.com/jaswanthigolla-source/kubernetes-platform-lab)
and [Event-Driven Commerce Platform](https://github.com/jaswanthigolla-source/event-driven-commerce-platform).

---

## Architecture
```
┌─────────────────────────────────────────────────────┐
│                     AWS VPC                         │
│  ┌─────────────────┐    ┌────────────────────────┐  │
│  │  Public Subnets │    │    Private Subnets      │  │
│  │  (NAT Gateway)  │    │  ┌──────────────────┐  │  │
│  │  (Load Balancer)│    │  │  EKS Node Group  │  │  │
│  └─────────────────┘    │  └──────────────────┘  │  │
│                         │  ┌──────────────────┐  │  │
│                         │  │  RDS PostgreSQL  │  │  │
│                         │  └──────────────────┘  │  │
│                         └────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

## Terraform Modules

| Module | What It Provisions |
|---|---|
| **vpc** | VPC, public/private subnets, NAT gateway, internet gateway, route tables |
| **eks** | EKS cluster, managed node groups, IAM roles, security groups |
| **rds** | RDS PostgreSQL, subnet group, parameter group, security group |

## Quick Start
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Or use the automation scripts:
```bash
chmod +x scripts/deploy.sh scripts/destroy.sh
./scripts/deploy.sh     # Full environment provisioning
./scripts/destroy.sh    # Full environment teardown
```

## Key Patterns

- **Modular design** — VPC, compute and database are fully independent modules
- **Variable injection** — everything configurable, zero hardcoding
- **Output chaining** — VPC outputs feed EKS and RDS modules automatically
- **Remote state ready** — S3 backend configured for team use
- **Least privilege IAM** — EKS nodes use minimal scoped permissions

## Related Projects

- [kubernetes-platform-lab](https://github.com/jaswanthigolla-source/kubernetes-platform-lab) — K8s manifests deployed on this infrastructure
- [microservices-observability-stack](https://github.com/jaswanthigolla-source/microservices-observability-stack) — Observability for services running here
- [event-driven-commerce-platform](https://github.com/jaswanthigolla-source/event-driven-commerce-platform) — The microservices this infrastructure runs

## Author

Jaswanthi Golla — Backend & Platform Engineer
[github.com/jaswanthigolla-source](https://github.com/jaswanthigolla-source)