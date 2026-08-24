# Terraform AWS Infrastructure for EKS GitOps Pipeline

This directory contains the Terraform configuration to automatically provision all required AWS infrastructure for the **Python Application to AWS EKS GitOps Pipeline**.

---

## 📦 Resources Provisioned & Backend State

- **Terraform Remote Backend**: State stored securely with encryption in S3 bucket `diksha-gitops-backed-bucket` (region: `us-east-1`, key: `eks-gitops/terraform.tfstate`).
1. **Custom VPC (`10.0.0.0/16`)**:
   - 2 Public Subnets with `kubernetes.io/role/elb = 1` for Internet-facing ALBs.
   - 2 Private Subnets with `kubernetes.io/role/internal-elb = 1` for Worker Nodes.
   - Internet Gateway, NAT Gateway, Elastic IP, and Route Tables.
2. **Amazon EKS Cluster (`eks-cluster`)**:
   - Kubernetes 1.29 control plane and IAM roles.
   - Managed Node Group (`standard-workers`) with `t3.medium` instances (min: 2, desired: 2, max: 4).
   - EKS IAM OpenID Connect (OIDC) Provider for IRSA.
3. **Amazon ECR Repository (`eks-cluster-app`)**:
   - Image vulnerability scanning enabled on push.
   - Lifecycle policy to retain the last 30 tagged container images.
4. **AWS Certificate Manager (ACM) Public Certificate**:
   - Domain: `cdec-engineer.store` & SAN `*.cdec-engineer.store` (DNS validation).
5. **IAM Roles & Policies**:
   - **GitHub Actions OIDC IAM Role (`github-actions-ecr-role`)**: Allows GitHub Actions to push images to ECR without static AWS access keys.
   - **AWS Load Balancer Controller IAM Role (`AmazonEKSLoadBalancerControllerRole`)**: Gives the in-cluster ALB controller permissions to manage AWS ALBs and Target Groups.

---

## 🚀 Quickstart Guide

### 1. Initialize and Plan
```bash
cd terraform

# Initialize Terraform providers
terraform init

# Review execution plan
terraform plan
```

### 2. Apply Infrastructure
```bash
terraform apply -auto-approve
```

### 3. Retrieve Outputs
Once applied, Terraform will output:
```bash
# Connect kubectl to your new EKS cluster
aws eks update-kubeconfig --region eu-north-1 --name eks-cluster

# View DNS validation records for your ACM SSL Certificate
terraform output acm_dns_validation_records

# View ECR Repo URL & IAM Role ARNs
terraform output ecr_repository_url
terraform output acm_certificate_arn
terraform output github_actions_role_arn
terraform output alb_controller_role_arn
```

---

## 🤖 CI/CD Pipeline Automation (GitHub Actions)

This repository includes a dedicated GitHub Actions workflow (`.github/workflows/terraform.yml`) that can be triggered manually from the **Actions** tab on GitHub:

### How to Run Terraform via GitHub Actions:
1. Go to the **Actions** tab in the GitHub repository.
2. Select **Terraform Infrastructure Pipeline** from the left sidebar.
3. Click **Run workflow**:
   - **Terraform Action**: Choose `apply`, `plan`, or `destroy`.
   - **Auto-approve**: Checked by default (`true`).
   - **Required if action is "destroy"**: Type `DESTROY` to confirm when selecting the `destroy` action.
4. Click the green **Run workflow** button.

---

## 🧹 Teardown
To destroy all created AWS resources locally:
```bash
terraform destroy -auto-approve
```
Or use the GitHub Actions workflow and select `destroy` with confirmation `DESTROY`.
