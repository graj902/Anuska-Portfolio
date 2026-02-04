output "website_url" {
  value = "http://${aws_instance.web_server.public_ip}"
  description = "Public URL of the Portfolio website"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.portfolio_bucket.id
}
