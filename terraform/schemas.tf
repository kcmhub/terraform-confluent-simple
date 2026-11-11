# Value schema of the order created topic (TopicNameStrategy: <topic>-value).

# The compatibility level is set before the first registration so that every
# version of the schema, including the first one, is checked against it.
resource "confluent_subject_config" "order_created_value" {
  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.this.id
  }
  rest_endpoint = data.confluent_schema_registry_cluster.this.rest_endpoint

  subject_name        = "${confluent_kafka_topic.order_created.topic_name}-value"
  compatibility_level = "BACKWARD"

  credentials {
    key    = var.schema_registry_api_key
    secret = var.schema_registry_api_secret
  }
}

resource "confluent_schema" "order_created_value" {
  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.this.id
  }
  rest_endpoint = data.confluent_schema_registry_cluster.this.rest_endpoint

  subject_name = confluent_subject_config.order_created_value.subject_name
  format       = "AVRO"
  schema       = file("${path.module}/schemas/order-created.avsc")

  credentials {
    key    = var.schema_registry_api_key
    secret = var.schema_registry_api_secret
  }
}
