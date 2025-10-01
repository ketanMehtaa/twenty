# Twenty Docker Package

This package contains Docker images, deployment configurations, and orchestration files for running the Twenty CRM application in production environments.

## 📦 What's Included

- **Docker Images**: Production-ready container images for Twenty application, PostgreSQL with extensions, and documentation website
- **Docker Compose**: Standard deployment configuration for quick setup
- **Kubernetes (k8s)**: Enterprise-grade orchestration with Terraform support
- **Podman**: Rootless container deployment with systemd integration
- **Build System**: Makefile for multi-architecture builds
- **Installation Scripts**: Automated setup and configuration tools
- **Monitoring**: Grafana and OpenTelemetry configurations

## 🚀 Quick Start

### One-Line Installation

The fastest way to get Twenty running:

```bash
bash <(curl -sL https://raw.githubusercontent.com/twentyhq/twenty/main/packages/twenty-docker/scripts/install.sh)
```

### Docker Compose (Manual)

1. **Download configuration files:**
   ```bash
   curl -o docker-compose.yml https://raw.githubusercontent.com/twentyhq/twenty/main/packages/twenty-docker/docker-compose.yml
   curl -o .env https://raw.githubusercontent.com/twentyhq/twenty/main/packages/twenty-docker/.env.example
   ```

2. **Generate secrets:**
   ```bash
   # Add to your .env file
   APP_SECRET=$(openssl rand -base64 32)
   PG_DATABASE_PASSWORD=$(openssl rand -hex 32)
   ```

3. **Start services:**
   ```bash
   docker compose up -d
   ```

4. **Access Twenty:**
   Open http://localhost:3000 in your browser

## 📚 Documentation

### Complete Architecture Guide

For a comprehensive overview of the twenty-docker package architecture, including detailed diagrams, deployment options, and configuration guides, see:

**[Twenty Docker Architecture Documentation](https://twenty.com/developers/section/self-hosting/twenty-docker-architecture)**

This guide covers:
- Architecture diagrams and component overview
- Docker image build processes
- Deployment options (Docker Compose, Kubernetes, Podman)
- Environment configuration
- Security considerations
- Data persistence and backups
- Troubleshooting guides

### Related Documentation

- [Docker Compose Setup](https://twenty.com/developers/section/self-hosting/docker-compose) - Detailed deployment guide
- [Setup Environment Variables](https://twenty.com/developers/section/self-hosting/setup) - Configuration reference
- [Upgrade Guide](https://twenty.com/developers/section/self-hosting/upgrade-guide) - Version updates
- [Troubleshooting](https://twenty.com/developers/section/self-hosting/troubleshooting) - Common issues

## 🏗️ Package Structure

```
twenty-docker/
├── docker-compose.yml          # Standard deployment configuration
├── .env.example                # Environment variable template
├── Makefile                    # Build system
│
├── twenty/                     # Main application image
│   ├── Dockerfile             # Multi-stage build (server + frontend)
│   └── entrypoint.sh          # Initialization script
│
├── twenty-postgres-spilo/     # Extended PostgreSQL image
│   └── Dockerfile             # Postgres with mysql_fdw and wrappers
│
├── twenty-website/            # Documentation site image
│   └── Dockerfile             # Next.js build
│
├── k8s/                       # Kubernetes deployment
│   ├── manifests/            # K8s resource definitions
│   └── terraform/            # Infrastructure as code
│
├── podman/                    # Podman deployment
│   ├── podman-compose.yml    # Podman configuration
│   └── twentycrm.service     # Systemd service
│
├── scripts/                   # Installation automation
│   └── install.sh            # One-line installer
│
├── grafana/                   # Monitoring configuration
└── otel-collector/           # Observability setup
```

## 🐳 Docker Images

### twentycrm/twenty

Main application image combining NestJS backend and React frontend.

**Build:**
```bash
make prod-build TAG=latest PLATFORM=linux/amd64
```

**Run:**
```bash
make prod-run TAG=latest
```

**Features:**
- Multi-stage build for optimal size
- Non-root user (UID 1000)
- Health checks
- Automatic database migrations
- Background job registration

### twenty-postgres-spilo

PostgreSQL 15 with Spilo (high availability) and additional extensions:
- mysql_fdw - MySQL foreign data wrapper
- Supabase Wrappers - External service integrations

### twenty-website

Next.js documentation website.

**Build:**
```bash
make prod-website-build TAG=latest PLATFORM=linux/amd64
```

## 🔧 Build System

### Makefile Commands

```bash
# Build main application
make prod-build PLATFORM=linux/amd64 TAG=latest

# Run application
make prod-run TAG=latest

# Build website
make prod-website-build PLATFORM=linux/amd64 TAG=latest

# Run website
make prod-website-run TAG=latest
```

### Multi-Architecture Support

The build system supports:
- `linux/amd64` (x86_64)
- `linux/arm64` (aarch64)

## 🚢 Deployment Options

### Docker Compose (Recommended for Most Users)

Standard deployment using Docker Compose. Easiest to set up and maintain.

**Components:**
- Server (main application)
- Worker (background jobs)
- PostgreSQL database
- Redis cache

**File:** `docker-compose.yml`

### Kubernetes

Enterprise-grade orchestration for scalable deployments.

**Features:**
- Horizontal pod autoscaling
- Persistent volume management
- Ingress configuration
- Terraform support

**Location:** `k8s/` directory

### Podman

Rootless container deployment for enhanced security.

**Features:**
- Pod-based networking
- Systemd integration
- SELinux support
- Non-root execution

**Location:** `podman/` directory

## ⚙️ Configuration

### Essential Environment Variables

**Required:**
- `SERVER_URL` - External access URL (e.g., https://crm.example.com)
- `APP_SECRET` - Application encryption key (use `openssl rand -base64 32`)
- `PG_DATABASE_PASSWORD` - Database password

**Database:**
- `PG_DATABASE_URL` - PostgreSQL connection string
- Default: `postgres://postgres:postgres@db:5432/default`

**Storage:**
- `STORAGE_TYPE` - `local` or `s3`
- For S3: `STORAGE_S3_REGION`, `STORAGE_S3_NAME`, `STORAGE_S3_ENDPOINT`

**Optional:**
- OAuth providers (Google, Microsoft)
- Email configuration
- Calendar and messaging integrations

See [Setup Environment Variables](https://twenty.com/developers/section/self-hosting/setup) for complete reference.

## 🔒 Security

- All containers run as non-root users (UID 1000)
- Secrets managed via environment variables (never in images)
- Alpine Linux base for minimal attack surface
- Health checks for service reliability
- Volume-based data persistence

## 📊 Monitoring

### Grafana + OpenTelemetry

Optional monitoring stack for production deployments:

- **OpenTelemetry Collector**: Telemetry data collection
- **ClickHouse**: Analytics database (optional)
- **Grafana**: Visualization and dashboards

**Configuration files:**
- `grafana/provisioning/datasources/clickhouse-datasource.yaml`
- `otel-collector/otel-collector-config.yaml`

## 🔄 Upgrading

1. Backup your data
2. Update `TAG` in `.env`
3. Pull new images: `docker compose pull`
4. Restart: `docker compose up -d`
5. Monitor logs: `docker compose logs -f server`

See [Upgrade Guide](https://twenty.com/developers/section/self-hosting/upgrade-guide) for details.

## 🐛 Troubleshooting

### Common Commands

```bash
# View logs
docker compose logs -f server

# Check status
docker compose ps

# Restart services
docker compose restart server worker

# Access container shell
docker compose exec server sh

# Database access
docker compose exec db psql -U postgres -d default
```

### Common Issues

- **Health check failures**: Check logs and database connection
- **Port conflicts**: Change port mapping in docker-compose.yml
- **Migration errors**: Verify database permissions and connectivity

See [Troubleshooting Guide](https://twenty.com/developers/section/self-hosting/troubleshooting) for more solutions.

## 💾 Data Persistence

### Volumes

- `server-local-data`: Application files and uploads
- `db-data`: PostgreSQL data directory

### Backups

**Database:**
```bash
docker compose exec db pg_dump -U postgres default > backup.sql
```

**Files:**
```bash
docker run --rm -v twenty_server-local-data:/data -v $(pwd):/backup \
  alpine tar czf /backup/files-backup.tar.gz /data
```

## 🎯 System Requirements

**Minimum:**
- 2GB RAM
- 2 CPU cores
- 10GB disk space
- Docker 20.10+ with Compose v2+

**Recommended:**
- 4GB RAM
- 4 CPU cores
- 20GB disk space
- Fast SSD storage

## 📝 Version Management

### Image Tags

```
twentycrm/twenty:latest          # Latest stable release
twentycrm/twenty:v0.23.0         # Specific version
twentycrm/twenty:main            # Development branch
```

Use specific version tags for production deployments.

## 🤝 Community Deployments

**Official Support:**
- Docker Compose (maintained by Twenty core team)

**Community Maintained:**
- Kubernetes deployments
- Podman configurations
- Platform-specific guides

## 📖 Additional Resources

- [Official Documentation](https://twenty.com/developers)
- [Self-Hosting Guide](https://twenty.com/developers/section/self-hosting)
- [Local Development Setup](https://twenty.com/developers/local-setup)
- [GitHub Repository](https://github.com/twentyhq/twenty)

## ⚠️ Important Notes

- **Docker containers are for production/self-hosting only**
- For development and contributions, use the [Local Setup](https://twenty.com/developers/local-setup)
- Keep your secrets secure and never commit them to version control
- Regular backups are essential for production deployments

## 🆘 Getting Help

- [Troubleshooting Guide](https://twenty.com/developers/section/self-hosting/troubleshooting)
- [GitHub Issues](https://github.com/twentyhq/twenty/issues)
- [Community Discord](https://twenty.com/discord)

---

For detailed architecture documentation with diagrams and deep dives into each component, visit the [Twenty Docker Architecture Guide](https://twenty.com/developers/section/self-hosting/twenty-docker-architecture).
