# Multiple File Formats Example

This example demonstrates how to create multiple Snowflake file formats using the `snowflake-file-format` module.

## Usage

```hcl
module "file_formats" {
  source = "../../modules/snowflake-file-format"

  file_format_configs = {
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
    "json_standard" = {
      database          = "MY_DATABASE"
      schema            = "MY_SCHEMA"
      name              = "JSON_STANDARD_FORMAT"
      format_type       = "JSON"
      strip_outer_array = true
      strip_null_values = true
      comment           = "Standard JSON format for API data ingestion"
    }
    "parquet_standard" = {
      database       = "MY_DATABASE"
      schema         = "MY_SCHEMA"
      name           = "PARQUET_STANDARD_FORMAT"
      format_type    = "PARQUET"
      binary_as_text = false
      comment        = "Parquet format for analytics workloads"
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| snowflake | >= 0.87.0 |

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| file_format_configs | Map of file format configurations | map(object) | yes |

## Outputs

| Name | Description |
|------|-------------|
| file_format_names | The names of the created file formats |
| file_format_fully_qualified_names | The fully qualified names of the file formats |
| file_format_types | The format types of the file formats |
| file_formats | All file format resources |
