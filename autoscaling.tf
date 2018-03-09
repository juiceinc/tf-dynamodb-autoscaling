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
