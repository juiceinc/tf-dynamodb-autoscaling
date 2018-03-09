locals {
  is_table = "${var.index_name == ""}"

  table_id = "table/${var.table_name}"
  index_id = "table/${var.table_name}/index/${var.index_name}"

  resource_id = "${local.is_table ? local.table_id : local.index_id}"

  namespace = "dynamodb"
  type      = "${local.is_table ? "table" : "index"}"

  metric_name = {
    read  = "DynamoDBReadCapacityUtilization"
    write = "DynamoDBWriteCapacityUtilization"
  }

  service_role = "AWSServiceRoleForApplicationAutoScaling_DynamoDBTable"
}

data "aws_iam_role" "dynamodb_autoscale_role" {
  name = "${local.service_role}"
}

# Read

resource "aws_appautoscaling_target" "dynamodb_read" {
  resource_id = "${local.resource_id}"

  min_capacity = "${var.read_min}"
  max_capacity = "${var.read_max}"

  service_namespace  = "${local.namespace}"
  scalable_dimension = "${local.namespace}:${local.type}:ReadCapacityUnits"

  role_arn = "${data.aws_iam_role.dynamodb_autoscale_role.arn}"
}

resource "aws_appautoscaling_policy" "dynamodb_read" {
  // as Application AutoScaling convension
  name = "${local.metric_name["read"]}:${aws_appautoscaling_target.dynamodb_read.resource_id}"

  resource_id        = "${aws_appautoscaling_target.dynamodb_read.resource_id}"
  service_namespace  = "${aws_appautoscaling_target.dynamodb_read.service_namespace}"
  scalable_dimension = "${aws_appautoscaling_target.dynamodb_read.scalable_dimension}"

  policy_type = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "${local.metric_name["read"]}"
    }

    target_value = "${var.read_percent}"
  }
}

# Write

resource "aws_appautoscaling_target" "dynamodb_write" {
  resource_id = "${local.resource_id}"

  min_capacity = "${var.write_min}"
  max_capacity = "${var.write_max}"

  service_namespace  = "${local.namespace}"
  scalable_dimension = "${local.namespace}:${local.type}:WriteCapacityUnits"

  role_arn = "${data.aws_iam_role.dynamodb_autoscale_role.arn}"
}

resource "aws_appautoscaling_policy" "dynamodb_write" {
  // as Application AutoScaling convension
  name = "${local.metric_name["write"]}:${aws_appautoscaling_target.dynamodb_write.resource_id}"

  resource_id        = "${aws_appautoscaling_target.dynamodb_write.resource_id}"
  service_namespace  = "${aws_appautoscaling_target.dynamodb_write.service_namespace}"
  scalable_dimension = "${aws_appautoscaling_target.dynamodb_write.scalable_dimension}"

  policy_type = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "${local.metric_name["write"]}"
    }

    target_value = "${var.write_percent}"
  }
}
