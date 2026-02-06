// File: test/multiple_file_formats_test.go
package test

import (
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestMultipleFileFormats tests creating multiple file formats via the module
func TestMultipleFileFormats(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToUpper(random.UniqueId())

	ff1Name := fmt.Sprintf("TT_CSV_%s", unique)
	ff2Name := fmt.Sprintf("TT_JSON_%s", unique)
	ff3Name := fmt.Sprintf("TT_PARQUET_%s", unique)
	databaseName := "TERRATEST_DB"
	schemaName := "PUBLIC"

	tfDir := "../examples/multiple-file-formats"

	fileFormatConfigs := map[string]interface{}{
		"csv_format": map[string]interface{}{
			"database":        databaseName,
			"schema":          schemaName,
			"name":            ff1Name,
			"format_type":     "CSV",
			"field_delimiter": ",",
			"skip_header":     1,
			"trim_space":      true,
			"comment":         "Terratest CSV file format",
		},
		"json_format": map[string]interface{}{
			"database":          databaseName,
			"schema":            schemaName,
			"name":              ff2Name,
			"format_type":       "JSON",
			"strip_outer_array": true,
			"strip_null_values": true,
			"comment":           "Terratest JSON file format",
		},
		"parquet_format": map[string]interface{}{
			"database":       databaseName,
			"schema":         schemaName,
			"name":           ff3Name,
			"format_type":    "PARQUET",
			"binary_as_text": false,
			"comment":        "Terratest Parquet file format",
		},
	}

	tfOptions := &terraform.Options{
		TerraformDir: tfDir,
		NoColor:      true,
		Vars: map[string]interface{}{
			"file_format_configs":         fileFormatConfigs,
			"snowflake_organization_name": os.Getenv("SNOWFLAKE_ORGANIZATION_NAME"),
			"snowflake_account_name":      os.Getenv("SNOWFLAKE_ACCOUNT_NAME"),
			"snowflake_user":              os.Getenv("SNOWFLAKE_USER"),
			"snowflake_role":              os.Getenv("SNOWFLAKE_ROLE"),
			"snowflake_private_key":       os.Getenv("SNOWFLAKE_PRIVATE_KEY"),
		},
	}

	defer terraform.Destroy(t, tfOptions)

	// Create test database first
	db := openSnowflake(t)
	_, err := db.Exec(fmt.Sprintf("CREATE DATABASE IF NOT EXISTS %s", databaseName))
	require.NoError(t, err)
	_ = db.Close()

	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	db = openSnowflake(t)
	defer func() { _ = db.Close() }()

	// Verify all three file formats exist
	for _, ffName := range []string{ff1Name, ff2Name, ff3Name} {
		exists := fileFormatExists(t, db, databaseName, schemaName, ffName)
		require.True(t, exists, "Expected file format %q to exist in Snowflake", ffName)
	}

	// Verify properties of each file format
	csvProps := fetchFileFormatProps(t, db, databaseName, schemaName, ff1Name)
	require.Equal(t, ff1Name, csvProps.Name)
	require.Equal(t, "CSV", csvProps.FormatType)

	jsonProps := fetchFileFormatProps(t, db, databaseName, schemaName, ff2Name)
	require.Equal(t, ff2Name, jsonProps.Name)
	require.Equal(t, "JSON", jsonProps.FormatType)

	parquetProps := fetchFileFormatProps(t, db, databaseName, schemaName, ff3Name)
	require.Equal(t, ff3Name, parquetProps.Name)
	require.Equal(t, "PARQUET", parquetProps.FormatType)
}
