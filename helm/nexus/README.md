# Nexus Repository Manager Helm Chart for AWS EKS

This Helm chart deploys Sonatype Nexus Repository Manager on AWS EKS using AWS Application Load Balancer (ALB) for ingress and Aurora PostgreSQL for database storage.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- AWS EKS cluster
- AWS Load Balancer Controller installed on the cluster
- Aurora PostgreSQL database instance
- AWS Secrets Manager with database credentials

## Features

- Deploys Sonatype Nexus Repository Manager
- Uses AWS Aurora PostgreSQL for database storage
- Uses AWS Application Load Balancer (ALB) for ingress
- Configurable resource limits and requests
- Persistent storage for Nexus data
- Docker registry support

## Installation

### 1. Create Aurora PostgreSQL Database

Create an Aurora PostgreSQL database using AWS RDS:

```bash
# Example using AWS CLI
aws rds create-db-cluster \
  --db-cluster-identifier nexus-db \
  --engine aurora-postgresql \
  --engine-version 15.3 \
  --master-username nexus \
  --master-user-password <secure-password> \
  --db-subnet-group-name <your-subnet-group> \
  --vpc-security-group-ids <your-security-group-id>

# Create an instance in the cluster
aws rds create-db-instance \
  --db-instance-identifier nexus-db-instance \
  --db-cluster-identifier nexus-db \
  --engine aurora-postgresql \
  --db-instance-class db.r5.large
```

### 2. Create Database Secret

Create a Kubernetes secret with the database credentials:

```bash
kubectl create secret generic nexus-db-credentials \
  --from-literal=host=<AURORA_ENDPOINT> \
  --from-literal=username=nexus \
  --from-literal=password=<secure-password>
```

### 3. Install the Chart

```bash
helm install nexus ./helm/nexus \
  --set ingress.annotations.alb\\.ingress\\.kubernetes\\.io/certificate-arn=<your-acm-cert-arn> \
  --set ingress.hosts[0].host=nexus.example.com \
  --set dockerRegistry.ingress.hosts[0].host=docker.nexus.example.com
```

## Configuration

The following table lists the configurable parameters of the Nexus chart and their default values.

| Parameter                                | Description                                      | Default                            |
| ---------------------------------------- | ------------------------------------------------ | ---------------------------------- |
| `nexus.image.repository`                 | Nexus image repository                           | `sonatype/nexus3`                  |
| `nexus.image.tag`                        | Nexus image tag                                  | `latest`                           |
| `nexus.resources.requests.memory`        | Memory request for Nexus                         | `2Gi`                              |
| `nexus.resources.requests.cpu`           | CPU request for Nexus                            | `1`                                |
| `nexus.resources.limits.memory`          | Memory limit for Nexus                           | `4Gi`                              |
| `nexus.resources.limits.cpu`             | CPU limit for Nexus                              | `2`                                |
| `nexus.adminPassword`                    | Initial admin password                           | `passw0rd`                         |
| `nexus.persistence.enabled`              | Enable persistence for Nexus data                | `true`                             |
| `nexus.persistence.storageClass`         | Storage class for PVC                            | `gp2`                              |
| `nexus.persistence.size`                 | Size of PVC                                      | `100Gi`                            |
| `database.aurora.instanceClass`          | Aurora instance class                            | `db.r5.large`                      |
| `database.aurora.dbName`                 | Database name                                    | `nexus`                            |
| `database.aurora.username`               | Database username                                | `nexus`                            |
| `database.aurora.existingSecret`         | Secret containing database credentials           | `nexus-db-credentials`             |
| `ingress.enabled`                        | Enable ingress                                   | `true`                             |
| `ingress.annotations`                    | Ingress annotations                              | ALB annotations                    |
| `ingress.hosts[0].host`                  | Hostname for Nexus                               | `nexus.example.com`                |
| `dockerRegistry.enabled`                 | Enable Docker registry                           | `true`                             |
| `dockerRegistry.port`                    | Docker registry port                             | `8082`                             |

## Uninstallation

```bash
helm uninstall nexus
```

## Notes

- The Aurora PostgreSQL database is not managed by this Helm chart and must be created separately.
- Make sure your EKS cluster has the necessary IAM roles for ALB controller and RDS access.
- For production use, configure proper backup and disaster recovery for both Nexus data and Aurora database.