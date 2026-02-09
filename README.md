# AI Core vLLM with Cloud Logging Integration

This deployment integrates vLLM with FluentBit to collect logs and metrics from AI Core and push them to Cloud Logging.

## Architecture

```
vLLM Server → JSON Logs → FluentBit → Cloud Logging (mTLS)
     ↓
Prometheus Metrics → FluentBit → Cloud Logging (mTLS)
```

## Prerequisites

1. **Cloud Logging Credentials** (from SAP BTP Cloud Foundry):
   - Cloud Logging host endpoint (e.g., `ingest.cf.sap.hana.ondemand.com`)
   - Cloud Logging user ID
   - Cloud Logging password

2. **AI Core Setup**:
   - Docker registry access configured
   - kubectl configured for your AI Core cluster

## Setup Steps

### 1. Create Kubernetes Secret

Run the secret creation script and provide your Cloud Logging credentials:
```bash
chmod +x create-secret.sh
./create-secret.sh
```

You'll be prompted for:
- Cloud Logging host (e.g., `ingest.cf.sap.hana.ondemand.com`)
- User ID
- Password


### 2. Build and Push Docker Image

```bash
cd code
docker build -t <your-registry>/vllm-openai:latest .
docker push <your-registry>/vllm-openai:latest
```

Update the image reference in `scenarios/vllm-serving-fluent-template.yaml` (line 65).

### 3. Deploy to AI Core

```bash
# Upload template to your GitHub repo
git add scenarios/vllm-serving-fluent-template.yaml
git commit -m "Add FluentBit logging integration"
git push

# Create deployment via AI Launchpad or API
# The deployment will automatically:
# - Start vLLM server
# - Start FluentBit sidecar
# - Collect application logs from /app/logs/app.log
# - Scrape Prometheus metrics from vLLM
# - Enrich all data with AI Core metadata
# - Push to Cloud Logging via mTLS
```

## What Gets Logged

### Application Logs
- Source: `/app/logs/app.log`
- Format: JSON
- Enriched with:
  - `deployment_id`: AI Core deployment ID
  - `resource_group`: Resource group name
  - `scenario_id`: Scenario identifier
  - `execution_id`: Execution UID
  - `log_type`: "application"

### Metrics
- Source: vLLM Prometheus endpoint (`http://localhost:8000/metrics`)
- Scrape interval: 30 seconds
- Enriched with same AI Core metadata
- `log_type`: "metrics"

## Monitoring

### FluentBit Health Check
FluentBit exposes a health endpoint on port 2020:
```bash
# From within the pod:
curl http://localhost:2020/api/v1/health
```

### View Logs in Cloud Logging
1. Go to SAP BTP Cockpit → Cloud Foundry → Logs
2. Filter by:
   - `deployment_id`: Your AI Core deployment ID
   - `log_type`: "application" or "metrics"
   - `scenario_id`: "vllm"

## Configuration Files

- `code/fluent-bit.yaml` - FluentBit configuration
- `code/logging_config.json` - Python JSON logging configuration
- `code/start.sh` - Startup script (launches FluentBit + vLLM)
- `code/Dockerfile` - Container image definition
- `scenarios/vllm-serving-fluent-template.yaml` - AI Core deployment template

## Troubleshooting

### Logs not appearing in Cloud Logging

1. Check FluentBit is running:
   ```bash
   kubectl logs <pod-name> -c kserve-container | grep -i fluent
   ```

2. Check secret exists and has correct keys:
   ```bash
   kubectl get secret cloud-logging-credentials
   kubectl describe secret cloud-logging-credentials
   ```

3. Check environment variables are set:
   ```bash
   kubectl exec <pod-name> -c kserve-container -- env | grep CLOUD_LOGGING
   ```

### FluentBit connection errors

- Verify the Cloud Logging host is correct (should be `ingest.cf.sap.hana.ondemand.com`, not `ingest-mtls`)
- Ensure user ID and password are correct
- Check network connectivity from AI Core to Cloud Logging endpoint
- Look for authentication errors in FluentBit logs

### vLLM not starting

- Check logs: `kubectl logs <pod-name> -c kserve-container`
- Verify the startup script has execute permissions
- Ensure all vLLM parameters are valid

## Customization

### Change metric scrape interval
Edit `code/fluent-bit.yaml`:
```yaml
scrape_interval: 30s  # Change to desired interval
```

### Add custom log filters
Edit `code/fluent-bit.yaml` and add filters in the `filters` section.

### Modify log format
Edit `code/logging_config.json` to change Python logging format.
