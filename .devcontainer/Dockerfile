FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends acl && \
    rm -rf /var/lib/apt/lists/*
