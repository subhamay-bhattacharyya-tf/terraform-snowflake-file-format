# Snowflake File Format Resource
# Creates and manages one or more Snowflake file formats based on the file_format_configs map

resource "snowflake_file_format" "this" {
  for_each = var.file_format_configs

  database = each.value.database
  schema   = each.value.schema
  name     = each.value.name

  # Format type (CSV, JSON, AVRO, ORC, PARQUET, XML)
  format_type = each.value.format_type

  # CSV-specific options
  compression                    = each.value.compression
  record_delimiter               = each.value.record_delimiter
  field_delimiter                = each.value.field_delimiter
  skip_header                    = each.value.skip_header
  skip_blank_lines               = each.value.skip_blank_lines
  escape                         = each.value.escape
  escape_unenclosed_field        = each.value.escape_unenclosed_field
  trim_space                     = each.value.trim_space
  field_optionally_enclosed_by   = each.value.field_optionally_enclosed_by
  null_if                        = each.value.null_if
  error_on_column_count_mismatch = each.value.error_on_column_count_mismatch
  date_format                    = each.value.date_format
  time_format                    = each.value.time_format
  timestamp_format               = each.value.timestamp_format
  encoding                       = each.value.encoding

  # JSON-specific options
  enable_octal       = each.value.enable_octal
  allow_duplicate    = each.value.allow_duplicate
  strip_outer_array  = each.value.strip_outer_array
  strip_null_values  = each.value.strip_null_values
  ignore_utf8_errors = each.value.ignore_utf8_errors

  # Parquet/ORC/Avro options
  binary_as_text = each.value.binary_as_text

  # XML-specific options
  preserve_space         = each.value.preserve_space
  strip_outer_element    = each.value.strip_outer_element
  disable_snowflake_data = each.value.disable_snowflake_data
  disable_auto_convert   = each.value.disable_auto_convert

  comment = each.value.comment
}
