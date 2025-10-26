#!/bin/bash

# AWS Setup Script for DevOps Assignment
# Creates EC2 instances manually when Terraform fails

echo "☁️  AWS Manual Setup for DevOps Assignment"
echo "=========================================="

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[AWS]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_status "Manual AWS Setup Instructions"
echo ""
echo "Since Terraform is having issues, please create instances manually:"
echo ""
echo "1. Go to AWS Console → EC2 → Launch Instance"
echo "2. Use Ubuntu Server 20.04 LTS (ami-0fb0b230890ccd1e6)"
echo "3. Instance Type: t2.micro (free tier)"
echo "4. Create 4 instances with these names:"
echo "   - Controller"
echo "   - SwarmManager" 
echo "   - SwarmWorkerA"
echo "   - SwarmWorkerB"
echo ""
echo "5. Security Group Rules:"
echo "   - SSH (22) - Anywhere"
echo "   - HTTP (80) - Anywhere"
echo "   - HTTPS (443) - Anywhere"
echo "   - Custom TCP (2377) - Anywhere (Docker Swarm manager)"
echo "   - Custom TCP (7946) - Anywhere (Swarm gossip)"
echo "   - Custom UDP (7946) - Anywhere (Swarm gossip)"
echo "   - Custom UDP (4789) - Anywhere (Overlay network)"
echo ""
echo "6. Create Elastic IPs and associate them to each instance"
echo "7. Update ansible/inventory.ini with the public IPs"
echo "8. Run: ./scripts/deploy.sh"
echo ""
print_warning "After creating instances, update the inventory file and run deployment!"
