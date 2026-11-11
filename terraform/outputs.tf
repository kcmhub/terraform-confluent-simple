output "topics" {
  description = "Names of the topics."
  value = [
    confluent_kafka_topic.order_created.topic_name,
    confluent_kafka_topic.order_status.topic_name,
  ]
}

output "service_accounts" {
  description = "Service account IDs by application."
  value = {
    producer = confluent_service_account.producer.id
    consumer = confluent_service_account.consumer.id
  }
}

output "schema" {
  description = "Subject, version and ID of the registered schema."
  value = {
    subject   = confluent_schema.order_created_value.subject_name
    version   = confluent_schema.order_created_value.version
    schema_id = confluent_schema.order_created_value.schema_identifier
  }
}

output "connection" {
  description = "Endpoints the applications connect to."
  value = {
    bootstrap_servers   = data.confluent_kafka_cluster.this.bootstrap_endpoint
    schema_registry_url = data.confluent_schema_registry_cluster.this.rest_endpoint
  }
}

output "client_credentials" {
  description = "API keys of the applications. Read them with: terraform output -json client_credentials"
  sensitive   = true
  value = {
    producer = {
      kafka_api_key              = confluent_api_key.producer_kafka.id
      kafka_api_secret           = confluent_api_key.producer_kafka.secret
      schema_registry_api_key    = confluent_api_key.producer_schema_registry.id
      schema_registry_api_secret = confluent_api_key.producer_schema_registry.secret
    }
    consumer = {
      kafka_api_key              = confluent_api_key.consumer_kafka.id
      kafka_api_secret           = confluent_api_key.consumer_kafka.secret
      schema_registry_api_key    = confluent_api_key.consumer_schema_registry.id
      schema_registry_api_secret = confluent_api_key.consumer_schema_registry.secret
    }
  }
}
