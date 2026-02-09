# Quick Start Guide

## One-Time Setup (Before First Deployment)

1. **Get Cloud Logging credentials from BTP**:
   - Cloud Logging host (e.g., `ingest.cf.sap.hana.ondemand.com`)
   - User ID
   - Password

2. **Create Kubernetes secret**:
   ```bash
   ./create-secret.sh
   # Enter host, user ID, and password when prompted
   ```

3. **Build and push image**:
   ```bash
   cd code
   docker build -t <your-registry>/vllm-openai:latest .
   docker push <your-registry>/vllm-openai:latest
   ```

4. **Update deployment template**:
   - Edit `scenarios/vllm-serving-fluent-template.yaml`
   - Line 60: Update `imagePullSecrets` name
   - Line 65: Update image URL to your registry

## Deploy

1. Push template to GitHub
2. Create deployment in AI Launchpad
3. Logs automatically flow to Cloud Logging!

## Verify

Check logs in BTP Cockpit → Cloud Foundry → Logs:
- Filter by `deployment_id` or `scenario_id: vllm`
- You'll see both application logs and metrics

## Files Overview

| File | Purpose |
|------|---------|
| `code/fluent-bit.yaml` | FluentBit config (inputs, filters, outputs) |
| `code/logging_config.json` | Python JSON logging setup |
| `code/start.sh` | Launches FluentBit + vLLM |
| `code/Dockerfile` | Container image |
| `scenarios/vllm-serving-fluent-template.yaml` | AI Core deployment |
| `create-secret.sh` | Creates K8s secret for certs |
