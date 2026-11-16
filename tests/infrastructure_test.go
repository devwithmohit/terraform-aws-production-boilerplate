package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestSecureS3BucketModule(t *testing.T) {
	t.Parallel()

	awsRegion := "ap-south-1"
	uniqueId := strings.ToLower(random.UniqueId())
	bucketPrefix := fmt.Sprintf("test-sec-s3-%s", uniqueId)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/s3-bucket",
		Vars: map[string]interface{}{
			"bucket_prefix":        bucketPrefix,
			"environment":          "testing",
			"append_random_suffix": true,
			"force_destroy":        true,
			"block_public_access":  true,
			"enable_versioning":    true,
			"enforce_tls":          true,
			"tags": map[string]string{
				"AutomatedTest": "true",
				"Module":        "s3-bucket",
			},
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	bucketId := terraform.Output(t, terraformOptions, "bucket_id")
	assert.NotEmpty(t, bucketId, "Bucket ID should not be empty")

	// Verify bucket versioning is enabled
	actualStatus := aws.GetS3BucketVersioning(t, awsRegion, bucketId)
	assert.Equal(t, "Enabled", actualStatus, "Bucket versioning should be Enabled")

	// Verify Public Access Block is completely enabled
	aws.AssertS3BucketPublicAccessBlock(t, awsRegion, bucketId, aws.S3PublicAccessBlock{
		BlockPublicAcls:       true,
		BlockPublicPolicy:     true,
		IgnorePublicAcls:      true,
		RestrictPublicBuckets: true,
	})
}
