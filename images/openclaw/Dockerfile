ARG OPENCLAW_BASE=coollabsio/openclaw:latest
FROM ${OPENCLAW_BASE}

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    diffutils \
    dumb-init \
    git \
    jq \
    patch \
    procps \
    rsync \
    && npm install -g opencode-ai \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/openclaw-stack

COPY images/openclaw/entrypoint.sh /opt/openclaw-stack/entrypoint.sh
COPY images/openclaw/run-openclaw.sh /opt/openclaw-stack/run-openclaw.sh
COPY bootstrap /opt/openclaw-stack/bootstrap

RUN chmod +x /opt/openclaw-stack/entrypoint.sh /opt/openclaw-stack/run-openclaw.sh \
    && find /opt/openclaw-stack/bootstrap/system/scripts -type f -name "*.sh" -exec chmod +x {} \;

VOLUME ["/data"]
EXPOSE 18789

ENTRYPOINT ["dumb-init", "--", "/opt/openclaw-stack/entrypoint.sh"]
