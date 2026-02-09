# Quick Test Guide for .rest/ai-core.http

## ✅ Updated for Deployment: d6f93e380d081140

The `.rest/ai-core.http` file has been updated with your new vLLM deployment with FluentBit logging.

---

## 🚀 How to Use (VS Code REST Client)

### 1. Install Extension
- Install **REST Client** extension in VS Code
- By Huachao Mao

### 2. Open the File
```
.rest/ai-core.http
```

### 3. Run Tests
Click "Send Request" above each `###` section

---

## 📋 Available Tests

### 1. **auth** - Get Access Token
- Authenticates with AI Core
- Stores token in `@access_token` variable
- **Run this first!**

### 2. **healthCheck** - Check Deployment Health ✨ NEW
- Verifies deployment is running
- Quick status check

### 3. **getDeploymentLogs** - Get AI Core Logs
- Retrieves deployment logs from AI Core
- Shows last 1000 log entries

### 4. **vLLMCompletions** - Text Completion
- Simple text completion
- Prompt: "The capital of France is"
- Returns 20 tokens

### 5. **vLLMChatCompletions** - Chat Completion
- Chat-style interaction
- Prompt: "Write a poem about the sea"
- Returns 100 tokens

### 6. **vLLMStreamingCompletion** - Streaming Response ✨ NEW
- Streaming text completion
- Prompt: "Once upon a time"
- Returns tokens as they're generated

### 7. **vLLMMetrics** - Prometheus Metrics
- Get vLLM performance metrics
- GPU usage, request counts, etc.

### 8. **vLLMModelInfo** - Model Information ✨ NEW
- Get loaded model details
- Model name, version, etc.

### 9. **pushLogToCloudLogging** - Test Cloud Logging
- Sends test log to Cloud Logging
- Verifies FluentBit integration

---

## 🔧 Environment Variables Required

Make sure your `.env` file has:

```env
# AI Core Configuration
URL=https://api.ai.prod-ap11.ap-southeast-1.aws.ml.hana.ondemand.com
TOKEN_URL=https://your-auth-url.authentication.ap11.hana.ondemand.com
CLIENT_ID=your-client-id
CLIENT_SECRET=your-client-secret
RESOURCE_GROUP=default

# Cloud Logging Configuration
LOG_HOST=ingest-sf-f56bedb7-a00a-41a9-8501-3a1d335c9e1a.001.ap11.cls.services.cloud.sap
LOG_USER=xGJOrBVvsO
LOG_PASSWORD=FVfIHWJQujlBGNXjgXbMzvL
```

---

## 📝 Test Sequence

**Recommended order:**

1. ✅ **auth** - Get token (required first)
2. ✅ **healthCheck** - Verify deployment is up
3. ✅ **vLLMModelInfo** - Check loaded model
4. ✅ **vLLMCompletions** - Test simple completion
5. ✅ **vLLMChatCompletions** - Test chat
6. ✅ **vLLMStreamingCompletion** - Test streaming
7. ✅ **vLLMMetrics** - Check performance metrics
8. ✅ **getDeploymentLogs** - View AI Core logs
9. ✅ **pushLogToCloudLogging** - Test Cloud Logging

---

## 🎯 Quick Start

1. Open `.rest/ai-core.http` in VS Code
2. Click "Send Request" on **auth**
3. Wait for token response
4. Click "Send Request" on **healthCheck**
5. If healthy, try other tests!

---

## ✨ What's New

- ✅ Updated deployment ID to `d6f93e380d081140`
- ✅ Added **healthCheck** endpoint
- ✅ Added **vLLMStreamingCompletion** test
- ✅ Added **vLLMModelInfo** endpoint
- ✅ Updated Cloud Logging test with deployment ID
- ✅ Added model parameter to chat completions

---

**All tests are ready to run! Start with `auth` then `healthCheck`!** 🚀
