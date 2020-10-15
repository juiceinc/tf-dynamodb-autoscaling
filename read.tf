# Read

resource "aws_appautoscaling_target" "dynamodb_read" {
  resource_id = local.resource_id

  min_capacity = floor(var.read_min)
  max_capacity = floor(var.read_max)

  service_namespace  = local.namespace
  scalable_dimension = "${local.namespace}:${local.type}:${local.resource_name["read"]}"

  role_arn = data.aws_iam_role.dynamodb_autoscale_role.arn
  lifecycle {
    ignore_changes = [max_capacity]
  }
}

resource "aws_appautoscaling_policy" "dynamodb_read" {
  // as Application AutoScaling convension
  name = "${local.metric_name["read"]}:${aws_appautoscaling_target.dynamodb_read.resource_id}"

  resource_id        = aws_appautoscaling_target.dynamodb_read.resource_id
  service_namespace  = aws_appautoscaling_target.dynamodb_read.service_namespace
  scalable_dimension = aws_appautoscaling_target.dynamodb_read.scalable_dimension

  policy_type = local.policy_type

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = local.metric_name["read"]
    }

    target_value = var.read_percent
  }
}
