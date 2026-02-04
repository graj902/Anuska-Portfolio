output "alb_dns_name" {
  value = aws_lb.main_alb.dns_name
  description = "Use this DNS name in Route 53 to point your domain (Task 6)"
}
output "s3_bucket_name" { value = aws_s3_bucket.portfolio_bucket.id }
