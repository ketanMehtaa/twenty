# Twenty Server

## Overview

Twenty Server is the backend API and business logic layer for the Twenty CRM platform. Built with [NestJS](https://nestjs.com/), it provides a robust, scalable GraphQL and REST API foundation for managing customer relationships, workflows, and integrations.

**Key Features:**
- 🚀 **GraphQL-First API** - Dynamic, workspace-aware GraphQL API with metadata-driven schema generation
- 🔌 **REST API** - OpenAPI-compliant REST endpoints for external integrations
- 🗄️ **PostgreSQL + TypeORM** - Robust relational database with type-safe queries
- 🔄 **Background Jobs** - BullMQ-powered job queue for async processing
- 📧 **Multi-Channel Communication** - Email, calendar, and messaging integrations
- 🔐 **Enterprise Authentication** - OAuth, SSO, and 2FA support
- 🏗️ **Metadata-Driven Architecture** - Custom objects and fields without code changes
- 📊 **Analytics & Observability** - OpenTelemetry, Sentry integration

## Table of Contents

- [Architecture](#architecture)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Core Concepts](#core-concepts)
- [API Endpoints](#api-endpoints)
- [Configuration](#configuration)
- [Database](#database)
- [Authentication & Authorization](#authentication--authorization)
- [Background Jobs](#background-jobs)
- [Development](#development)
- [Testing](#testing)
- [Deployment](#deployment)

---

## Architecture

Twenty Server follows a modular, layered architecture built on NestJS principles:

```mermaid
graph TB
    subgraph "Client Layer"
        A[Web Frontend]
        B[Mobile App]
        C[External APIs]
    end
    
    subgraph "API Gateway Layer"
        D[GraphQL API /graphql]
        E[REST API /rest]
        F[Metadata API /metadata]
    end
    
    subgraph "Core Engine Layer"
        G[Core Engine Module]
        H[Workspace Manager]
        I[Authentication]
        J[Authorization]
    end
    
    subgraph "Business Logic Layer"
        K[Modules]
        L[Workflow Engine]
        M[Calendar]
        N[Messaging]
    end
    
    subgraph "Data Layer"
        O[(PostgreSQL)]
        P[(Redis)]
        Q[(ClickHouse)]
    end
    
    subgraph "Background Processing"
        R[Queue Worker]
        S[Job Handlers]
    end
    
    A --> D
    B --> D
    C --> E
    D --> G
    E --> G
    F --> G
    G --> H
    G --> I
    G --> J
    H --> K
    K --> L
    K --> M
    K --> N
    K --> O
    K --> P
    R --> S
    S --> O
    L --> R
    M --> R
    N --> R
    K --> Q
```

### Architecture Highlights

1. **Metadata-Driven Schema**: GraphQL schema is dynamically generated based on workspace metadata, allowing custom objects without code changes.

2. **Multi-Tenant Workspaces**: Each workspace has isolated data and configurable schema.

3. **Layered Modules**:
   - **Core Modules**: Authentication, authorization, file storage, messaging
   - **Engine Modules**: Metadata management, workspace management, schema generation
   - **Business Modules**: Domain-specific logic (CRM entities, workflows, calendar)

4. **Event-Driven**: Workspace events trigger workflows and integrations.

---

## Quick Start

### Prerequisites

- Node.js 24.5.0+
- PostgreSQL 15+
- Redis 7+
- Yarn 4+

### Installation

```bash
# Install dependencies
yarn install

# Set up environment variables
cp .env.example .env
# Edit .env with your configuration

# Initialize database
npx nx database:reset twenty-server

# Start development server
npx nx start twenty-server
```

The server will start on `http://localhost:3000` with the following endpoints:
- GraphQL API: `http://localhost:3000/graphql`
- REST API: `http://localhost:3000/rest`
- Metadata API: `http://localhost:3000/metadata`
- Health Check: `http://localhost:3000/healthz`

---

## Project Structure

```
packages/twenty-server/
├── src/
│   ├── app.module.ts              # Root application module
│   ├── main.ts                     # Application entry point
│   │
│   ├── engine/                     # Core engine components
│   │   ├── core-modules/          # 70+ core service modules
│   │   │   ├── auth/              # Authentication & sessions
│   │   │   ├── user/              # User management
│   │   │   ├── workspace/         # Workspace management
│   │   │   ├── file/              # File upload & storage
│   │   │   ├── messaging/         # Email & messaging
│   │   │   ├── calendar/          # Calendar integration
│   │   │   ├── workflow/          # Workflow engine
│   │   │   └── ...                # Many more modules
│   │   │
│   │   ├── api/                   # API layer
│   │   │   ├── graphql/           # GraphQL APIs (Core & Metadata)
│   │   │   ├── rest/              # REST API
│   │   │   └── mcp/               # MCP protocol support
│   │   │
│   │   ├── workspace-manager/     # Workspace schema & data management
│   │   ├── metadata-modules/      # Metadata system (34 modules)
│   │   ├── twenty-orm/            # Custom ORM layer
│   │   ├── guards/                # Authorization guards
│   │   ├── decorators/            # Custom NestJS decorators
│   │   └── middlewares/           # Request middlewares
│   │
│   ├── modules/                   # Business logic modules
│   │   ├── workflow/              # Workflow automation
│   │   ├── calendar/              # Calendar events
│   │   ├── messaging/             # Email & messaging
│   │   ├── company/               # Company entities
│   │   ├── person/                # Person entities
│   │   └── ...                    # More business modules
│   │
│   ├── database/                  # Database layer
│   │   ├── typeorm/               # TypeORM configuration
│   │   │   ├── core/              # Core database entities
│   │   │   └── metadata/          # Metadata entities
│   │   └── clickHouse/            # ClickHouse (analytics)
│   │
│   ├── queue-worker/              # Background job worker
│   ├── command/                   # CLI commands
│   ├── filters/                   # Exception filters
│   └── utils/                     # Utility functions
│
├── test/                          # Integration tests
├── scripts/                       # Utility scripts
├── .env.example                   # Environment variables template
└── package.json                   # Dependencies & scripts
```

### Key Directories Explained

#### `engine/core-modules/`
Contains 70+ foundational modules for authentication, authorization, file handling, messaging, etc. These are infrastructure-level concerns.

#### `engine/metadata-modules/`
Handles the metadata layer - custom objects, fields, relations. Powers the dynamic schema generation.

#### `engine/workspace-manager/`
Manages workspace-specific schemas, data sources, and query execution. Core of multi-tenancy.

#### `modules/`
Business domain modules with CRM-specific logic (companies, people, opportunities, workflows, etc.).

---

## Core Concepts

### 1. Workspaces

Workspaces are the top-level tenant boundary. Each workspace has:
- Isolated data schema
- Custom objects and fields
- Independent configuration
- Separate user permissions

```typescript
// Workspace is the root entity
Workspace {
  id: string
  name: string
  subdomain: string
  members: WorkspaceMember[]
  customObjects: ObjectMetadata[]
}
```

### 2. Metadata System

The metadata system enables runtime schema customization:

```mermaid
graph LR
    A[ObjectMetadata] --> B[FieldMetadata]
    A --> C[RelationMetadata]
    B --> D[GraphQL Schema]
    C --> D
    D --> E[TypeORM Entities]
    E --> F[Database Tables]
```

**Object Metadata**: Defines custom objects (like "Property" or "Deal")
**Field Metadata**: Defines fields on objects (data type, validation)
**Relation Metadata**: Defines relationships between objects

### 3. Twenty ORM

Custom ORM layer built on TypeORM:
- Repository pattern for each workspace object
- Type-safe queries with metadata awareness
- Automatic query optimization

```typescript
// Example: Query companies using Twenty ORM
const companyRepository = workspaceDataSource.getRepository('company');
const companies = await companyRepository.find({
  where: { industry: 'Technology' },
  relations: ['contacts', 'opportunities']
});
```

### 4. GraphQL Architecture

Two separate GraphQL APIs:

**Core API** (`/graphql`):
- Dynamic schema based on workspace metadata
- CRUD operations for all objects
- Custom queries and mutations

**Metadata API** (`/metadata`):
- Manages object and field definitions
- Schema modifications
- Workspace configuration

### 5. Background Jobs

BullMQ-powered job queue for async operations:
- Email sending
- Calendar sync
- Workflow execution
- Data imports/exports

```typescript
// Job definition
@Processor('messaging')
export class MessagingProcessor {
  @Process('send-email')
  async handleSendEmail(job: Job<EmailData>) {
    // Process email sending
  }
}
```

---

## API Endpoints

### GraphQL API

#### Core API - `/graphql`
Dynamic GraphQL API for workspace data operations.

**Example Query:**
```graphql
query GetCompanies {
  companies(filter: { industry: { eq: "Technology" } }) {
    edges {
      node {
        id
        name
        industry
        employees
        contacts {
          edges {
            node {
              name
              email
            }
          }
        }
      }
    }
  }
}
```

**Example Mutation:**
```graphql
mutation CreateCompany($input: CompanyCreateInput!) {
  createCompany(data: $input) {
    id
    name
    createdAt
  }
}
```

#### Metadata API - `/metadata`
Manages object and field definitions.

**Example: Create Custom Object**
```graphql
mutation CreateObject {
  createOneObject(
    data: {
      nameSingular: "property"
      namePlural: "properties"
      labelSingular: "Property"
      labelPlural: "Properties"
      icon: "IconBuilding"
    }
  ) {
    id
    nameSingular
  }
}
```

### REST API

OpenAPI-compliant REST endpoints at `/rest`.

**Base URL:** `http://localhost:3000/rest`

**Authentication:** Bearer token in `Authorization` header

**Example Endpoints:**
```bash
# List companies
GET /rest/companies?limit=20&filter[createdAt][gt]=2024-01-01

# Get single company
GET /rest/companies/{id}

# Create company
POST /rest/companies
Content-Type: application/json
{
  "name": "Acme Corp",
  "industry": "Technology"
}

# Update company
PATCH /rest/companies/{id}
Content-Type: application/json
{
  "employees": 500
}

# Delete company
DELETE /rest/companies/{id}
```

**OpenAPI Schema:** Available at `/rest/open-api/core`

### Health Check

**Endpoint:** `GET /healthz`

Returns health status of database and critical services:
```json
{
  "status": "ok",
  "info": {
    "database": { "status": "up" },
    "redis": { "status": "up" }
  }
}
```

---

## Configuration

### Environment Variables

Configuration is managed through environment variables. See `.env.example` for full list.

#### Essential Variables

```bash
# Database
PG_DATABASE_URL=postgres://user:password@localhost:5432/twenty

# Redis
REDIS_URL=redis://localhost:6379

# Security
APP_SECRET=your-secret-key-here

# Server
NODE_PORT=3000
FRONTEND_URL=http://localhost:3001
SERVER_URL=http://localhost:3000

# Authentication
ACCESS_TOKEN_EXPIRES_IN=30m
REFRESH_TOKEN_EXPIRES_IN=90d
```

#### Feature Flags

```bash
# Enable/disable features
MESSAGING_PROVIDER_GMAIL_ENABLED=true
CALENDAR_PROVIDER_GOOGLE_ENABLED=true
IS_BILLING_ENABLED=false
IS_MULTIWORKSPACE_ENABLED=true
AUTH_GOOGLE_ENABLED=true
```

#### Storage Configuration

```bash
# Storage type: 'local', 's3', or 'gcp'
STORAGE_TYPE=local
STORAGE_LOCAL_PATH=.local-storage

# S3 Configuration
STORAGE_S3_BUCKET_NAME=twenty-storage
STORAGE_S3_REGION=us-east-1
```

#### Email Configuration

```bash
EMAIL_DRIVER=smtp
EMAIL_SMTP_HOST=smtp.gmail.com
EMAIL_SMTP_PORT=587
EMAIL_SMTP_USER=your-email@gmail.com
EMAIL_SMTP_PASSWORD=your-app-password
EMAIL_FROM_ADDRESS=no-reply@yourdomain.com
```

### Configuration Service

Access configuration programmatically:

```typescript
import { TwentyConfigService } from 'src/engine/core-modules/twenty-config/twenty-config.service';

@Injectable()
export class MyService {
  constructor(private twentyConfig: TwentyConfigService) {}

  getConfig() {
    const port = this.twentyConfig.get('NODE_PORT');
    const dbUrl = this.twentyConfig.get('PG_DATABASE_URL');
  }
}
```

---

## Database

### PostgreSQL Schema

Twenty uses PostgreSQL with two schema layers:

1. **Core Schema** (`core.*`): System tables for workspaces, users, metadata
2. **Workspace Schemas** (`workspace_*`): Dynamic tables for each workspace's data

```mermaid
erDiagram
    WORKSPACE ||--o{ WORKSPACE_MEMBER : has
    WORKSPACE ||--o{ OBJECT_METADATA : defines
    WORKSPACE_MEMBER }o--|| USER : belongs_to
    OBJECT_METADATA ||--o{ FIELD_METADATA : contains
    OBJECT_METADATA ||--o{ RELATION_METADATA : has
    
    WORKSPACE {
        uuid id PK
        string name
        string subdomain
        timestamp createdAt
    }
    
    USER {
        uuid id PK
        string email UK
        string firstName
        string lastName
    }
    
    WORKSPACE_MEMBER {
        uuid id PK
        uuid workspaceId FK
        uuid userId FK
        string role
    }
    
    OBJECT_METADATA {
        uuid id PK
        uuid workspaceId FK
        string nameSingular
        string namePlural
        string labelSingular
        boolean isActive
    }
    
    FIELD_METADATA {
        uuid id PK
        uuid objectMetadataId FK
        string name
        string type
        json options
    }
```

### Migrations

TypeORM migrations manage schema changes:

```bash
# Generate migration
npx nx run twenty-server:typeorm migration:generate \
  src/database/typeorm/core/migrations/AddNewField \
  -d src/database/typeorm/core/core.datasource.ts

# Run migrations (production)
yarn database:migrate:prod

# Reset database (development)
npx nx database:reset twenty-server
```

### Database Commands

```bash
# Initialize database
npx nx run twenty-server:database:init:prod

# Sync metadata (updates workspace schemas)
npx nx run twenty-server:command workspace:sync-metadata -f

# Reset database (WARNING: deletes all data)
npx nx database:reset twenty-server
```

### ClickHouse (Analytics)

Optional ClickHouse integration for analytics:

```bash
# Enable in .env
CLICKHOUSE_URL=http://default:password@localhost:8123/twenty
ANALYTICS_ENABLED=true

# Run migrations
yarn clickhouse:migrate:prod
```

---

## Authentication & Authorization

### Authentication Flow

```mermaid
sequenceDiagram
    participant Client
    participant API
    participant Auth
    participant Database
    
    Client->>API: POST /auth/login
    API->>Auth: Verify credentials
    Auth->>Database: Lookup user
    Database-->>Auth: User data
    Auth-->>API: Generate tokens
    API-->>Client: Access + Refresh tokens
    
    Client->>API: Request with Access Token
    API->>Auth: Validate token
    Auth-->>API: User context
    API->>Database: Execute query
    Database-->>API: Results
    API-->>Client: Response
```

### Authentication Methods

1. **Email/Password**
   ```bash
   POST /auth/login
   {
     "email": "user@example.com",
     "password": "secret"
   }
   ```

2. **OAuth (Google, Microsoft)**
   ```bash
   GET /auth/google
   # Redirects to Google OAuth
   ```

3. **SSO (SAML)**
   ```bash
   POST /auth/saml/login
   ```

4. **API Keys**
   ```bash
   # Create API key in workspace settings
   GET /graphql
   Authorization: Bearer <api-key>
   ```

### Authorization

Role-based access control (RBAC) with workspace-level permissions:

**Roles:**
- `OWNER`: Full workspace access
- `ADMIN`: Administrative access
- `MEMBER`: Standard user access
- `GUEST`: Read-only access

**Guards:**
```typescript
// Workspace guard - ensures user has workspace access
@UseGuards(WorkspaceGuard)

// Permission guard - checks specific permissions
@UseGuards(PermissionGuard)
@Permission('companies.read')
```

### Two-Factor Authentication (2FA)

Enable 2FA for enhanced security:
```bash
# In .env
TWO_FACTOR_AUTHENTICATION_ENABLED=true
```

---

## Background Jobs

### Job Queue Architecture

```mermaid
graph LR
    A[API Request] -->|Enqueue| B[Redis Queue]
    B --> C[Queue Worker]
    C --> D{Job Type}
    D -->|Email| E[Email Handler]
    D -->|Calendar| F[Calendar Handler]
    D -->|Workflow| G[Workflow Handler]
    E --> H[External Service]
    F --> H
    G --> I[Database]
```

### Common Job Types

1. **Messaging Jobs**
   - `send-email`: Send transactional emails
   - `sync-messages`: Sync email messages
   - `process-thread`: Process message threads

2. **Calendar Jobs**
   - `sync-calendar`: Sync calendar events
   - `create-event`: Create calendar events
   - `send-reminders`: Event reminders

3. **Workflow Jobs**
   - `execute-workflow`: Run workflow automation
   - `process-trigger`: Handle workflow triggers

### Starting the Worker

```bash
# Development
npx nx run twenty-server:worker

# Production
yarn worker:prod
```

### Creating Custom Jobs

```typescript
// Define job processor
@Processor('my-queue')
export class MyJobProcessor {
  @Process('my-job')
  async handleMyJob(job: Job<MyJobData>) {
    const { data } = job;
    // Process job
    await this.doWork(data);
  }
}

// Enqueue job
@Injectable()
export class MyService {
  constructor(
    @InjectQueue('my-queue') private queue: Queue
  ) {}

  async scheduleJob(data: MyJobData) {
    await this.queue.add('my-job', data);
  }
}
```

---

## Development

### Available Commands

```bash
# Start development server
npx nx start twenty-server

# Start with hot reload
npx nx start twenty-server --watch

# Start worker
npx nx run twenty-server:worker

# Run tests
npx nx test twenty-server

# Run integration tests
npx nx run twenty-server:test:integration:with-db-reset

# Lint code
npx nx lint twenty-server

# Fix lint issues
npx nx lint twenty-server --fix

# Type checking
npx nx typecheck twenty-server

# Build for production
npx nx build twenty-server

# Generate GraphQL types
npx nx run twenty-front:graphql:generate
```

### Development Workflow

1. **Make Changes**: Edit files in `src/`
2. **Lint**: Run linter to check code style
3. **Type Check**: Ensure TypeScript types are correct
4. **Test**: Write and run tests
5. **Commit**: Commit changes with descriptive message

### Debugging

#### VS Code Debug Configuration

```json
{
  "type": "node",
  "request": "launch",
  "name": "Debug Twenty Server",
  "runtimeExecutable": "npx",
  "runtimeArgs": ["nx", "start", "twenty-server"],
  "console": "integratedTerminal"
}
```

#### Enable Debug Logging

```bash
# In .env
LOG_LEVELS=error,warn,log,debug
LOGGER_DRIVER=console
```

---

## Testing

### Test Structure

```
test/
├── integration/          # Integration tests
│   ├── auth/
│   ├── graphql/
│   └── metadata/
└── unit/                # Unit tests (in src/ alongside code)
```

### Running Tests

```bash
# All unit tests
npx nx test twenty-server

# Specific test file
npx nx test twenty-server --testFile=auth.service.spec.ts

# Integration tests
npx nx run twenty-server:test:integration:with-db-reset

# Watch mode
npx nx test twenty-server --watch

# Coverage
npx nx test twenty-server --coverage
```

### Writing Tests

```typescript
// Unit test example
describe('CompanyService', () => {
  let service: CompanyService;
  
  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [CompanyService],
    }).compile();
    
    service = module.get<CompanyService>(CompanyService);
  });
  
  it('should create a company', async () => {
    const result = await service.create({
      name: 'Test Co',
    });
    expect(result.name).toBe('Test Co');
  });
});
```

---

## Deployment

### Docker Deployment

#### Using Pre-built Image

```bash
docker run -d \
  -p 3000:3000 \
  -e PG_DATABASE_URL=postgres://... \
  -e REDIS_URL=redis://... \
  -e APP_SECRET=your-secret \
  twentycrm/twenty:latest
```

#### Docker Compose

```yaml
version: '3.8'
services:
  twenty-server:
    image: twentycrm/twenty:latest
    ports:
      - "3000:3000"
    environment:
      PG_DATABASE_URL: postgres://postgres:password@db:5432/twenty
      REDIS_URL: redis://redis:6379
      APP_SECRET: ${APP_SECRET}
    depends_on:
      - db
      - redis
  
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: twenty
      POSTGRES_PASSWORD: password
    volumes:
      - postgres-data:/var/lib/postgresql/data
  
  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data

volumes:
  postgres-data:
  redis-data:
```

### Kubernetes Deployment

Example deployment manifests available in `packages/twenty-docker/k8s/`.

```bash
# Using Terraform
cd packages/twenty-docker/k8s/terraform
terraform init
terraform apply
```

### Production Checklist

- [ ] Set strong `APP_SECRET`
- [ ] Configure SSL certificates
- [ ] Set up PostgreSQL backups
- [ ] Configure Redis persistence
- [ ] Enable monitoring (Sentry, OpenTelemetry)
- [ ] Set up log aggregation
- [ ] Configure rate limiting
- [ ] Enable CORS for frontend domains
- [ ] Set up CDN for file storage
- [ ] Configure email service (SMTP/SES)
- [ ] Test backup restoration

### Scaling

#### Horizontal Scaling

Run multiple server instances behind a load balancer:

```yaml
# Kubernetes example
replicas: 3
```

#### Worker Scaling

Scale background workers independently:

```yaml
# Separate worker deployment
replicas: 5
```

#### Database Optimization

- Use read replicas for read-heavy workloads
- Enable connection pooling (PgBouncer)
- Optimize indexes based on query patterns

---

## Monitoring & Observability

### Health Checks

```bash
# Liveness probe
GET /healthz

# Readiness probe (checks DB connectivity)
GET /healthz
```

### Metrics

OpenTelemetry metrics exported to Prometheus-compatible endpoints:

- Request latency
- Error rates
- Database query performance
- Job queue metrics

### Error Tracking

Sentry integration for error tracking:

```bash
# In .env
EXCEPTION_HANDLER_DRIVER=sentry
SENTRY_DSN=https://...@sentry.io/...
SENTRY_ENVIRONMENT=production
```

### Logging

Structured JSON logging with multiple drivers:

```bash
LOGGER_DRIVER=console  # or 'winston' for production
LOG_LEVELS=error,warn,log
```

---

## Contributing

### Code Style

- Use functional components (no classes for business logic)
- Prefer named exports over default exports
- Use types over interfaces (except extending third-party)
- No `any` type allowed
- Follow existing patterns in codebase

### Pull Request Process

1. Create feature branch from `main`
2. Make changes with descriptive commits
3. Add/update tests
4. Run linter and tests
5. Create PR with detailed description

---

## Resources

- **Main Repository**: [github.com/twentyhq/twenty](https://github.com/twentyhq/twenty)
- **Documentation**: [docs.twenty.com](https://docs.twenty.com)
- **API Documentation**: Available at `/rest/open-api/core`
- **Discord Community**: [discord.gg/twenty](https://discord.gg/twenty)

---

## License

AGPLv3 - see [LICENSE](../../LICENSE) file for details.

---

## Support

- 📧 Email: felix@twenty.com
- 💬 Discord: [discord.gg/twenty](https://discord.gg/twenty)
- 🐛 Issues: [GitHub Issues](https://github.com/twentyhq/twenty/issues)
