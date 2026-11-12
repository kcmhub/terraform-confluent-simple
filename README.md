# terraform-confluent-simple

[![ci](https://github.com/kcmhub/terraform-confluent-simple/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/kcmhub/terraform-confluent-simple/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/kcmhub/terraform-confluent-simple)](LICENSE)

A small, plain HCL example that creates the Kafka resources of one team on an **existing** Confluent Cloud cluster with the official [`confluentinc/confluent`](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs) provider. No modules, no YAML: every resource is written out so you can read it top to bottom and copy what you need.

What it creates for the `orders` team:

| File | Resources |
|------|-----------|
| [`topics.tf`](terraform/topics.tf) | `orders.order.created` (6 partitions, 7 days retention) and `orders.order.status` (compacted) |
| [`service-accounts.tf`](terraform/service-accounts.tf) | a producer and a consumer service account, each with a Kafka API key and a Schema Registry API key |
| [`rbac.tf`](terraform/rbac.tf) | `DeveloperWrite` for the producer on both topics; `DeveloperRead` for the consumer on `orders.order.created` and on the consumer group prefix `orders.order-consumer*`; `DeveloperRead` for both on the schema subject |
| [`schemas.tf`](terraform/schemas.tf) | the Avro subject `orders.order.created-value` with `BACKWARD` compatibility |
| [`owner.tf`](terraform/owner.tf) | optional owner metadata on the topics (see below) |

Environments, clusters, networks and Schema Registry are not managed here: they are read with data sources from their IDs.

## Prerequisites

- Terraform 1.5 or later.
- A Confluent Cloud environment with Stream Governance (Schema Registry) and a Kafka cluster that supports RBAC on topics (Standard, Enterprise or Dedicated, not Basic).
- A **Cloud API key** allowed to create service accounts, API keys and role bindings, for example owned by a service account with `OrganizationAdmin`.
- An existing **admin Kafka API key** and **admin Schema Registry API key** that Terraform uses to manage topics and schemas. For example, with the Confluent CLI:

```bash
confluent iam service-account create terraform-admin --description "Manages topics and schemas with Terraform"
confluent iam rbac role-binding create --principal User:<sa-id> --role CloudClusterAdmin --environment <env-id> --cloud-cluster <lkc-id>
confluent iam rbac role-binding create --principal User:<sa-id> --role ResourceOwner --environment <env-id> --schema-registry-cluster <lsrc-id> --resource "Subject:*"
confluent api-key create --service-account <sa-id> --resource <lkc-id>
confluent api-key create --service-account <sa-id> --resource <lsrc-id>
```

## Usage

```bash
cd terraform

# Cloud API key, read by the provider
export CONFLUENT_CLOUD_API_KEY="<cloud api key>"
export CONFLUENT_CLOUD_API_SECRET="<cloud api secret>"

# Existing admin keys, passed as sensitive variables
export TF_VAR_kafka_api_key="<kafka api key>"
export TF_VAR_kafka_api_secret="<kafka api secret>"
export TF_VAR_schema_registry_api_key="<schema registry api key>"
export TF_VAR_schema_registry_api_secret="<schema registry api secret>"

cp example.tfvars dev.tfvars   # then replace env-replaceme and lkc-replaceme
terraform init
terraform plan  -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars

# API keys for the applications
terraform output -json client_credentials
```

Keep the state in a remote backend with encryption and restricted access: it contains the API key secrets. Use one state per environment.

Removing a topic resource deletes the topic and its data, so read the plan before applying; add `lifecycle { prevent_destroy = true }` to a topic if you prefer the plan to fail instead. To bring an existing topic under Terraform, use an `import` block with the ID `<lkc-id>/<topic name>`; the provider then reads the Kafka credentials from the `IMPORT_KAFKA_API_KEY`, `IMPORT_KAFKA_API_SECRET` and `IMPORT_KAFKA_REST_ENDPOINT` environment variables (see the provider documentation).

## Owner metadata (`owner = true`)

```hcl
owner       = true
owner_email = "orders-team@example.com"
```

With `owner = true`, Terraform sets the Stream Catalog attributes `owner` (the team) and `ownerEmail` on each topic with [`confluent_catalog_entity_attributes`](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_catalog_entity_attributes). These are the built in owner fields of a topic in Confluent Cloud: they are shown with the topic metadata in the Cloud Console and can be searched in the Stream Catalog.

Limits:

- Topics only. Service accounts and API keys have no owner field, only a description. Schemas are catalog entities too, but they are addressed by their numeric schema ID and owner attributes on them are not covered here.
- Stream Governance must be enabled on the environment, and the Schema Registry API key must be allowed to edit catalog metadata (for example `DataSteward` on the environment, or `ResourceOwner` on the topics).
- A new topic can take a little time to appear in the catalog. If the first apply fails on `confluent_catalog_entity_attributes`, run apply again.
- Switching `owner` back to `false` removes the resource from Terraform; check in the Console that the attributes were cleared.

## ACLs instead of RBAC

This example uses RBAC role bindings, which Confluent recommends and which are managed with the Cloud API key. Kafka ACLs (`confluent_kafka_acl`) are the alternative, for example on Basic clusters: `WRITE` and `DESCRIBE` on the topic for a producer, `READ` on the topic and on a `PREFIXED` consumer group for a consumer, created with the admin Kafka API key.

## See these resources in KCM

Once applied, the topics, service accounts, role bindings and schemas are ordinary Confluent Cloud resources. [KCM](https://kcmhub.io) shows them, lets you check who can access what with its RBAC analyzer, and helps operate them day to day while Terraform stays the source of truth.

## License

[Apache License 2.0](LICENSE).
