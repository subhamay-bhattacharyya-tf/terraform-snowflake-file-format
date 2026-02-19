# -----------------------------------------------------------------------------
# Terraform Snowflake File Format Module - Variables
# -----------------------------------------------------------------------------
# Input variables for the Snowflake file format module.
# -----------------------------------------------------------------------------

variable "file_format_configs" {
  description = "Map of configuration objects for Snowflake file formats"
  type = map(object({
    database    = string
    schema      = string
    name        = string
    format_type = string

    # CSV-specific options
    compression                    = optional(string, "AUTO")
    record_delimiter               = optional(string, "\n")
    field_delimiter                = optional(string, ",")
    skip_header                    = optional(number, 0)
    skip_blank_lines               = optional(bool, false)
    escape                         = optional(string, null)
    escape_unenclosed_field        = optional(string, "\\")
    trim_space                     = optional(bool, false)
    field_optionally_enclosed_by   = optional(string, null)
    null_if                        = optional(list(string), [])
    error_on_column_count_mismatch = optional(bool, true)
    date_format                    = optional(string, "AUTO")
    time_format                    = optional(string, "AUTO")
    timestamp_format               = optional(string, "AUTO")
    encoding                       = optional(string, "UTF8")

    # JSON-specific options
    enable_octal       = optional(bool, false)
    allow_duplicate    = optional(bool, false)
    strip_outer_array  = optional(bool, false)
    strip_null_values  = optional(bool, false)
    ignore_utf8_errors = optional(bool, false)

    # Parquet/ORC/Avro options
    binary_as_text = optional(bool, true)

    # XML-specific options
    preserve_space         = optional(bool, false)
    strip_outer_element    = optional(bool, false)
    disable_snowflake_data = optional(bool, false)
    disable_auto_convert   = optional(bool, false)

    comment = optional(string, null)

    # Grants
    usage_roles = optional(list(string), [])
  }))
  default = {}

  validation {
    condition     = alltrue([for k, ff in var.file_format_configs : length(ff.name) > 0])
    error_message = "File format name must not be empty."
  }

  validation {
    condition     = alltrue([for k, ff in var.file_format_configs : length(ff.database) > 0])
    error_message = "Database name must not be empty."
  }

  validation {
    condition     = alltrue([for k, ff in var.file_format_configs : length(ff.schema) > 0])
    error_message = "Schema name must not be empty."
  }

  validation {
    condition = alltrue([for k, ff in var.file_format_configs : contains([
      "CSV", "JSON", "AVRO", "ORC", "PARQUET", "XML"
    ], upper(ff.format_type))])
    error_message = "Invalid format_type. Valid values: CSV, JSON, AVRO, ORC, PARQUET, XML."
  }

  validation {
    condition = alltrue([for k, ff in var.file_format_configs : contains([
      "AUTO", "GZIP", "BZ2", "BROTLI", "ZSTD", "DEFLATE", "RAW_DEFLATE", "NONE"
    ], upper(ff.compression))])
    error_message = "Invalid compression. Valid values: AUTO, GZIP, BZ2, BROTLI, ZSTD, DEFLATE, RAW_DEFLATE, NONE."
  }

  validation {
    condition     = alltrue([for k, ff in var.file_format_configs : ff.skip_header >= 0])
    error_message = "skip_header must be >= 0."
  }
}
