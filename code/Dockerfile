ARG BASE_IMAGE=vllm/vllm-openai:latest
FROM ${BASE_IMAGE}
ENV LANG=C.UTF-8

# Install Fluent Bit v3.2+ (supports YAML config)
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl -fsSL https://packages.fluentbit.io/fluentbit.key | gpg --dearmor -o /usr/share/keyrings/fluentbit-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/fluentbit-keyring.gpg] https://packages.fluentbit.io/ubuntu/jammy jammy main" > /etc/apt/sources.list.d/fluent-bit.list && \
    apt-get update && \
    apt-get install -y fluent-bit && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Adaptation for SAP AI Core
RUN mkdir -p /nonexistent/ &&\
    mkdir -p /hf-home/ && \ 
    chown -R nobody:nogroup /nonexistent /hf-home/ && \
    chmod -R 770 /nonexistent/ /hf-home/

ENV HF_HOME=/hf-home

# Copy Fluent Bit configuration
RUN mkdir -p /fluent-bit/etc
COPY fluent-bit.yaml /fluent-bit/etc/fluent-bit.yaml

# Copy Python logging configuration
RUN mkdir -p /app /app/logs && \
    chown -R nobody:nogroup /app/logs && \
    chmod -R 770 /app/logs
COPY logging_config.json /app/logging_config.json
ENV VLLM_LOGGING_CONFIG_PATH="/app/logging_config.json"
ENV ENABLE_JSON_LOGGING="true"