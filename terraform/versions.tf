terraform {
  required_version = ">= 1.5.0"

  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 2.94"
    }
  }
}

# The provider reads the Cloud API key from the environment:
#   export CONFLUENT_CLOUD_API_KEY=...
#   export CONFLUENT_CLOUD_API_SECRET=...
provider "confluent" {}
