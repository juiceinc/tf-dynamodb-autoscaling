# Module outputs / return values

output "autoscaling_name_map" {
  value = {
    read  = "${aws_appautoscaling_policy.dynamodb_read.name}"
    write = "${aws_appautoscaling_policy.dynamodb_write.name}"
  }
}
