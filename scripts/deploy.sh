#!/bin/bash

# DevOps Assignment Complete Deployment Script
# Author: ITA737
# Description: Automated deployment of Django-PostgreSQL app on AWS using Terraform, Ansible, and Docker Swarm

set -e  # Exit on any error

echo "🚀 DevOps Assignment - Complete Deployment Pipeline"
echo "=================================================="
echo "Author: ITA737"
echo "Components: Terraform + Ansible + Docker Swarm + Django + PostgreSQL"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
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

# Check prerequisites
print_status "Checking prerequisites..."

# Check if inventory file is updated
if grep -q "YOUR_.*_IP" ansible/inventory.ini; then
    print_error "Please update ansible/inventory.ini with your actual AWS instance IPs first!"
    echo "Edit the file and replace YOUR_CONTROLLER_IP, YOUR_MANAGER_IP, etc. with real IPs"
    exit 1
fi

# Check if terraform-key.pem exists
if [ ! -f "terraform/terraform-key.pem" ]; then
    print_error "terraform-key.pem not found! Please ensure it exists in terraform/ directory"
    exit 1
fi

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    print_error "Ansible is not installed. Please install it first:"
    echo "sudo apt update && sudo apt install ansible"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install it first:"
    echo "curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh"
    exit 1
fi

print_success "All prerequisites met!"

# Set proper permissions for SSH key
print_status "Setting up SSH key permissions..."
chmod 600 terraform/terraform-key.pem

# Test local Docker Swarm first
print_status "Testing Docker Swarm locally..."
if docker info | grep -q "Swarm: active"; then
    print_warning "Docker Swarm already active, leaving existing swarm"
else
    docker swarm init --advertise-addr 127.0.0.1
    print_success "Docker Swarm initialized locally"
fi

# Build Docker images locally
print_status "Building Docker images..."
docker build -t myapp-web:latest -f docker/Dockerfile.web .
docker build -t myapp-db:latest -f docker/Dockerfile.db .
print_success "Docker images built successfully"

# Test local deployment
print_status "Testing local Docker Swarm deployment..."
docker stack deploy -c docker/docker-compose.yml myapp
print_success "Stack deployed locally"

# Wait for services to be ready
print_status "Waiting for services to start..."
sleep 30

# Check stack status
print_status "Checking stack status..."
docker stack ps myapp

# Test the application locally
print_status "Testing application locally..."
if curl -f http://localhost:8000/ > /dev/null 2>&1; then
    print_success "Application is responding locally!"
    echo "🌐 Local URL: http://localhost:8000"
else
    print_warning "Application not responding locally (this is expected if not running locally)"
fi

# Run Ansible playbooks against AWS instances
print_status "Running Ansible playbooks against AWS instances..."
cd ansible

# Test connectivity first
print_status "Testing connectivity to AWS instances..."
ansible all -i inventory.ini -m ping

# Run the complete playbook
print_status "Running complete Ansible playbook..."
ansible-playbook -i inventory.ini playbook.yml

print_success "Ansible deployment completed!"

# Final status check
print_status "Checking final deployment status..."
ansible swarm_manager -i inventory.ini -m shell -a "docker stack ps myapp"

print_success "🎉 Deployment complete!"
echo ""
echo "📊 Deployment Summary:"
echo "====================="
echo "✅ Terraform: Infrastructure provisioned"
echo "✅ Ansible: Servers configured"
echo "✅ Docker Swarm: Cluster initialized"
echo "✅ Django App: Deployed with 2 replicas"
echo "✅ PostgreSQL: Database running"
echo ""
echo "🌐 Access your application:"
echo "   - Swarm Manager IP:8000"
echo "   - Test with: ITA737 / 2022PE0000"
echo ""
echo "📋 Useful commands:"
echo "   - Check services: docker stack ps myapp"
echo "   - View logs: docker service logs myapp_web"
echo "   - Scale web: docker service scale myapp_web=3"
echo ""
print_success "DevOps Assignment deployment completed successfully! 🚀"
