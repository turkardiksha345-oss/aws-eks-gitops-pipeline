# Terraform AWS Infrastructure for EKS GitOps Pipeline

This directory contains the Terraform configuration to automatically provision all required AWS infrastructure for the **Python Application to AWS EKS GitOps Pipeline**.

---

## 📦 Resources Provisioned & Backend State

- **Terraform Remote Backend**: State stored securely with encryption in S3 bucket `diksha-gitops-backed-bucket` (region: `us-east-1`, key: `eks-gitops/terraform.tfstate`).
1. **Custom VPC (`10.0.0.0/16`)**:
   - 2 Public Subnets with `kubernetes.io/role/elb = 1` for Internet-facing ALBs.
   - 2 Private Subnets with `kubernetes.io/role/internal-elb = 1` for Worker Nodes.
   - Internet Gateway, NAT Gateway, Elastic IP, and Route Tables.
2. **Amazon EKS Cluster (`eks-cluster`) - Private Cluster**:
   - Private API Server endpoint (`endpoint_public_access = false`, `endpoint_private_access = true`) for zero public attack surface.
   - Kubernetes control plane and IAM roles.
   - Managed Node Group (`standard-workers`) deployed in **Private Subnets** with `t3.small` instances (min: 2, desired: 2, max: 4).
   - EKS IAM OpenID Connect (OIDC) Provider for IRSA.
3. **Amazon ECR Repository (`eks-cluster-app`)**:
   - Image vulnerability scanning enabled on push.
   - Lifecycle policy to retain the last 30 tagged container images.
4. **AWS Route 53 Public Hosted Zone & ACM Certificate**:
   - Hosted Zone for `cdec-engineer.store` automatically managed by Terraform.
   - ACM Public Certificate for `cdec-engineer.store` & `*.cdec-engineer.store`.
   - Automatic DNS validation records created and attached directly in Route 53.
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

### 3. Retrieve Outputs & Update Domain Registrar
Once applied, Terraform will output:
```bash
# Connect kubectl to your new EKS cluster
aws eks update-kubeconfig --region eu-north-1 --name my-kubernetes-cluster

# View Route 53 Name Servers (Add these to your domain registrar e.g. GoDaddy/Namecheap)
terraform output route53_name_servers

# View ECR Repo URL & IAM Role ARNs
terraform output ecr_repository_url
terraform output acm_certificate_arn
terraform output github_actions_role_arn
terraform output alb_controller_role_arn
```

---

## 🤖 Unified End-to-End Pipeline (GitHub Actions)

This repository includes a unified GitHub Actions workflow (`.github/workflows/ci.yml`) that can manage Terraform infrastructure, DevSecOps scanning, and application deployments all from one place:

### How to Run the Pipeline via GitHub Actions:
1. Go to the **Actions** tab in the GitHub repository.
2. Select **End-to-End GitOps & Infrastructure Pipeline** from the left sidebar.
3. Click **Run workflow**:
   - **Pipeline Action**:
     - `apply-and-deploy`: Provisions/Updates Terraform resources $\rightarrow$ Scans code $\rightarrow$ Builds/Pushes to ECR $\rightarrow$ Updates Helm manifests $\rightarrow$ Deploys to EKS.
     - `infra-only`: Runs only `terraform apply` (infrastructure provisioning).
     - `app-only`: Runs code testing, build, push, and deploy (skipping Terraform).
     - `plan`: Runs `terraform plan` to preview infrastructure changes.
     - `destroy`: Tears down all AWS infrastructure and the EKS cluster.
   - **confirm_destroy**: Type `DESTROY` if choosing the `destroy` action.
   - **auto_approve**: Checked by default (`true`).
4. Click the green **Run workflow** button.

---

## 🧹 Teardown
To destroy all created AWS resources locally:
```bash
terraform destroy -auto-approve
```
Or run the GitHub Actions workflow with action `destroy` and confirmation `DESTROY`.
