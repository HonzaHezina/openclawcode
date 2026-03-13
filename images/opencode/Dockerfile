ARG OPENCODE_BASE=ghcr.io/anomalyco/opencode:latest
FROM ${OPENCODE_BASE}

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    dumb-init \
    rsync \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/opencode-stack

COPY images/opencode/entrypoint.sh /opt/opencode-stack/entrypoint.sh
COPY images/opencode/run-opencode.sh /opt/opencode-stack/run-opencode.sh
COPY bootstrap/opencode /opt/opencode-stack/bootstrap/opencode
COPY bootstrap/workspaces /opt/opencode-stack/bootstrap/workspaces

RUN chmod +x /opt/opencode-stack/entrypoint.sh /opt/opencode-stack/run-opencode.sh

VOLUME ["/data"]
EXPOSE 4096

ENTRYPOINT ["dumb-init", "--", "/opt/opencode-stack/entrypoint.sh"]
