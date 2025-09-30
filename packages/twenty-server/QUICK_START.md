# Twenty Server - Quick Start Guide

Get Twenty Server up and running in minutes!

## Prerequisites

- Node.js 24.5.0+
- PostgreSQL 15+
- Redis 7+
- Yarn 4+

## 5-Minute Setup

### 1. Start Required Services

```bash
# PostgreSQL
docker run -d --name twenty-postgres \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=twenty \
  postgres:15

# Redis
docker run -d --name twenty-redis \
  -p 6379:6379 \
  redis:7-alpine
```

### 2. Configure Environment

```bash
cd packages/twenty-server
cp .env.example .env
```

Edit `.env`:
```bash
PG_DATABASE_URL=postgres://postgres:postgres@localhost:5432/twenty
REDIS_URL=redis://localhost:6379
APP_SECRET=change_this_to_a_random_string
FRONTEND_URL=http://localhost:3001
```

### 3. Initialize Database

```bash
npx nx database:reset twenty-server
```

### 4. Start Server

```bash
npx nx start twenty-server
```

Server runs at: `http://localhost:3000`

## Test Your Setup

### Health Check
```bash
curl http://localhost:3000/healthz
```

### GraphQL Playground
Open in browser: `http://localhost:3000/graphql`

### Sample Query
```graphql
query GetWorkspace {
  currentWorkspace {
    id
    name
  }
}
```

## Next Steps

- 📖 Read [README.md](./README.md) for comprehensive overview
- 🏗️ See [ARCHITECTURE.md](./ARCHITECTURE.md) for architecture details
- 🔌 Check [API.md](./API.md) for API reference
- 💻 Follow [DEVELOPMENT.md](./DEVELOPMENT.md) for development guide
- 📊 View [DIAGRAMS.md](./DIAGRAMS.md) for visual architecture

## Common Commands

```bash
# Development
npx nx start twenty-server              # Start server
npx nx run twenty-server:worker         # Start background worker

# Database
npx nx database:reset twenty-server     # Reset database
yarn database:migrate:prod              # Run migrations

# Testing
npx nx test twenty-server               # Unit tests
npx nx run twenty-server:test:integration:with-db-reset  # Integration tests

# Code Quality
npx nx lint twenty-server --fix         # Lint and fix
npx nx typecheck twenty-server          # Type check
```

## Troubleshooting

**Port 3000 in use?**
```bash
lsof -ti:3000 | xargs kill -9
# Or change NODE_PORT in .env
```

**Database connection failed?**
```bash
docker ps | grep postgres
docker start twenty-postgres
```

**Redis connection failed?**
```bash
docker ps | grep redis
docker start twenty-redis
```

## Documentation Index

All documentation is in `/packages/twenty-server/`:

- **[DOCS.md](./DOCS.md)** - Documentation index
- **[README.md](./README.md)** - Main documentation (24KB)
- **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Architecture deep-dive (18KB)
- **[API.md](./API.md)** - Complete API reference (20KB)
- **[DEVELOPMENT.md](./DEVELOPMENT.md)** - Development guide (22KB)
- **[DIAGRAMS.md](./DIAGRAMS.md)** - Visual diagrams (20KB)

## Support

- 💬 Discord: [discord.gg/twenty](https://discord.gg/twenty)
- 📧 Email: felix@twenty.com
- 🐛 Issues: [GitHub Issues](https://github.com/twentyhq/twenty/issues)

---

**Happy Coding! 🚀**
