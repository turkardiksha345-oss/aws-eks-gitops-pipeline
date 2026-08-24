# ==============================================================================
# Outputs
# ==============================================================================

output "aws_region" {
  description = "AWS Region deployed to"
  value       = var.aws_region
}

output "eks_cluster_name" {
  description = "EKS Cluster Name"
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  description = "EKS Cluster API Server Endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "configure_kubectl_command" {
  description = "Command to configure kubectl context"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
}

output "ecr_repository_url" {
  description = "Amazon ECR Repository URL"
  value       = aws_ecr_repository.app.repository_url
}

output "acm_certificate_arn" {
  description = "ACM SSL Certificate ARN (Use in chart/values.yaml and argocd/argocd-ingress.yaml)"
  value       = aws_acm_certificate_validation.cert.certificate_arn
}

output "acm_dns_validation_records" {
  description = "DNS CNAME records to add in your DNS provider for SSL validation"
  value = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
}

output "github_actions_role_arn" {
  description = "IAM Role ARN for GitHub Actions CI/CD Pipeline (Use in .github/workflows/ci.yml)"
  value       = aws_iam_role.github_actions.arn
}

output "alb_controller_role_arn" {
  description = "IAM Role ARN for AWS Load Balancer Controller service account"
  value       = aws_iam_role.aws_lb_controller.arn
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "route53_zone_id" {
  description = "Route 53 Public Hosted Zone ID"
  value       = aws_route53_zone.primary.zone_id
}

output "route53_name_servers" {
  description = "Route 53 Name Servers (Update these in your domain registrar like GoDaddy, Namecheap, etc.)"
  value       = aws_route53_zone.primary.name_servers
}
