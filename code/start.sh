#!/bin/bash
set -e

echo "=== Starting AI Core vLLM with FluentBit Logging ==="

# Create log directory if it doesn't exist
mkdir -p /app/logs
chmod 770 /app/logs

# Start FluentBit in background
echo "Starting FluentBit..."
/opt/fluent-bit/bin/fluent-bit -c /fluent-bit/etc/fluent-bit.yaml &
FLUENT_PID=$!
echo "FluentBit started with PID: $FLUENT_PID"

# Give FluentBit a moment to initialize
sleep 2

# Start vLLM server
echo "Starting vLLM OpenAI API Server..."
exec python3 -m vllm.entrypoints.openai.api_server "$@"
