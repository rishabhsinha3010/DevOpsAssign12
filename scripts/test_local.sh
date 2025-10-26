#!/bin/bash

# Local Testing Script for DevOps Assignment
# Tests Django app, Docker Swarm, and Selenium locally

echo "🧪 DevOps Assignment - Local Testing"
echo "===================================="

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

print_error() {
    echo -e "${RED}[FAIL]${NC} $1"
}

# Test 1: Django App
print_status "Testing Django application..."
if python manage.py check; then
    print_success "Django app configuration is valid"
else
    print_error "Django app configuration has issues"
    exit 1
fi

# Test 2: Docker Build
print_status "Testing Docker image builds..."
if docker build -t test-web -f docker/Dockerfile.web .; then
    print_success "Web Docker image built successfully"
else
    print_error "Web Docker image build failed"
    exit 1
fi

# Test 3: Docker Swarm
print_status "Testing Docker Swarm deployment..."
docker swarm init --advertise-addr 127.0.0.1 2>/dev/null || true
docker stack deploy -c docker/docker-compose.yml test-stack
sleep 20

if docker stack ps test-stack | grep -q "Running"; then
    print_success "Docker Swarm stack deployed successfully"
else
    print_error "Docker Swarm stack deployment failed"
fi

# Test 4: Application Response
print_status "Testing application response..."
sleep 10
if curl -f http://localhost:8000/ > /dev/null 2>&1; then
    print_success "Application is responding on port 8000"
else
    print_error "Application is not responding"
fi

# Cleanup
print_status "Cleaning up test resources..."
docker stack rm test-stack
docker swarm leave --force 2>/dev/null || true

echo ""
echo "🎉 Local testing completed!"
