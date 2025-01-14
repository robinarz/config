#!/bin/bash -e

# Variables
DOCKER_APT_SOURCE="/etc/apt/sources.list.d/docker.list"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    echo -e "${GREEN}Docker is already installed!${NC}"
    docker --version
    exit 0
fi

echo -e "${GREEN}Docker not found. Starting installation...${NC}"

echo -e "${GREEN}Updating package index...${NC}"
sudo apt-get update -y

echo -e "${GREEN}Installing required packages...${NC}"
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo -e "${GREEN}Adding Docker's official GPG key...${NC}"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo -e "${GREEN}Setting up the Docker repository...${NC}"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee "$DOCKER_APT_SOURCE" > /dev/null

echo -e "${GREEN}Updating package index again...${NC}"
sudo apt-get update -y

echo -e "${GREEN}Installing Docker Engine, CLI, and containerd...${NC}"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo -e "${GREEN}Verifying Docker installation...${NC}"
if command -v docker &> /dev/null; then
    echo -e "${GREEN}Docker installed successfully!${NC}"
    docker --version
else
    echo -e "${RED}Docker installation failed.${NC}"
    exit 1
fi

echo -e "${GREEN}Adding the current user to the docker group...${NC}"
sudo usermod -aG docker "$USER"

echo -e "${GREEN}Installation complete. Log out and back in to use Docker without sudo.${NC}"

