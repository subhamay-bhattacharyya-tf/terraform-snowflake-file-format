# Terraform Snowflake Module - File Format

![Release](https://github.com/subhamay-bhattacharyya-tf/terraform-snowflake-file-format/actions/workflows/ci.yaml/badge.svg)&nbsp;![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?logo=snowflake&logoColor=white)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-tf/terraform-snowflake-file-format)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-tf/terraform-snowflake-file-format)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-tf/terraform-snowflake-file-format)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-tf/terraform-snowflake-file-format)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-tf/terraform-snowflake-file-format)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-tf/terraform-snowflake-file-format)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-tf/terraform-snowflake-file-format)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/643eab0e13f566aff5225c17dc2d6d09/raw/terraform-snowflake-file-format.json?)

A Terraform module for creating and managing Snowflake file formats using a map of configuration objects. Supports creating single or multiple file formats with a single module call.

## Features

- Map-based configuration for creating single or multiple file formats
- Support for all Snowflake file format types (CSV, JSON, AVRO, ORC, PARQUET, XML)
- Built-in input validation with descriptive error messages
- Sensible defaults for optional properties
- Outputs keyed by file format identifier for easy reference

## Usage

### Single File Format

```hcl
module "file_format" {
  source = "path/to/modules/snowflake-file-format"

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

### Multiple File Formats

```hcl
module "file_formats" {
  source = "path/to/modules/snowflake-file-format"

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

## Examples

- [Single File Format](examples/single-file-format) - Create a single file format
- [Multiple File Formats](examples/multiple-file-formats) - Create multiple file formats

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| snowflake | >= 0.87.0 |

## Provider Configuration

The `snowflake_file_format` resource is currently a preview feature in the Snowflake provider. You must enable it in your provider configuration:

```hcl
provider "snowflake" {
  # ... other configuration ...
  preview_features_enabled = ["snowflake_file_format_resource"]
}
```

## Providers

| Name | Version |
|------|---------|
| snowflake | >= 0.87.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| file_format_configs | Map of configuration objects for Snowflake file formats | `map(object)` | `{}` | no |

### file_format_configs Object Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| database | string | - | Database name (required) |
| schema | string | - | Schema name (required) |
| name | string | - | File format name (required) |
| format_type | string | - | Format type: CSV, JSON, AVRO, ORC, PARQUET, XML (required) |
| compression | string | "AUTO" | Compression type |
| record_delimiter | string | "\n" | Record delimiter (CSV) |
| field_delimiter | string | "," | Field delimiter (CSV) |
| skip_header | number | 0 | Number of header lines to skip (CSV) |
| skip_blank_lines | bool | false | Skip blank lines (CSV) |
| escape | string | null | Escape character (CSV) |
| escape_unenclosed_field | string | "\\" | Escape for unenclosed fields (CSV) |
| trim_space | bool | false | Trim whitespace (CSV) |
| field_optionally_enclosed_by | string | null | Optional field enclosure (CSV) |
| null_if | list(string) | [] | Strings to interpret as NULL (CSV) |
| error_on_column_count_mismatch | bool | true | Error on column count mismatch (CSV) |
| date_format | string | "AUTO" | Date format (CSV) |
| time_format | string | "AUTO" | Time format (CSV) |
| timestamp_format | string | "AUTO" | Timestamp format (CSV) |
| encoding | string | "UTF8" | Character encoding (CSV) |
| enable_octal | bool | false | Enable octal parsing (JSON) |
| allow_duplicate | bool | false | Allow duplicate keys (JSON) |
| strip_outer_array | bool | false | Strip outer array (JSON) |
| strip_null_values | bool | false | Strip null values (JSON) |
| ignore_utf8_errors | bool | false | Ignore UTF-8 errors (JSON) |
| binary_as_text | bool | true | Interpret binary as text (Parquet/ORC/Avro) |
| preserve_space | bool | false | Preserve whitespace (XML) |
| strip_outer_element | bool | false | Strip outer element (XML) |
| disable_snowflake_data | bool | false | Disable Snowflake data (XML) |
| disable_auto_convert | bool | false | Disable auto convert (XML) |
| comment | string | null | Description of the file format |

### Valid Format Types

- CSV
- JSON
- AVRO
- ORC
- PARQUET
- XML

### Valid Compression Types

- AUTO
- GZIP
- BZ2
- BROTLI
- ZSTD
- DEFLATE
- RAW_DEFLATE
- NONE

## Outputs

| Name | Description |
|------|-------------|
| file_format_names | Map of file format names keyed by identifier |
| file_format_fully_qualified_names | Map of fully qualified file format names |
| file_format_types | Map of file format types |
| file_formats | All file format resources |

## Validation

The module validates inputs and provides descriptive error messages for:

- Empty file format name
- Empty database name
- Empty schema name
- Invalid format type
- Invalid compression type
- Negative skip_header value

## Testing

The module includes Terratest-based integration tests:

```bash
cd test
go mod tidy
go test -v -timeout 30m
```


Required environment variables for testing:
- `SNOWFLAKE_ORGANIZATION_NAME` - Snowflake organization name
- `SNOWFLAKE_ACCOUNT_NAME` - Snowflake account name
- `SNOWFLAKE_USER` - Snowflake username
- `SNOWFLAKE_ROLE` - Snowflake role (e.g., "SYSADMIN")
- `SNOWFLAKE_PRIVATE_KEY` - Snowflake private key for key-pair authentication

## CI/CD Configuration

The CI workflow runs on:
- Push to `main`, `feature/**`, and `bug/**` branches (when `modules/**` changes)
- Pull requests to `main` (when `modules/**` changes)
- Manual workflow dispatch

The workflow includes:
- Terraform validation and format checking
- Examples validation
- Terratest integration tests (output displayed in GitHub Step Summary)
- Changelog generation (non-main branches)
- Semantic release (main branch only)

The CI workflow uses the following GitHub organization variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `TERRAFORM_VERSION` | Terraform version for CI jobs | `1.3.0` |
| `GO_VERSION` | Go version for Terratest | `1.21` |
| `SNOWFLAKE_ORGANIZATION_NAME` | Snowflake organization name | - |
| `SNOWFLAKE_ACCOUNT_NAME` | Snowflake account name | - |
| `SNOWFLAKE_USER` | Snowflake username | - |
| `SNOWFLAKE_ROLE` | Snowflake role (e.g., SYSADMIN) | - |

The following GitHub secrets are required for Terratest integration tests:

| Secret | Description | Required |
|--------|-------------|----------|
| `SNOWFLAKE_PRIVATE_KEY` | Snowflake private key for key-pair authentication | Yes |

## License

MIT License - See [LICENSE](LICENSE) for details.
