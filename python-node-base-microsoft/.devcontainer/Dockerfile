FROM mcr.microsoft.com/vscode/devcontainers/base:bookworm

# Define build arguments
ARG PYTHON_VERSION=3.11
ARG NODE_VERSION=22
ARG USERNAME=vscode

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
  NODE_ENV=development \
  PATH="/home/${USERNAME}/.local/bin:$PATH" \
  PYTHONUNBUFFERED=1 \
  POETRY_VIRTUALENVS_PATH=/home/${USERNAME}/.cache/pypoetry/virtualenvs \
  POETRY_NO_INTERACTION=1

# Install Python
RUN apt-get update && apt-get install -y --no-install-recommends \
  python${PYTHON_VERSION} \
  python${PYTHON_VERSION}-venv \
  python${PYTHON_VERSION}-dev \
  && rm -rf /var/lib/apt/lists/*

# Install Node.js globally and PNPM, then remove npm
RUN curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g pnpm --prefix /home/${USERNAME}/.local \
  && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.local \
  && apt-get remove -y npm \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /usr/lib/node_modules/npm /usr/share/man/man1/npm* /usr/bin/npm /usr/bin/npx

# Switch to non-root user
USER ${USERNAME}

# Install Poetry as non-root user
RUN curl -sSL https://install.python-poetry.org | python${PYTHON_VERSION} \
  && poetry config virtualenvs.in-project true

# Verify installations
RUN python3 --version \
  && node --version \
  && poetry --version \
  && pnpm --version

# Set work directory
WORKDIR /workspaces
