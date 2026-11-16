package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestVpcModule(t *testing.T) {
	t.Parallel()

	awsRegion := "ap-south-1"
	expectedName := fmt.Sprintf("test-vpc-%s", strings.ToLower(random.UniqueId()))

	// Pick 2 availability zones in the chosen region
	azs := aws.GetAvailabilityZones(t, awsRegion)
	require.GreaterOrEqual(t, len(azs), 2, "Region must have at least 2 availability zones")
	selectedAzs := azs[0:2]

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/vpc",
		Vars: map[string]interface{}{
			"name_prefix":          expectedName,
			"environment":          "testing",
			"vpc_cidr":             "10.99.0.0/16",
			"availability_zones":   selectedAzs,
			"public_subnet_cidrs":  []string{"10.99.1.0/24", "10.99.2.0/24"},
			"private_subnet_cidrs": []string{"10.99.10.0/24", "10.99.20.0/24"},
			"enable_nat_gateway":   true,
			"single_nat_gateway":   true,
			"tags": map[string]string{
				"AutomatedTest": "true",
				"TestSuite":     "Terratest",
			},
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	})

	// Clean up resources on test completion
	defer terraform.Destroy(t, terraformOptions)

	// Deploy the VPC module
	terraform.InitAndApply(t, terraformOptions)

	// Validate Outputs
	vpcId := terraform.Output(t, terraformOptions, "vpc_id")
	assert.NotEmpty(t, vpcId, "VPC ID should not be empty")
	assert.True(t, strings.HasPrefix(vpcId, "vpc-"), "VPC ID should start with 'vpc-'")

	publicSubnetIds := terraform.OutputList(t, terraformOptions, "public_subnet_ids")
	assert.Equal(t, 2, len(publicSubnetIds), "Should create exactly 2 public subnets")

	privateSubnetIds := terraform.OutputList(t, terraformOptions, "private_subnet_ids")
	assert.Equal(t, 2, len(privateSubnetIds), "Should create exactly 2 private subnets")

	internetGatewayId := terraform.Output(t, terraformOptions, "internet_gateway_id")
	assert.NotEmpty(t, internetGatewayId, "Internet Gateway ID should not be empty")

	natGatewayIds := terraform.OutputList(t, terraformOptions, "nat_gateway_ids")
	assert.Equal(t, 1, len(natGatewayIds), "Single NAT Gateway configuration should create 1 NAT Gateway")
}
