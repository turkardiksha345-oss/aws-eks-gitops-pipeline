# AWS Certificate Manager (ACM) Public SSL Certificate
resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  tags = {
    Name = "${var.domain_name}-ssl-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}
