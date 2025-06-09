# Nexus Repository Manager

This project contains configurations for deploying Sonatype Nexus Repository Manager using Docker Compose locally and Helm charts for AWS EKS deployment.

## Local Development with Docker Compose

The Docker Compose setup includes:
- Nexus Repository Manager
- PostgreSQL database
- Nginx as reverse proxy

### Prerequisites
- Docker and Docker Compose

### Usage
```bash
# Start the services
docker-compose up -d

# Access Nexus UI
# http://localhost:80

# Default credentials
# Username: admin
# Password: passw0rd
```

## AWS EKS Deployment with Helm

The Helm chart deploys Nexus to AWS EKS with:
- AWS Application Load Balancer (ALB) instead of Nginx
- Aurora PostgreSQL instead of standard PostgreSQL
- Persistent storage using EBS volumes

### Prerequisites
- AWS EKS cluster
- AWS Load Balancer Controller installed
- Aurora PostgreSQL database
- Helm 3

### Installation
1. Create Aurora PostgreSQL database in AWS
2. Create database credentials secret:
   ```bash
   kubectl create secret generic nexus-db-credentials \
     --from-literal=host=<AURORA_ENDPOINT> \
     --from-literal=username=nexus \
     --from-literal=password=<secure-password>
   ```
3. Install the Helm chart:
   ```bash
   helm install nexus ./helm/nexus \
     --set ingress.annotations.alb\\.ingress\\.kubernetes\\.io/certificate-arn=<your-acm-cert-arn> \
     --set ingress.hosts[0].host=nexus.example.com
   ```

## Configuration

See the following files for configuration details:
- `docker-compose.yml` - Local deployment configuration
- `helm/nexus/values.yaml` - Kubernetes deployment configuration

## License

This project is licensed under the MIT License - see the LICENSE file for details.