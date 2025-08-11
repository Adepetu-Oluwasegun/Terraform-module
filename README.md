# Terraform AWS ECS 3-Tier Architecture with GitHub Actions CI/CD

## Overview

This project is a **Terraform module** for deploying containerized applications on **AWS ECS (Fargate)** within a **secure, scalable 3-tier architecture**.  
It provisions all the necessary AWS resources — networking, compute, load balancing, and security — and integrates with **GitHub Actions** for a fully automated build, push, and deployment workflow.

The goal is to provide a **production-ready infrastructure as code** solution that is **reproducible**, **configurable**, and **cloud-native**.

---

## Architecture

### Components
- **3-Tier VPC Design**
  - **Public Subnets** – Hosts the Application Load Balancer (ALB).
  - **Private Subnets** – Hosts ECS Fargate tasks/services.
  - **Database Subnets** – Reserved for RDS or other backend databases.
- **ECS Cluster (Fargate)** – Serverless container orchestration.
- **Application Load Balancer** – Routes incoming HTTP/HTTPS requests.
- **Security Groups** – Enforce least-privilege access between tiers.
- **IAM Roles & Policies** – Provide ECS and CI/CD pipeline permissions.
- **GitHub Actions CI/CD**
  - Builds and pushes Docker images to **Amazon ECR**.
  - Deploys infrastructure and updates services via Terraform.

---

## Workflow

1. **Code Commit** – Push application or infrastructure changes to GitHub.
2. **GitHub Actions Pipeline**
   - Push to Amazon ECR
   - Apply Terraform changes to AWS
3. **ECS Deployment** – ECS pulls the updated image and deploys it.
4. **Traffic Routing** – ALB routes requests to ECS services.

---

## Prerequisites

Before using this module, ensure you have:
- **AWS Account** with permissions to create VPC, ECS, ECR, ALB, IAM resources.
- **Terraform** ≥ 1.5 installed locally or in your CI environment.
- **AWS CLI** configured locally (for manual testing).
- **GitHub Actions Secrets** set for:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_REGION`
  - `ECR_REPOSITORY`
  - `TF_VAR_*` variables (for Terraform configs)

---

## Usage

```hcl
module "ecs_app" {
  source = "github.com/<your-username>/<repo-name>"

  project_name         = "my-app"
  aws_region           = "us-east-1"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]


  container_image      = "<account-id>.dkr.ecr.us-east-1.amazonaws.com/my-app:latest"
  container_port       = 80
  desired_count        = 2
}

