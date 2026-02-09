# Prometheus → FluentBit → Cloud Logging Verification Guide

## Deployment: d6f93e380d081140

---

## ✅ Verification Checklist

### 1. Verify vLLM Metrics Endpoint

**Test:** Open `test_metrics_v1.http` and run "Standard AI Core Metrics Endpoint"

**Expected:**
- Status: 200 OK
- Content-Type: text/plain (Prometheus format)
- Body contains: `vllm:num_requests_running`, `vllm:gpu_cache_usage_perc`, etc.

**Result:** [ ] PASS [ ] FAIL

---

### 2. Verify FluentBit is Running

**Test:** Check deployment logs for FluentBit startup

**Look for:**
```
Starting FluentBit...
FluentBit started with PID: <number>
[info] [fluent bit] version=...
```

**Result:** [ ] PASS [ ] FAIL

---

### 3. Verify Prometheus Scraping

**Test:** Check deployment logs for scraping activity

**Look for (after ~90 seconds):**
```
[info] [input:prometheus_scrape:prometheus_scrape.1] scraping metrics from 127.0.0.1:8000/metrics
```

**Ignore initial errors:**
```
[error] [input:prometheus_scrape:prometheus_scrape.1] error decoding Prometheus Text format
```
These are expected until vLLM starts (~90s). FluentBit will retry automatically.

**Result:** [ ] PASS [ ] FAIL

---

### 4. Verify Data in Cloud Logging

**Test:** Check SAP BTP Cockpit → Cloud Foundry → Logs

**Search Query:**
```
deployment_id:"d6f93e380d081140" AND source:"vllm_prometheus"
```

**Expected:** JSON entries with:
- `name`: metric name (e.g., `vllm:num_requests_running`)
- `value`: metric value
- `labels`: metric labels
- `source`: `vllm_prometheus`
- `deployment_id`: `d6f93e380d081140`

**Result:** [ ] PASS [ ] FAIL

---

## 🐛 Troubleshooting

### Issue: "error decoding Prometheus Text format"

**Cause:** vLLM hasn't started yet (takes ~90 seconds)

**Solution:** 
- ✅ **This is EXPECTED** during startup
- FluentBit will automatically retry every 30 seconds
- Error should stop after vLLM is ready
- No action needed

**Verify:** Wait 2-3 minutes, then check if errors stop

---

### Issue: No metrics in Cloud Logging

**Check:**
1. vLLM metrics endpoint returns data (test_metrics_v1.http)
2. FluentBit logs show successful scraping
3. Cloud Logging credentials are correct in secret
4. Network connectivity from pod to Cloud Logging

**Debug:**
```bash
# Check FluentBit logs
kubectl logs <pod-name> | grep -i prometheus

# Check Cloud Logging connection
kubectl logs <pod-name> | grep -i "http.*opensearch"
```

---

### Issue: Metrics endpoint returns 404

**Cause:** vLLM hasn't fully started

**Solution:** Wait for vLLM to be ready

**Verify:**
```http
### Health Check
GET https://api.ai.prod-ap11.ap-southeast-1.aws.ml.hana.ondemand.com/v2/inference/deployments/d6f93e380d081140/health
```

Should return: `{"status": "healthy"}`

---

## 📊 Understanding the Flow

```
┌─────────┐
│  vLLM   │ Exposes metrics at :8000/metrics
│ Server  │ (Prometheus text format)
└────┬────┘
     │
     │ HTTP GET every 30s
     ▼
┌─────────────┐
│  FluentBit  │ Scrapes & converts to JSON
│ prometheus_ │ Adds metadata (deployment_id, source)
│   scrape    │
└──────┬──────┘
       │
       │ HTTPS POST (Basic Auth)
       ▼
┌──────────────┐
│    Cloud     │ Stores metrics as JSON logs
│   Logging    │ Searchable by deployment_id
└──────────────┘
```

---

## 🎯 Quick Test Commands

### Test 1: vLLM Metrics (via .http file)
Open `test_metrics_v1.http` → Run "Standard AI Core Metrics Endpoint"

### Test 2: Deployment Logs
Open `.rest/ai-core.http` → Run "getDeploymentLogs"

### Test 3: Cloud Logging
Go to BTP Cockpit → Logs → Search: `deployment_id:"d6f93e380d081140"`

---

## ✅ Success Criteria

All of these should be true:

1. ✅ vLLM `/metrics` endpoint returns Prometheus data
2. ✅ FluentBit logs show "scraping metrics" messages
3. ✅ No persistent "error decoding" messages (after 2-3 min)
4. ✅ Cloud Logging shows entries with `source: vllm_prometheus`
5. ✅ Metrics update every 30 seconds in Cloud Logging

---

**Current Status:** 
- Deployment: d6f93e380d081140
- Expected startup time: ~90 seconds for vLLM
- Scrape interval: 30 seconds
- Initial errors: Normal (FluentBit retries automatically)
