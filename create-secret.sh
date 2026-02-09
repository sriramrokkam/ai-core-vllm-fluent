#!/bin/bash
# Script to create Kubernetes secret for Cloud Logging credentials
# This should be run ONCE before deploying to AI Core

set -e

echo "=== Creating Cloud Logging Credentials Secret ==="
echo ""

# Get Cloud Logging credentials from user
read -p "Enter Cloud Logging Host (e.g., ingest.cf.sap.hana.ondemand.com): " CLOUD_LOGGING_HOST
read -p "Enter Cloud Logging User ID: " CLOUD_LOGGING_USER
read -sp "Enter Cloud Logging Password: " CLOUD_LOGGING_PASSWORD
echo ""

# Validate inputs
if [ -z "$CLOUD_LOGGING_HOST" ]; then
    echo "Error: Cloud Logging host cannot be empty"
    exit 1
fi

if [ -z "$CLOUD_LOGGING_USER" ]; then
    echo "Error: Cloud Logging user cannot be empty"
    exit 1
fi

if [ -z "$CLOUD_LOGGING_PASSWORD" ]; then
    echo "Error: Cloud Logging password cannot be empty"
    exit 1
fi

# Create the secret
kubectl create secret generic cloud-logging-credentials \
    --from-literal=host="$CLOUD_LOGGING_HOST" \
    --from-literal=user="$CLOUD_LOGGING_USER" \
    --from-literal=password="$CLOUD_LOGGING_PASSWORD" \
    --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "✅ Secret 'cloud-logging-credentials' created successfully!"
echo ""
echo "Next steps:"
echo "1. Build and push your Docker image"
echo "2. Deploy using vllm-serving-fluent-template.yaml"
echo "3. Logs and metrics will automatically flow to Cloud Logging"

