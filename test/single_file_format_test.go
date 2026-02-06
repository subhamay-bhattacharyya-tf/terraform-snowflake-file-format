// File: test/single_file_format_test.go
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

// TestSingleFileFormat tests creating a single file format via the module
func TestSingleFileFormat(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToUpper(random.UniqueId())
	fileFormatName := fmt.Sprintf("TT_FF_%s", unique)
	databaseName := "TERRATEST_DB"
	schemaName := "PUBLIC"

	tfDir := "../examples/basic-file-format"

	fileFormatConfigs := map[string]interface{}{
		"test_ff": map[string]interface{}{
			"database":        databaseName,
			"schema":          schemaName,
			"name":            fileFormatName,
			"format_type":     "CSV",
			"field_delimiter": ",",
			"skip_header":     1,
			"trim_space":      true,
			"comment":         "Terratest single file format test",
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

	exists := fileFormatExists(t, db, databaseName, schemaName, fileFormatName)
	require.True(t, exists, "Expected file format %q to exist in Snowflake", fileFormatName)

	props := fetchFileFormatProps(t, db, databaseName, schemaName, fileFormatName)
	require.Equal(t, fileFormatName, props.Name)
	require.Equal(t, "CSV", props.FormatType)
	require.Contains(t, props.Comment, "Terratest single file format test")
}
