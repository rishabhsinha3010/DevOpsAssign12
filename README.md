# DevOps Assignment - Django PostgreSQL Application

**Author:** ITA737  
**Course:** DevOps Assignment  
**Components:** Terraform + Ansible + Docker Swarm + Django + PostgreSQL + CI/CD

## 🎯 Project Overview

This project implements a complete DevOps pipeline for deploying a Django-PostgreSQL web application on AWS using Infrastructure as Code (Terraform), Configuration Management (Ansible), and Container Orchestration (Docker Swarm).

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Controller    │    │ Swarm Manager   │    │ Swarm Worker A  │
│                 │    │                 │    │                 │
│ • Terraform     │    │ • Docker Swarm  │    │ • Web Replica 1 │
│ • Ansible       │    │ • Web Replica 1 │    │ • Database      │
│ • CI/CD Runner  │    │ • Database      │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                               ┌─────────────────┐
                                               │ Swarm Worker B  │
                                               │                 │
                                               │ • Web Replica 2 │
                                               │                 │
                                               └─────────────────┘
```

## 📁 Project Structure

```
Devopsassignment/
├── auth_app/                 # Django authentication app
│   ├── models.py            # Login model
│   ├── views.py             # Login/register/home/logout views
│   └── templates/           # HTML templates
├── mysite/                  # Django project settings
├── docker/                  # Docker configuration
│   ├── Dockerfile.web       # Django web container
│   ├── Dockerfile.db        # PostgreSQL container
│   └── docker-compose.yml   # Swarm stack definition
├── terraform/               # Infrastructure as Code
│   └── main.tf             # AWS resources definition
├── ansible/                 # Configuration Management
│   ├── inventory.ini        # Server inventory
│   ├── playbook.yml        # Main playbook
│   ├── install-docker.yml  # Docker installation
│   ├── setup-swarm.yml     # Swarm cluster setup
│   └── deploy-app.yml      # Application deployment
├── ci/                      # CI/CD pipelines
│   ├── .github/workflows/   # GitHub Actions
│   └── Jenkinsfile         # Jenkins pipeline
├── selenium/                # Automated testing
│   ├── test_app.py         # Selenium test suite
│   └── requirements.txt    # Test dependencies
├── scripts/                 # Automation scripts
│   ├── deploy.sh           # Main deployment script
│   ├── test_local.sh       # Local testing
│   └── setup_aws.sh        # AWS setup instructions
└── requirements.txt         # Python dependencies
```

## 🚀 Quick Start

### Prerequisites

- Python 3.11+
- Docker & Docker Compose
- Ansible
- AWS CLI configured
- Terraform (optional)

### Local Development

1. **Clone the repository:**
   ```bash
   git clone https://github.com/rishabhsinha3010/Devopsassignment.git
   cd Devopsassignment
   git checkout ITA768
   ```

2. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run Django locally:**
   ```bash
   python manage.py migrate
   python manage.py runserver
   ```

4. **Test with Docker Swarm:**
   ```bash
   chmod +x scripts/deploy.sh
   ./scripts/deploy.sh
   ```

### AWS Deployment

1. **Create AWS instances manually** (see `scripts/setup_aws.sh`)

2. **Update inventory file:**
   ```bash
   # Edit ansible/inventory.ini with your instance IPs
   ```

3. **Deploy to AWS:**
   ```bash
   ./scripts/deploy.sh
   ```

## 🧪 Testing

### Django Tests
```bash
python manage.py test
```

### Selenium Tests
```bash
pip install selenium
python selenium/test_app.py
```

### Local Docker Swarm Test
```bash
./scripts/test_local.sh
```

## 🔧 Configuration

### Django App
- **Database:** PostgreSQL with `login` table
- **Authentication:** Custom login system
- **Users:** ITA737 / 2022PE0000 (example)

### Docker Swarm
- **Web Replicas:** 2
- **Network:** Overlay network
- **Port:** 8000

### AWS Infrastructure
- **Instances:** 4x t2.micro (free tier)
- **Region:** us-east-1
- **OS:** Ubuntu 20.04 LTS





## 🔍 Monitoring & Management

### Check Services
```bash
# On Swarm Manager
docker stack ps myapp
docker service logs myapp_web
```

### Scale Services
```bash
docker service scale myapp_web=3
```

### Access Application
- **URL:** http://[SwarmManagerIP]:8000
- **Test User:** ITA737 / 2022PE0000

## 🐛 Troubleshooting

### Common Issues

1. **Terraform fails to create instances:**
   - Use manual AWS setup (see `scripts/setup_aws.sh`)
   - Check AWS credentials and limits

2. **Ansible connection fails:**
   - Verify SSH key permissions: `chmod 600 terraform/terraform-key.pem`
   - Check security group allows SSH (port 22)

3. **Docker Swarm issues:**
   - Ensure all required ports are open (2377, 7946, 4789)
   - Check firewall settings

## 📝 Notes

- All code is production-ready and follows DevOps best practices
- Comprehensive error handling and logging
- Automated testing and validation
- Scalable and maintainable architecture

## 👨‍💻 Author

**ITA737** - DevOps Assignment Submission

---

*This project demonstrates a complete DevOps pipeline using modern tools and practices for automated deployment and management of containerized applications.*
