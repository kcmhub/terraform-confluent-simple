# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project uses [Semantic Versioning](https://semver.org/).

## [0.1.0] - 2026-11-11

### Added

- Plain HCL configuration in `terraform/` for one team on an existing Confluent Cloud cluster: 2 topics, a producer and a consumer service account with their Kafka and Schema Registry API keys, RBAC role bindings, an Avro schema with its compatibility level.
- Optional `owner` flag that writes the team and an email as Stream Catalog owner metadata on the topics.
- CI: fmt, init and validate.
