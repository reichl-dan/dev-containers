#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting Docker Engine installation script for Debian/Ubuntu-based WSL2..."
echo "This script will use 'sudo' and may prompt for your password."

echo ""
echo "Which base distribution are you using?"
echo "  1) Debian"
echo "  2) Ubuntu"
read -p "Enter 1 for Debian or 2 for Ubuntu [1/2]: " distro_choice

if [[ "$distro_choice" == "1" ]]; then
    DOCKER_URL_BASE="https://download.docker.com/linux/debian"
    DOCKER_GPG_URL="$DOCKER_URL_BASE/gpg"
    DISTRO_NAME="debian"
elif [[ "$distro_choice" == "2" ]]; then
    DOCKER_URL_BASE="https://download.docker.com/linux/ubuntu"
    DOCKER_GPG_URL="$DOCKER_URL_BASE/gpg"
    DISTRO_NAME="ubuntu"
else
    echo "Invalid choice. Please enter 1 for Debian or 2 for Ubuntu."
    exit 1
fi

# --- STEP 1: Update System Packages ---
echo ""
echo ">>> STEP 1: Updating package list..."
sudo apt-get update
# Optional: Uncomment the next two lines if you want to upgrade all packages as well
# echo ">>> STEP 1b: Upgrading existing packages..."
# sudo apt-get upgrade -y

# --- STEP 2: Install Prerequisites ---
echo ""
echo ">>> STEP 2: Installing prerequisite packages..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# --- STEP 3: Add Docker’s official GPG key ---
echo ""
echo ">>> STEP 3: Adding Docker's official GPG key..."
sudo mkdir -p /etc/apt/keyrings
if [ -f "/etc/apt/keyrings/docker.gpg" ]; then
    sudo rm /etc/apt/keyrings/docker.gpg
fi
curl -fsSL "$DOCKER_GPG_URL" | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# --- STEP 4: Set up the Docker repository ---
echo ""
echo ">>> STEP 4: Setting up the Docker APT repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] $DOCKER_URL_BASE \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# --- STEP 5: Update package list with Docker repo ---
echo ""
echo ">>> STEP 5: Updating package list after adding Docker repo..."
sudo apt-get update

# --- STEP 6: Install Docker Engine, CLI, and containerd ---
echo ""
echo ">>> STEP 6: Installing Docker Engine, CLI, containerd, and plugins..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# --- STEP 7: Ensure docker group exists and add user ---
echo ""
echo ">>> STEP 7: Adding current user ($USER) to the 'docker' group..."
if ! getent group docker > /dev/null; then
    sudo groupadd docker
fi
sudo usermod -aG docker $USER

# --- Display Final Instructions ---
echo ""
echo "------------------------------------------------------------"
echo "Docker installation script finished successfully!"
echo "------------------------------------------------------------"
echo ""
echo "NEXT STEPS:"
echo "--------------------"
echo "1.  Apply group membership changes for '$USER':"
echo "    You MUST close this WSL terminal completely"
echo "    and open a new one."
echo ""
echo "2.  Test Docker service:"
echo "    docker run hello-world"
echo ""
echo "NOTES:"
echo "--------------------"
echo "If necessary, the Docker service can be started with:"
echo "sudo service docker start"
echo ""
echo "Check status of the Docker service with:"
echo "sudo service docker status"
echo ""
echo "------------------------------------------------------------"
echo ""
exit 0
