# 🚀 Ready to Deploy!

## ✅ Completed Steps

1. ✅ **Docker Image Built and Pushed**
   - Image: `sriramrokkam/vllm-openai:fluent`
   - Location: Docker Hub (public)
   - Includes: vLLM + FluentBit + Cloud Logging integration

2. ✅ **Template Pushed to GitHub**
   - Repository: `https://github.com/sriramrokkam/ai-core-vllm-fluent.git`
   - Template: `scenarios/vllm-serving-fluent-template.yaml`
   - Scenario ID: `vllm-fluent`

3. ✅ **Configuration Ready**
   - FluentBit configured for Cloud Logging
   - Basic auth credentials (no certificates needed)
   - Startup sequence: vLLM first (90s), then FluentBit

---

## 🎯 Next Steps - Deploy to AI Core

### Step 1: Create Cloud Logging Secret in AI Launchpad

1. Go to **AI Launchpad** → **ML Operations** → **Secrets**
2. Click **Create**
3. Enter details:
   - **Name**: `cloud-logging-credentials`
   - **Data** (add 3 key-value pairs):
     - Key: `host`, Value: `ingest-sf-f56bedb7-a00a-41a9-8501-3a1d335c9e1a.001.ap11.cls.services.cloud.sap`
     - Key: `user`, Value: `xGJOrBVvsO`
     - Key: `password`, Value: `FVfIHWJQujlBGNXjgXbMzvL`
4. Click **Create**

### Step 2: Register Application in AI Launchpad

1. Go to **AI Launchpad** → **ML Operations** → **Applications**
2. Click **Add**
3. Enter:
   - **Repository URL**: `https://github.com/sriramrokkam/ai-core-vllm-fluent.git`
   - **Revision**: `main`
   - **Path**: `scenarios`
4. Click **Add**
5. Wait for sync (should show `vllm-fluent` scenario)

### Step 3: Create Configuration

1. Go to **Scenarios** → Select `vllm-fluent`
2. Click **Create Configuration**
3. Set parameters:
   - **modelName**: `facebook/opt-125m` (or your preferred model)
   - **dataType**: `half`
   - **gpuMemoryUtilization**: `0.9`
   - **maxTokenLen**: `2048`
   - **maxNumBatchedTokens**: `2048`
   - **maxNumSeqs**: `2048`
   - **quantization**: `None`
   - **resourcePlan**: `infer.s` (or your preferred plan)
4. Click **Create**

### Step 4: Create Deployment

1. From your configuration, click **Create Deployment**
2. Wait for deployment to start (may take 5-10 minutes)
3. Status should change to **Running**

### Step 5: Verify Deployment

#### Check Pod Status
```bash
# If you have kubectl access
kubectl get pods | grep vllm
```

#### Check Logs
```bash
# Check if vLLM started
kubectl logs <pod-name> | grep "vLLM"

# Check if FluentBit started
kubectl logs <pod-name> | grep -i fluent
```

#### Test Inference
Once deployed, get the deployment URL and test:
```bash
curl -X POST "<deployment-url>/v1/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your-token>" \
  -d '{
    "model": "facebook/opt-125m",
    "prompt": "Hello, how are you?",
    "max_tokens": 50
  }'
```

### Step 6: Verify Logs in Cloud Logging

1. Go to **SAP BTP Cockpit** → **Cloud Foundry** → **Logs**
2. Filter by:
   - Search for logs from your deployment
   - Look for vLLM application logs
   - Look for Prometheus metrics

You should see:
- Application logs from vLLM
- Metrics from Prometheus scraping
- All logs sent to Cloud Logging endpoint

---

## 📋 Deployment Summary

| Component | Value |
|-----------|-------|
| **Scenario ID** | `vllm-fluent` |
| **Docker Image** | `sriramrokkam/vllm-openai:fluent` |
| **GitHub Repo** | `https://github.com/sriramrokkam/ai-core-vllm-fluent.git` |
| **Template** | `scenarios/vllm-serving-fluent-template.yaml` |
| **Secret Name** | `cloud-logging-credentials` |
| **Cloud Logging Host** | `ingest-sf-f56bedb7-a00a-41a9-8501-3a1d335c9e1a.001.ap11.cls.services.cloud.sap` |

---

## 🔍 Troubleshooting

### Deployment Fails to Start
- Check if secret `cloud-logging-credentials` exists
- Verify resource plan is available
- Check AI Core quota

### No Logs in Cloud Logging
- Verify secret has correct credentials
- Check FluentBit logs: `kubectl logs <pod-name> | grep -i fluent`
- Verify network connectivity from AI Core to Cloud Logging

### vLLM Not Responding
- Check pod logs: `kubectl logs <pod-name>`
- Verify model name is correct
- Check resource allocation (GPU/CPU)

---

## 🎉 You're Ready!

Everything is configured and ready to deploy. Just follow the steps above in AI Launchpad!
