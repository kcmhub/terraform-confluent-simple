# Least privilege access with Confluent Cloud RBAC role bindings on literal
# resources. Role bindings are managed with the Cloud API key.

# Producer: write to both topics, read the schema it serializes with.

resource "confluent_role_binding" "producer_write_order_created" {
  principal   = "User:${confluent_service_account.producer.id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${local.kafka_crn}/topic=${confluent_kafka_topic.order_created.topic_name}"
}

resource "confluent_role_binding" "producer_write_order_status" {
  principal   = "User:${confluent_service_account.producer.id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${local.kafka_crn}/topic=${confluent_kafka_topic.order_status.topic_name}"
}

resource "confluent_role_binding" "producer_read_subject" {
  principal   = "User:${confluent_service_account.producer.id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${local.schema_registry_crn}/subject=${confluent_schema.order_created_value.subject_name}"
}

# Consumer: read the topic, use consumer groups under its prefix, read the schema.

resource "confluent_role_binding" "consumer_read_order_created" {
  principal   = "User:${confluent_service_account.consumer.id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${local.kafka_crn}/topic=${confluent_kafka_topic.order_created.topic_name}"
}

resource "confluent_role_binding" "consumer_read_group" {
  principal   = "User:${confluent_service_account.consumer.id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${local.kafka_crn}/group=${local.consumer_group_prefix}*"
}

resource "confluent_role_binding" "consumer_read_subject" {
  principal   = "User:${confluent_service_account.consumer.id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${local.schema_registry_crn}/subject=${confluent_schema.order_created_value.subject_name}"
}
