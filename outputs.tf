output "tf_example_public_ip" {
  value = aws_instance.tf-ec2.public_ip
}

output "tf_example_s3_meta" {
  value = aws_s3_bucket.tf-s3.region
}