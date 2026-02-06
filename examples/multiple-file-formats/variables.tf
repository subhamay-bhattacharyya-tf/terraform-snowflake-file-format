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
  }))
  default = {
    "csv_standard" = {
      database        = "MY_DATABASE"
      schema          = "MY_SCHEMA"
      name            = "CSV_STANDARD_FORMAT"
      format_type     = "CSV"
      field_delimiter = ","
      skip_header     = 1
      trim_space      = true
      null_if         = ["NULL", "null", ""]
      comment         = "Standard CSV format with header and null handling"
    }
    "csv_pipe_delimited" = {
      database        = "MY_DATABASE"
      schema          = "MY_SCHEMA"
      name            = "CSV_PIPE_FORMAT"
      format_type     = "CSV"
      field_delimiter = "|"
      skip_header     = 0
      compression     = "GZIP"
      comment         = "Pipe-delimited CSV format for legacy systems"
    }
    "json_standard" = {
      database          = "MY_DATABASE"
      schema            = "MY_SCHEMA"
      name              = "JSON_STANDARD_FORMAT"
      format_type       = "JSON"
      strip_outer_array = true
      strip_null_values = true
      compression       = "AUTO"
      comment           = "Standard JSON format for API data ingestion"
    }
    "parquet_standard" = {
      database       = "MY_DATABASE"
      schema         = "MY_SCHEMA"
      name           = "PARQUET_STANDARD_FORMAT"
      format_type    = "PARQUET"
      binary_as_text = false
      compression    = "AUTO"
      comment        = "Parquet format for analytics workloads"
    }
  }
}


# Snowflake authentication variables
variable "snowflake_organization_name" {
  description = "Snowflake organization name"
  type        = string
  default     = null
}

variable "snowflake_account_name" {
  description = "Snowflake account name"
  type        = string
  default     = null
}

variable "snowflake_user" {
  description = "Snowflake username"
  type        = string
  default     = null
}

variable "snowflake_role" {
  description = "Snowflake role"
  type        = string
  default     = null
}

variable "snowflake_private_key" {
  description = "Snowflake private key for key-pair authentication"
  type        = string
  sensitive   = true
  default     = null
}
