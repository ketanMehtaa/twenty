# Twenty Server - Documentation Index

Welcome to the Twenty Server documentation! This index helps you navigate through all available documentation.

## 📚 Documentation Overview

Twenty Server is the backend API and business logic layer for the Twenty CRM platform. This comprehensive documentation covers architecture, development, deployment, and API usage.

---

## 📖 Documentation Files

### 1. [README.md](./README.md) - Main Documentation
**Start Here!** Comprehensive overview of Twenty Server.

**Contents:**
- System architecture with diagrams
- Quick start guide
- Project structure
- Core concepts (Workspaces, Metadata, ORM, GraphQL, Jobs)
- API endpoints overview
- Configuration guide
- Database architecture
- Authentication & Authorization
- Development workflow
- Testing
- Deployment (Docker, Kubernetes)
- Monitoring & Observability

**Best for:** Getting started, understanding the system, deployment

---

### 2. [ARCHITECTURE.md](./ARCHITECTURE.md) - Detailed Architecture
In-depth architectural documentation with detailed diagrams.

**Contents:**
- Layered architecture explanation
- Architectural patterns (Modular Monolith, DI, Repository, CQRS, Event-Driven)
- Module architecture
- Data flow diagrams (queries, mutations, background jobs)
- Multi-tenancy implementation
- GraphQL schema generation process
- Request lifecycle
- Performance & Scalability strategies
- Security architecture
- Deployment architecture

**Best for:** Architects, senior developers, understanding system design

---

### 3. [API.md](./API.md) - Complete API Reference
Comprehensive API documentation with examples.

**Contents:**
- Authentication methods (API Keys, JWT, OAuth, SSO)
- GraphQL Core API
  - Companies, People, Opportunities, Tasks, Notes
  - Custom objects
  - Batch operations
  - Query examples with filters and pagination
- GraphQL Metadata API
  - Object and field management
  - Relation creation
- REST API
  - CRUD operations for all resources
  - Query parameters and filtering
  - OpenAPI specification
- Error handling
- Rate limiting
- Pagination strategies
- Webhooks

**Best for:** API consumers, integration developers, frontend developers

---

### 4. [DEVELOPMENT.md](./DEVELOPMENT.md) - Developer Guide
Practical guide for developing with Twenty Server.

**Contents:**
- Environment setup (step-by-step)
- VS Code configuration
- Common development tasks
- Creating custom modules (complete walkthrough)
- Working with metadata programmatically
- Database migrations
- Testing strategies (unit, integration, e2e)
- Debugging techniques
- Code style guide
- Troubleshooting common issues

**Best for:** Backend developers, contributors, new team members

---

### 5. [DIAGRAMS.md](./DIAGRAMS.md) - Visual Architecture Guide
Quick reference with visual diagrams for all major concepts.

**Contents:**
- System architecture overview
- Request flow diagrams
- Multi-tenancy architecture
- GraphQL schema generation
- Module dependency tree
- Authentication & authorization flow
- Background job processing
- Data access patterns
- Deployment architecture
- Entity relationship diagram
- Performance optimization
- Security layers

**Best for:** Visual learners, presentations, quick reference

---

## 🚀 Quick Navigation

### I want to...

**Get Started Quickly**
→ [README.md - Quick Start](./README.md#quick-start)

**Understand the Architecture**
→ [ARCHITECTURE.md](./ARCHITECTURE.md) or [DIAGRAMS.md](./DIAGRAMS.md)

**Use the API**
→ [API.md](./API.md)

**Develop a Feature**
→ [DEVELOPMENT.md](./DEVELOPMENT.md)

**Deploy to Production**
→ [README.md - Deployment](./README.md#deployment)

**Debug an Issue**
→ [DEVELOPMENT.md - Debugging](./DEVELOPMENT.md#debugging)

**See Visual Diagrams**
→ [DIAGRAMS.md](./DIAGRAMS.md)

---

## 📊 Documentation Statistics

- **Total Documentation**: ~102KB
- **Total Lines**: ~4,900 lines
- **Mermaid Diagrams**: 25+ diagrams
- **Code Examples**: 100+ examples
- **Files**: 5 comprehensive documents

---

## 🎯 Documentation by Role

### For Backend Developers
1. [README.md](./README.md) - Overview
2. [DEVELOPMENT.md](./DEVELOPMENT.md) - Development guide
3. [ARCHITECTURE.md](./ARCHITECTURE.md) - Architecture details
4. [API.md](./API.md) - API reference

### For Frontend Developers
1. [README.md - API Endpoints](./README.md#api-endpoints)
2. [API.md](./API.md) - Complete API reference
3. [DIAGRAMS.md - Request Flow](./DIAGRAMS.md)

### For DevOps/SRE
1. [README.md - Deployment](./README.md#deployment)
2. [README.md - Configuration](./README.md#configuration)
3. [ARCHITECTURE.md - Deployment Architecture](./ARCHITECTURE.md)
4. [DIAGRAMS.md - Deployment Architecture](./DIAGRAMS.md)

### For Architects
1. [ARCHITECTURE.md](./ARCHITECTURE.md) - Complete architecture
2. [DIAGRAMS.md](./DIAGRAMS.md) - Visual diagrams
3. [README.md - Architecture](./README.md#architecture)

### For Product Managers
1. [README.md - Overview](./README.md#overview)
2. [README.md - Core Concepts](./README.md#core-concepts)
3. [DIAGRAMS.md](./DIAGRAMS.md) - Visual overview

---

## 🔗 External Resources

- **Main Repository**: [github.com/twentyhq/twenty](https://github.com/twentyhq/twenty)
- **Official Documentation**: [docs.twenty.com](https://docs.twenty.com)
- **Discord Community**: [discord.gg/twenty](https://discord.gg/twenty)
- **NestJS Docs**: [docs.nestjs.com](https://docs.nestjs.com/)
- **GraphQL Docs**: [graphql.org](https://graphql.org/learn/)
- **TypeORM Docs**: [typeorm.io](https://typeorm.io/)

---

## 📝 Contributing to Documentation

If you find errors or want to improve the documentation:

1. Fork the repository
2. Make your changes
3. Submit a pull request

Documentation is written in Markdown with Mermaid diagrams.

---

## 💡 Tips for Reading Documentation

1. **Start with README.md** for a general overview
2. **Use DIAGRAMS.md** for quick visual reference
3. **Dive into ARCHITECTURE.md** for deep understanding
4. **Keep API.md** handy for API development
5. **Follow DEVELOPMENT.md** for hands-on development

---

## ⚡ Quick Commands Reference

```bash
# Start development server
npx nx start twenty-server

# Run tests
npx nx test twenty-server

# Run integration tests
npx nx run twenty-server:test:integration:with-db-reset

# Database reset
npx nx database:reset twenty-server

# Run migrations
yarn database:migrate:prod

# Start worker
npx nx run twenty-server:worker

# Lint code
npx nx lint twenty-server --fix

# Type check
npx nx typecheck twenty-server
```

---

## 📞 Support

- **Email**: felix@twenty.com
- **Discord**: [discord.gg/twenty](https://discord.gg/twenty)
- **GitHub Issues**: [github.com/twentyhq/twenty/issues](https://github.com/twentyhq/twenty/issues)

---

## License

AGPLv3 - see [LICENSE](../../LICENSE) file for details.

---

**Last Updated**: 2024
**Version**: 1.0
