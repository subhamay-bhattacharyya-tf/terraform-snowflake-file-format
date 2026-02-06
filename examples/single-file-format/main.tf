# Example: Single Snowflake File Format
#
# This example demonstrates how to use the snowflake-file-format module
# to create a single Snowflake file format.

module "file_format" {
  source = "../../modules/snowflake-file-format"

  file_format_configs = var.file_format_configs
}
