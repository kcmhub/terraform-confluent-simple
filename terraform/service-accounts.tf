# One service account per application, each with its own API keys.

resource "confluent_service_account" "producer" {
  display_name = "${var.environment_name}-${var.team}-order-producer"
  description  = "Publishes orders and order statuses. Managed by Terraform."
}

resource "confluent_service_account" "consumer" {
  display_name = "${var.environment_name}-${var.team}-order-consumer"
  description  = "Reads created orders. Managed by Terraform."
}

resource "confluent_api_key" "producer_kafka" {
  display_name = "${confluent_service_account.producer.display_name}-kafka"
  description  = "Kafka API key of the order producer. Managed by Terraform."

  owner {
    id          = confluent_service_account.producer.id
    api_version = confluent_service_account.producer.api_version
    kind        = confluent_service_account.producer.kind
  }

  managed_resource {
    id          = data.confluent_kafka_cluster.this.id
    api_version = data.confluent_kafka_cluster.this.api_version
    kind        = data.confluent_kafka_cluster.this.kind

    environment {
      id = data.confluent_environment.this.id
    }
  }
}

resource "confluent_api_key" "consumer_kafka" {
  display_name = "${confluent_service_account.consumer.display_name}-kafka"
  description  = "Kafka API key of the order consumer. Managed by Terraform."

  owner {
    id          = confluent_service_account.consumer.id
    api_version = confluent_service_account.consumer.api_version
    kind        = confluent_service_account.consumer.kind
  }

  managed_resource {
    id          = data.confluent_kafka_cluster.this.id
    api_version = data.confluent_kafka_cluster.this.api_version
    kind        = data.confluent_kafka_cluster.this.kind

    environment {
      id = data.confluent_environment.this.id
    }
  }
}

# Schema Registry API keys: the clients need them to fetch the schema.

resource "confluent_api_key" "producer_schema_registry" {
  display_name = "${confluent_service_account.producer.display_name}-schema-registry"
  description  = "Schema Registry API key of the order producer. Managed by Terraform."

  owner {
    id          = confluent_service_account.producer.id
    api_version = confluent_service_account.producer.api_version
    kind        = confluent_service_account.producer.kind
  }

  managed_resource {
    id          = data.confluent_schema_registry_cluster.this.id
    api_version = data.confluent_schema_registry_cluster.this.api_version
    kind        = data.confluent_schema_registry_cluster.this.kind

    environment {
      id = data.confluent_environment.this.id
    }
  }
}

resource "confluent_api_key" "consumer_schema_registry" {
  display_name = "${confluent_service_account.consumer.display_name}-schema-registry"
  description  = "Schema Registry API key of the order consumer. Managed by Terraform."

  owner {
    id          = confluent_service_account.consumer.id
    api_version = confluent_service_account.consumer.api_version
    kind        = confluent_service_account.consumer.kind
  }

  managed_resource {
    id          = data.confluent_schema_registry_cluster.this.id
    api_version = data.confluent_schema_registry_cluster.this.api_version
    kind        = data.confluent_schema_registry_cluster.this.kind

    environment {
      id = data.confluent_environment.this.id
    }
  }
}
