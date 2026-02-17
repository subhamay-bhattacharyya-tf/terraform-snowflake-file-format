# -----------------------------------------------------------------------------
# Terraform Snowflake File Format Module - Outputs
# -----------------------------------------------------------------------------
# Output values for the Snowflake file format module.
# -----------------------------------------------------------------------------

output "file_format_names" {
  description = "The names of the created file formats."
  value       = { for k, v in snowflake_file_format.this : k => v.name }
}

output "file_format_fully_qualified_names" {
  description = "The fully qualified names of the file formats."
  value       = { for k, v in snowflake_file_format.this : k => v.fully_qualified_name }
}

output "file_format_types" {
  description = "The format types of the file formats."
  value       = { for k, v in snowflake_file_format.this : k => v.format_type }
}

output "file_formats" {
  description = "All file format resources."
  value       = snowflake_file_format.this
}
