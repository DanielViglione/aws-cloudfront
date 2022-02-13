package test

import (
	"math/rand"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestFargateEndpoints(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../examples/basic-usage",
		Vars: map[string]interface{}{
			"name_suffix": randomString(5),
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	publicDistributionIdPrimary := terraform.Output(t, terraformOptions, "public_distribution_id_primary")
	privateDistributionIdPrimary := terraform.Output(t, terraformOptions, "private_distribution_id_primary")
	route53DomainPrimary := terraform.Output(t, terraformOptions, "route53_domain_primary")
	publicDistributionIdSecondary := terraform.Output(t, terraformOptions, "public_distribution_id_secondary")
	privateDistributionIdSecondary := terraform.Output(t, terraformOptions, "private_distribution_id_secondary")
	route53DomainSecondary := terraform.Output(t, terraformOptions, "route53_domain_secondary")

	assert.NotNil(t, publicDistributionIdPrimary)
	assert.NotNil(t, privateDistributionIdPrimary)
	assert.NotNil(t, route53DomainPrimary)
	assert.NotNil(t, publicDistributionIdSecondary)
	assert.NotNil(t, privateDistributionIdSecondary)
	assert.NotNil(t, route53DomainSecondary)
}

func randomString(n int) string {
	rand.Seed(time.Now().Unix())

	charSet := "abcdedfghijklmnopqrst"
	var output strings.Builder
	for i := 0; i < n; i++ {
		random := rand.Intn(len(charSet))
		randomChar := charSet[random]
		output.WriteString(string(randomChar))
	}

	return output.String()
}
