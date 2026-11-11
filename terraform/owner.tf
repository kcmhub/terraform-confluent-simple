# Optional owner metadata (owner = true).
#
# Sets the built in "owner" and "ownerEmail" attributes of each topic in the
# Stream Catalog, where Confluent Cloud shows them and makes them searchable.
# Requires Stream Governance on the environment, and the Schema Registry API
# key must be allowed to edit catalog metadata (for example DataSteward on the
# environment, or ResourceOwner on the topics).

locals {
  owned_topics = var.owner ? {
    order_created = confluent_kafka_topic.order_created.topic_name
    order_status  = confluent_kafka_topic.order_status.topic_name
  } : {}
}

resource "confluent_catalog_entity_attributes" "topic_owner" {
  for_each = local.owned_topics

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.this.id
  }
  rest_endpoint = data.confluent_schema_registry_cluster.this.rest_endpoint

  entity_name = "${data.confluent_kafka_cluster.this.id}:${each.value}"
  entity_type = "kafka_topic"
  attributes = {
    "owner"      = var.team
    "ownerEmail" = var.owner_email
  }

  credentials {
    key    = var.schema_registry_api_key
    secret = var.schema_registry_api_secret
  }
}
