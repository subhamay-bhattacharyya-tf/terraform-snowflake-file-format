# Example: Multiple Snowflake File Formats
#
# This example demonstrates how to use the snowflake-file-format module
# to create multiple Snowflake file formats using a map of configurations.

module "file_formats" {
  source = "../../modules/snowflake-file-format"

  file_format_configs = var.file_format_configs
}
