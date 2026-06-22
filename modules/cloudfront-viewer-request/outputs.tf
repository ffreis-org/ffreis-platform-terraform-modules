output "arn" {
  description = "ARN of the published CloudFront function."
  value       = aws_cloudfront_function.viewer_request.arn
}

output "name" {
  description = "Name of the CloudFront function."
  value       = aws_cloudfront_function.viewer_request.name
}
