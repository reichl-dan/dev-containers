FROM mcr.microsoft.com/vscode/devcontainers/base:bookworm

# Define build arguments
ARG USERNAME=vscode
ARG NODE_VERSION=23

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
  NODE_ENV=development \
  PATH="/home/${USERNAME}/.local/bin:$PATH"

# System dependencies and tools installation (as root)
RUN apt-get update && apt-get install -y --no-install-recommends \
  # Install Node.js globally and PNPM
  && curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
  && apt-get update && apt-get install -y nodejs \
  && npm install -g pnpm --prefix /home/${USERNAME}/.local \
  && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.local \
  && node --version \
  && pnpm --version \
  \
  # Clean up apt cache to reduce image size
  && rm -rf /var/lib/apt/lists/*

# Switch to non-root user
USER ${USERNAME}

# Set work directory
WORKDIR /workspaces
