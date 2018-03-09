# Module Input

variable "table_name" {}

variable "index_name" {
  default = ""
}

## Read

variable "read_min" {
  default = 1
}

variable "read_max" {
  default = 10000
}

variable "read_percent" {
  default = 70
}

## Write

variable "write_min" {
  default = 1
}

variable "write_max" {
  default = 10000
}

variable "write_percent" {
  default = 70
}
