FROM mcr.microsoft.com/vscode/devcontainers/base:bookworm

# Define build arguments
ARG USERNAME=vscode
ARG NODE_VERSION=20
ARG PYTHON_VERSION=3.11

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
  NODE_ENV=development \
  PATH="/home/${USERNAME}/.local/bin:$PATH" \
  PYTHONUNBUFFERED=1 \
  POETRY_VIRTUALENVS_PATH=/home/${USERNAME}/.cache/pypoetry/virtualenvs \
  POETRY_NO_INTERACTION=1

# System dependencies and tools installation (as root)
RUN apt-get update && apt-get install -y --no-install-recommends \
  # Install Python
  python${PYTHON_VERSION} \
  python${PYTHON_VERSION}-venv \
  python${PYTHON_VERSION}-dev \
  && ln -sf /usr/bin/python${PYTHON_VERSION} /usr/local/bin/python \
  && python --version \
  \
  # Install Node.js globally and PNPM
  && curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
  && apt-get update && apt-get install -y nodejs \
  && npm install -g pnpm --prefix /home/${USERNAME}/.local \
  && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.local \
  # Verify installations
  && node --version \
  && pnpm --version \
  \
  # Clean up apt cache to reduce image size
  && rm -rf /var/lib/apt/lists/*

# Switch to non-root user
USER ${USERNAME}

# User-specific installations and configurations
RUN \
  # Install Poetry
  curl -sSL https://install.python-poetry.org | python${PYTHON_VERSION} \
  && poetry config virtualenvs.in-project true \
  && poetry --version

# Set work directory
WORKDIR /workspaces
