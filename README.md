# vLLM with Fluent Bit for SAP AI Core

This repository contains deployment templates for running vLLM with Fluent Bit logging on SAP AI Core.

## Contents

- `scenarios/` - AI Core serving templates
  - `vllm-serving-fluent-template.yaml` - vLLM deployment with Fluent Bit logging
  - `vllm-serving-template.yaml` - Basic vLLM deployment (without logging)

- `code/` - Docker build files
  - `Dockerfile` - Custom vLLM image with Fluent Bit
  - `fluent-bit.yaml` - Fluent Bit configuration for OpenSearch
  - `logging_config.json` - Python logging configuration for vLLM

## Available Scenarios

- **vllm-fluent**: vLLM server with Fluent Bit logging to SAP Cloud Logging

## Deployment

1. Create secret `cloud-logging-credentials` in AI Core
2. Create configuration using scenario `vllm-fluent`
3. Create deployment

## Docker Image

- Registry: `sriramrokkam/vllm-fluent:v1.0`
- Base: `vllm/vllm-openai:latest`
- Additions: Fluent Bit v3.2+, logging configuration
