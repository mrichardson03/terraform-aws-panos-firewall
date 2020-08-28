  
package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraform(t *testing.T) {
	t.Parallel()

	// Pick a random, stable (older than one year) AWS region to test in.
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)

	// Create temporary SSH key in that region to test with.
	keyPairName := fmt.Sprintf("terratest-ssh-%s", random.UniqueId())
	keyPair := aws.CreateAndImportEC2KeyPair(t, awsRegion, keyPairName)

	terraformOptions := &terraform.Options{
		// Use the Terraform plans in this directory
		TerraformDir: ".",

		// Add variables to Terraform run (like they were specified on the Terraform CLI via -var).
		Vars: map[string]interface{}{
			"aws_region": awsRegion,
			"key_name":   keyPairName,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created,
	// and then clean up our key pair.
	defer func() {
		terraform.Destroy(t, terraformOptions)
		aws.DeleteEC2KeyPair(t, keyPair)
	}()

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}