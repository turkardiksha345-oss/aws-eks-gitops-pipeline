# Architecture Overview

This document outlines the architecture for deploying the Python "Hello World" doodle app to AWS EKS using GitOps principles.

## High-Level Architecture Diagram

```mermaid
graph LR
    subgraph Git Repository (GitHub/GitLab)
        A[App Source Code]
        B[Helm Manifests]
        A -->|Triggers| CI[CI/CD Pipeline]
    end

    subgraph CI/CD Pipeline (GitHub Actions)
        CI -->|1. Checkout & SAST| S[SonarCloud]
        CI -->|2. Build & Scan| T[Trivy Image Scan]
        CI -->|3. Push| ECR[(Amazon ECR)]
        CI -->|4. Update Tag| B
    end

    subgraph AWS EKS Cluster
        CD[ArgoCD]
        ALB[AWS ALB Ingress]
        Pods[App Pods]
        
        CD -->|Polls| B
        CD -->|Syncs| Pods
        ALB -->|Routes Traffic| Pods
    end

    User((User)) -->|HTTPS request| ALB
```

## Component Details

### 1. Source Control (GitHub/GitLab)
The repository contains both the application source code (`app/`) and the deployment configurations (`chart/`).

### 2. CI/CD Pipeline (GitHub Actions)
When a change is pushed to the `main` branch, the CI pipeline triggers. It incorporates DevSecOps best practices:
- **Linting:** Validates Python syntax using Flake8.
- **SAST (Static Application Security Testing):** Uses SonarCloud to analyze source code for vulnerabilities and bugs before building.
- **Image Scanning:** Uses Trivy to scan the built Docker image for known CVEs. If critical vulnerabilities are found, the build can be configured to fail.
- **Artifact Storage:** Pushes the secure Docker image to Amazon ECR.
- **GitOps Commit:** Automatically updates the `values.yaml` in the Helm chart with the new image tag.

### 3. Continuous Deployment (ArgoCD)
ArgoCD runs inside the EKS cluster. It continuously monitors the Git repository (`chart/` directory) for changes. When the CI pipeline updates the image tag in `values.yaml`, ArgoCD detects the configuration drift and automatically synchronizes the cluster state with the Git repository, pulling the new image from ECR and deploying the updated Pods.

### 4. AWS EKS and Application Load Balancer
- The application runs on EKS worker nodes.
- An AWS Application Load Balancer (ALB) is provisioned via the `Ingress` resource.
- The ALB acts as the entry point, terminating SSL/TLS for `cdec-engineer.store` and routing HTTP/HTTPS traffic to the application Pods.
- The Horizontal Pod Autoscaler (HPA) automatically scales the number of Pods based on CPU and memory utilization.

## Security Controls (DevSecOps)
- **Least Privilege:** The Dockerfile uses a non-root user (`appuser`).
- **OIDC Integration:** GitHub Actions authenticates to AWS using OIDC, eliminating the need for long-lived IAM credentials.
- **SAST & SCA:** Integrated SonarCloud and Trivy ensure code and dependencies are secure before deployment.
- **SSL/TLS:** The ALB is configured to use AWS Certificate Manager (ACM) to encrypt traffic in transit.
