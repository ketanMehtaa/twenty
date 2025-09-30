# Twenty Server

The backend server for Twenty CRM, built with NestJS, TypeORM, and GraphQL.

## Overview

Twenty Server is a powerful backend application that provides:

- **GraphQL API**: Modern, type-safe API with GraphQL Yoga
- **Database Management**: PostgreSQL with TypeORM for data persistence
- **Authentication & Authorization**: Secure user authentication and workspace-based access control
- **Real-time Features**: Subscriptions and real-time updates
- **Background Processing**: Distributed job processing with Twenty Workers
- **Multi-tenancy**: Workspace isolation and management
- **Extensibility**: Plugin system and custom field support

## Architecture

```
twenty-server/
├── src/
│   ├── engine/              # Core engine modules
│   │   ├── core-modules/    # Core system modules (auth, billing, etc.)
│   │   ├── metadata-modules/# Metadata management
│   │   ├── twenty-orm/      # Custom ORM layer
│   │   └── workspace-*/     # Workspace management
│   ├── modules/             # Business logic modules
│   │   ├── calendar/        # Calendar integration
│   │   ├── messaging/       # Messaging/email sync
│   │   ├── workflow/        # Workflow automation
│   │   └── ...
│   ├── database/            # Database migrations and configuration
│   ├── queue-worker/        # Background worker entry point
│   └── main.ts              # Server entry point
└── scripts/                 # Utility scripts
```

## Key Components

### Core Engine Modules

- **Auth**: Authentication, authorization, and token management
- **Billing**: Subscription and billing management
- **User & Workspace**: User accounts and workspace management
- **File Storage**: File upload and storage handling
- **Message Queue**: Background job processing system
- **GraphQL**: GraphQL schema generation and resolvers
- **Audit**: Activity tracking and analytics

### Business Modules

- **Calendar**: Google Calendar and Microsoft Calendar synchronization
- **Messaging**: Gmail and Outlook message synchronization
- **Workflow**: Automated workflow execution
- **Timeline**: Activity timeline and events
- **Webhook**: Outgoing webhook management

## Running the Server

### Development

```bash
# Start the server in development mode
npx nx start twenty-server

# Start with worker
yarn start
```

### Production

```bash
# Build
npx nx build twenty-server

# Run migrations
yarn workspace twenty-server database:migrate:prod

# Start server
yarn workspace twenty-server start:prod

# Start worker (in separate process)
yarn workspace twenty-server worker:prod
```

## Documentation

- **[Workers Documentation](./WORKERS.md)**: Complete guide to Twenty Workers and background job processing
- **[Audit Module](./src/engine/core-modules/audit/README.md)**: Analytics and event tracking

## Configuration

Key environment variables:

```bash
# Server
NODE_PORT=3000
SERVER_URL=http://localhost:3000

# Database
PG_DATABASE_URL=postgres://user:password@localhost:5432/twenty

# Redis
REDIS_URL=redis://localhost:6379

# Security
APP_SECRET=your-secret-key
ACCESS_TOKEN_SECRET=your-token-secret
REFRESH_TOKEN_SECRET=your-refresh-secret

# Storage
STORAGE_TYPE=local  # or 's3'
STORAGE_S3_REGION=us-east-1
STORAGE_S3_NAME=your-bucket-name

# Optional: Disable migrations (for workers)
DISABLE_DB_MIGRATIONS=false

# Optional: Disable cron job registration (for workers)
DISABLE_CRON_JOBS_REGISTRATION=false
```

## Testing

```bash
# Unit tests
npx nx test twenty-server

# Integration tests
npx nx run twenty-server:test:integration:with-db-reset

# E2E tests
npx nx test:e2e twenty-server
```

## Development Tools

### GraphQL Playground

Access the GraphQL playground at `http://localhost:3000/graphql`

### Database Tools

```bash
# Generate a new migration
npx nx run twenty-server:typeorm migration:generate src/database/typeorm/core/migrations/YourMigrationName -d src/database/typeorm/core/core.datasource.ts

# Run migrations
npx nx database:reset twenty-server

# Sync metadata
npx nx run twenty-server:command workspace:sync-metadata -f
```

## Architecture Patterns

### Module Structure

Each module follows NestJS conventions:

```typescript
@Module({
  imports: [/* dependencies */],
  providers: [/* services, jobs */],
  exports: [/* public services */],
})
export class MyModule {}
```

### Service Layer

Business logic is encapsulated in services:

```typescript
@Injectable()
export class MyService {
  constructor(
    // Inject dependencies
  ) {}

  async doSomething() {
    // Implementation
  }
}
```

### Job Processing

Background jobs use the decorator pattern:

```typescript
@Processor({ queueName: MessageQueue.myQueue })
export class MyJob {
  @Process(MyJob.name)
  async handle(data: MyJobData): Promise<void> {
    // Job implementation
  }
}
```

See [WORKERS.md](./WORKERS.md) for detailed documentation.

## Performance Considerations

### Database

- Connection pooling is configured automatically
- Use indexes for frequently queried fields
- Implement pagination for large datasets
- Use database transactions for multi-step operations

### Caching

Redis is used for:
- Session storage
- Job queues
- Cache layer for expensive operations

### Background Processing

Long-running operations should be offloaded to workers:

```typescript
// Instead of processing synchronously
await this.messageQueueService.add(
  MyJob.name,
  { workspaceId, data },
  { priority: 1 }
);
```

## Security

### Authentication

- JWT-based authentication
- Refresh token rotation
- Workspace-based access control

### Authorization

- Role-based access control (RBAC)
- Workspace membership validation
- Resource-level permissions

### Best Practices

- Always validate input data
- Use parameterized queries (TypeORM handles this)
- Implement rate limiting for public endpoints
- Sanitize user-generated content
- Keep dependencies up to date

## Troubleshooting

### Common Issues

**Database Connection Issues**
```bash
# Check connection
psql $PG_DATABASE_URL

# Verify environment variables
echo $PG_DATABASE_URL
```

**Redis Connection Issues**
```bash
# Test Redis connection
redis-cli -u $REDIS_URL ping
```

**Port Already in Use**
```bash
# Find and kill process using port 3000
lsof -ti:3000 | xargs kill -9
```

### Logging

Set log level with environment variable:
```bash
LOG_LEVEL=debug  # error, warn, log, debug, verbose
```

## Contributing

1. Follow the existing code structure
2. Write tests for new features
3. Update documentation
4. Follow TypeScript best practices
5. Use named exports (no default exports)
6. Prefer types over interfaces

## Related Packages

- **[twenty-front](../twenty-front/README.md)**: Frontend application
- **[twenty-ui](../twenty-ui/README.md)**: Shared UI components
- **[twenty-shared](../twenty-shared/)**: Shared utilities and types
- **[twenty-emails](../twenty-emails/README.md)**: Email templates

## License

AGPL-3.0 - See [LICENSE](../../LICENSE) for details
