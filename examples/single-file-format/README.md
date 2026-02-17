# Single File Format Example

This example demonstrates how to create a single Snowflake file format using the `snowflake-file-format` module.

## Usage

```hcl
module "file_format" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-snowflake-file-format"

  file_format_configs = {
    "csv_format" = {
      database        = "MY_DATABASE"
      schema          = "MY_SCHEMA"
      name            = "CSV_FILE_FORMAT"
      format_type     = "CSV"
      field_delimiter = ","
      skip_header     = 1
      comment         = "Standard CSV file format with header row"
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
