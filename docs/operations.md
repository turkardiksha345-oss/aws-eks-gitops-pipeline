# Operational Procedures

This document describes the standard operating procedures for managing the application lifecycle on AWS EKS using GitOps.

## 1. Deployment Procedure

Because this system uses GitOps (ArgoCD) and CI/CD (GitHub Actions), deployments are fully automated.

### How to Deploy a New Version:
1.  **Develop:** Make changes to the application code in the `app/` directory.
2.  **Commit & Push:** Commit your changes and push them to the `main` branch of the Git repository.
    ```bash
    git add .
    git commit -m "feat: updated doodle quote layout"
    git push origin main
    ```
3.  **CI Pipeline:** GitHub Actions will automatically trigger. It will run linting, SAST (SonarCloud), build the Docker image, run a container image vulnerability scan (Trivy), push the image to ECR, and update the `chart/values.yaml` with the new image tag.
4.  **CD Sync (ArgoCD):** ArgoCD will detect the change in `values.yaml` within a few minutes (or you can manually trigger a sync in the ArgoCD UI). It will pull the new image and perform a rolling update on the EKS cluster.

## 2. Rollback Procedure

One of the primary benefits of GitOps is that the Git repository is the single source of truth. If a deployment causes issues, rolling back is as simple as reverting a Git commit.

### How to Rollback:
1.  **Identify the Commit:** Find the commit hash in the Git repository that introduced the bad deployment (specifically, the commit that updated the image tag in `values.yaml`, or a bad code commit).
2.  **Revert the Commit:** Use Git to revert the commit.
    ```bash
    git revert <bad_commit_hash>
    git push origin main
    ```
3.  **ArgoCD Sync:** ArgoCD will detect that the `values.yaml` has reverted to the previous state (pointing to the older, stable image tag) and will automatically apply the changes to the cluster, replacing the failing Pods with the older, stable version.

## 3. Cost Optimization (Environment Suspend/Stop)

To minimize AWS costs during non-working hours or when the environment is not in use, you can suspend the environment.

### Suspending the Environment (Scale to Zero)
Instead of destroying the cluster, you can scale the application workloads to zero, saving compute costs.

1.  **Disable HPA (Optional but recommended):** If you are using HPA, you may need to temporarily disable it or set `minReplicas` to 0.
2.  **Scale Deployment to 0:** Modify the `replicaCount` in `chart/values.yaml` to `0` and commit the change.
    ```yaml
    # chart/values.yaml
    replicaCount: 0
    autoscaling:
      enabled: false
    ```
    ```bash
    git commit -am "chore: suspend environment to save costs"
    git push origin main
    ```
3.  **ArgoCD Sync:** ArgoCD will terminate all running Pods for the application, stopping compute consumption for the app. The ALB will remain but will not route traffic to any backends.

*(For deeper cost savings on EKS itself, you would need to use tools like Karpenter with consolidated node pools that scale down to zero, or implement a script to scale the EKS Auto Scaling Groups to 0, though the EKS control plane cost will remain).*

### Restoring the Environment
1.  Revert the commit made in the suspension step to restore the original `replicaCount` and `autoscaling` configurations.
2.  ArgoCD will detect the change and spin up the Pods, making the application available again.
