variable "environment_id" {
  description = "ID of the existing Confluent Cloud environment (env-...)."
  type        = string
}

variable "kafka_cluster_id" {
  description = "ID of the existing Kafka cluster (lkc-...)."
  type        = string
}

variable "environment_name" {
  description = "Short environment name, used as a prefix of service account names because service accounts are organization wide."
  type        = string
  default     = "dev"
}

variable "team" {
  description = "Team that owns the topics, service accounts and schema. Used in names, and as the owner when owner is true."
  type        = string
  default     = "orders"
}

variable "owner" {
  description = "When true, write the team and owner_email as owner metadata (Stream Catalog owner and ownerEmail) on the topics. Requires Stream Governance."
  type        = bool
  default     = false
}

variable "owner_email" {
  description = "Owner email written on the topics when owner is true."
  type        = string
  default     = ""
}

# Existing admin credentials. Terraform uses them to manage topics, schemas
# and catalog metadata; this configuration never creates them. Pass them as
# environment variables (TF_VAR_kafka_api_key, ...), not in a tfvars file.

variable "kafka_api_key" {
  description = "Existing Kafka API key allowed to manage topics on the cluster, for example owned by a service account with CloudClusterAdmin."
  type        = string
  sensitive   = true
}

variable "kafka_api_secret" {
  description = "Secret of kafka_api_key."
  type        = string
  sensitive   = true
}

variable "schema_registry_api_key" {
  description = "Existing Schema Registry API key allowed to manage subjects, and catalog metadata when owner is true."
  type        = string
  sensitive   = true
}

variable "schema_registry_api_secret" {
  description = "Secret of schema_registry_api_key."
  type        = string
  sensitive   = true
}
