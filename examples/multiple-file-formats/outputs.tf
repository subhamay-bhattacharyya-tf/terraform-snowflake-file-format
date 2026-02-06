output "file_format_names" {
  description = "The names of the created file formats"
  value       = module.file_formats.file_format_names
}

output "file_format_fully_qualified_names" {
  description = "The fully qualified names of the file formats"
  value       = module.file_formats.file_format_fully_qualified_names
}

output "file_format_types" {
  description = "The format types of the file formats"
  value       = module.file_formats.file_format_types
}

output "file_formats" {
  description = "All file format resources"
  value       = module.file_formats.file_formats
}
