# Deployment Checklist

## Pre-Deployment

- [ ] Obtained Cloud Logging credentials from BTP
  - [ ] Cloud Logging host URL (e.g., `ingest.cf.sap.hana.ondemand.com`)
  - [ ] User ID
  - [ ] Password

- [ ] Created Kubernetes secret
  ```bash
  ./create-secret.sh
  ```

- [ ] Built Docker image
  ```bash
  cd code
  docker build -t <registry>/vllm-openai:latest .
  ```

- [ ] Pushed Docker image
  ```bash
  docker push <registry>/vllm-openai:latest
  ```

- [ ] Updated `scenarios/vllm-serving-fluent-template.yaml`
  - [ ] Line 60: `imagePullSecrets` name
  - [ ] Line 65: Image URL

## Deployment

- [ ] Committed and pushed template to GitHub
  ```bash
  git add scenarios/vllm-serving-fluent-template.yaml
  git commit -m "Add Cloud Logging integration"
  git push
  ```

- [ ] Created deployment in AI Launchpad
  - [ ] Selected correct resource plan
  - [ ] Configured model parameters
  - [ ] Deployment started successfully

## Verification

- [ ] Pod is running
  ```bash
  kubectl get pods | grep vllm
  ```

- [ ] FluentBit started successfully
  ```bash
  kubectl logs <pod-name> | grep -i fluent
  ```

- [ ] vLLM server is healthy
  ```bash
  curl <deployment-url>/health
  ```

- [ ] Logs appearing in Cloud Logging
  - [ ] Application logs visible (log_type: application)
  - [ ] Metrics visible (log_type: metrics)
  - [ ] AI Core metadata present (deployment_id, scenario_id, etc.)

## Troubleshooting

If logs not appearing:

- [ ] Check FluentBit logs for errors
  ```bash
  kubectl logs <pod-name> | grep -i error
  ```

- [ ] Verify secret exists
  ```bash
  kubectl get secret cloud-logging-credentials
  ```

- [ ] Verify certificates mounted
  ```bash
  kubectl exec <pod-name> -- env | grep CLOUD_LOGGING
  ```

- [ ] Check environment variables
  ```bash
  kubectl exec <pod-name> -- env | grep CLOUD_LOGGING
  ```

## Success Criteria

✅ vLLM server responds to inference requests
✅ Application logs flowing to Cloud Logging
✅ Prometheus metrics flowing to Cloud Logging
✅ All logs enriched with AI Core metadata
✅ mTLS connection to Cloud Logging working
