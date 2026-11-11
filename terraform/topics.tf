resource "confluent_kafka_topic" "order_created" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.this.id
  }
  rest_endpoint = data.confluent_kafka_cluster.this.rest_endpoint

  topic_name       = "${var.team}.order.created"
  partitions_count = 6
  config = {
    "cleanup.policy" = "delete"
    "retention.ms"   = "604800000" # 7 days
  }

  credentials {
    key    = var.kafka_api_key
    secret = var.kafka_api_secret
  }

  lifecycle {
    # Deleting a topic deletes its data: remove this line on purpose first.
    prevent_destroy = true
  }
}

resource "confluent_kafka_topic" "order_status" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.this.id
  }
  rest_endpoint = data.confluent_kafka_cluster.this.rest_endpoint

  topic_name       = "${var.team}.order.status"
  partitions_count = 3
  config = {
    "cleanup.policy" = "compact" # latest status per order ID
  }

  credentials {
    key    = var.kafka_api_key
    secret = var.kafka_api_secret
  }

  lifecycle {
    prevent_destroy = true
  }
}
