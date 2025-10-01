# Twenty Project Documentation Guide

Welcome to the comprehensive documentation for the Twenty CRM project! This guide will help you navigate through the documentation and find the information you need.

## 📚 Documentation Overview

This repository contains extensive documentation covering all aspects of the Twenty project. Whether you're a new contributor, a developer working with the codebase, or someone interested in understanding the architecture, you'll find detailed information here.

## 🗂️ Documentation Structure

### Core Documentation Files

1. **[PROJECT_OVERVIEW.md](./PROJECT_OVERVIEW.md)** - Start here!
   - Complete overview of the Twenty project
   - High-level architecture diagrams
   - Monorepo structure explanation
   - Technology stack details
   - Key features and capabilities
   - Development workflow guide
   - Links to all other resources

2. **[FRONTEND_ARCHITECTURE.md](./FRONTEND_ARCHITECTURE.md)** - Frontend deep dive
   - React application structure
   - Module-based architecture
   - State management with Recoil
   - GraphQL integration with Apollo Client
   - Routing with React Router
   - Styling with Emotion
   - Component library (UI module)
   - Development guidelines and best practices

3. **[BACKEND_ARCHITECTURE.md](./BACKEND_ARCHITECTURE.md)** - Backend deep dive
   - NestJS application structure
   - Core engine architecture
   - Dynamic metadata system
   - Multi-tenant workspace architecture
   - GraphQL API layer
   - Database design with PostgreSQL and TypeORM
   - Background job processing with BullMQ
   - Key business modules

## 🎯 Quick Start Guide

### For New Contributors

1. **Read [PROJECT_OVERVIEW.md](./PROJECT_OVERVIEW.md)** to understand the overall architecture
2. **Set up your development environment** following the [Development Workflow](./PROJECT_OVERVIEW.md#development-workflow) section
3. **Read the specific architecture docs** based on what you'll be working on:
   - Frontend work? → [FRONTEND_ARCHITECTURE.md](./FRONTEND_ARCHITECTURE.md)
   - Backend work? → [BACKEND_ARCHITECTURE.md](./BACKEND_ARCHITECTURE.md)

### For Frontend Developers

1. Start with [FRONTEND_ARCHITECTURE.md](./FRONTEND_ARCHITECTURE.md)
2. Explore the [Core Modules](./FRONTEND_ARCHITECTURE.md#core-modules) section
3. Review [State Management](./FRONTEND_ARCHITECTURE.md#state-management) patterns
4. Check [Development Guidelines](./FRONTEND_ARCHITECTURE.md#development-guidelines)

### For Backend Developers

1. Start with [BACKEND_ARCHITECTURE.md](./BACKEND_ARCHITECTURE.md)
2. Understand the [Metadata System](./BACKEND_ARCHITECTURE.md#metadata-system)
3. Learn about [Workspace Architecture](./BACKEND_ARCHITECTURE.md#workspace-architecture)
4. Review [Development Guidelines](./BACKEND_ARCHITECTURE.md#development-guidelines)

## 📖 Detailed Documentation

### Project Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Twenty Platform                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────┐        ┌──────────────────┐          │
│  │   twenty-front   │◄──────►│  twenty-server   │          │
│  │   (React SPA)    │  API   │  (NestJS API)    │          │
│  └──────────────────┘        └──────────────────┘          │
│           │                           │                      │
│           ▼                           ▼                      │
│  ┌──────────────────┐        ┌──────────────────┐          │
│  │    twenty-ui     │        │   PostgreSQL     │          │
│  │ (UI Components)  │        │    Database      │          │
│  └──────────────────┘        └──────────────────┘          │
│                                       │                      │
│                                       ▼                      │
│                               ┌──────────────────┐          │
│                               │      Redis       │          │
│                               │    (Cache)       │          │
│                               └──────────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

### Monorepo Packages

The Twenty project is organized as a monorepo with the following main packages:

- **twenty-front**: React frontend application
- **twenty-server**: NestJS backend API
- **twenty-ui**: Shared UI component library
- **twenty-shared**: Shared types and utilities
- **twenty-emails**: Email templates
- **twenty-website**: Documentation website
- **twenty-zapier**: Zapier integration
- **twenty-e2e-testing**: End-to-end tests

For complete details, see [Monorepo Structure](./PROJECT_OVERVIEW.md#monorepo-structure).

## 🔧 Development Commands

### Quick Reference

```bash
# Start full development environment
yarn start

# Frontend development
npx nx start twenty-front
npx nx test twenty-front
npx nx lint twenty-front

# Backend development
npx nx start twenty-server
npx nx test twenty-server
npx nx run twenty-server:worker

# Database operations
npx nx database:reset twenty-server
npx nx run twenty-server:database:migrate:prod
```

For a complete list of commands, see [Development Workflow](./PROJECT_OVERVIEW.md#development-workflow).

## 🏗️ Architecture Highlights

### Frontend Architecture

- **Framework**: React 18 with TypeScript
- **State Management**: Recoil for global state
- **Data Fetching**: Apollo Client for GraphQL
- **Styling**: Emotion (CSS-in-JS)
- **Build Tool**: Vite

**Key Features:**
- Module-based architecture
- Dynamic component rendering based on metadata
- Real-time updates via GraphQL subscriptions
- Comprehensive Storybook component documentation

[Learn more →](./FRONTEND_ARCHITECTURE.md)

### Backend Architecture

- **Framework**: NestJS with TypeScript
- **Database**: PostgreSQL with TypeORM
- **API**: Dynamic GraphQL schema generation
- **Jobs**: BullMQ for background processing
- **Cache**: Redis

**Key Features:**
- Multi-tenant workspace isolation
- Dynamic schema generation from metadata
- Flexible field and object type system
- Comprehensive workflow automation engine

[Learn more →](./BACKEND_ARCHITECTURE.md)

## 🎨 Key Features Explained

### 1. Dynamic Metadata System

Twenty's metadata system allows users to create custom objects and fields without code changes. The backend generates:
- GraphQL schema
- Database tables
- API resolvers
- Type definitions

[Metadata System Details →](./BACKEND_ARCHITECTURE.md#metadata-system)

### 2. Multi-Tenant Architecture

Each workspace operates in complete isolation:
- Separate PostgreSQL schema
- Independent GraphQL schema
- Isolated data storage
- Custom metadata per workspace

[Workspace Architecture Details →](./BACKEND_ARCHITECTURE.md#workspace-architecture)

### 3. View System

Flexible data presentation with:
- Multiple view types (Table, Kanban)
- Advanced filtering with AND/OR logic
- Multi-column sorting
- Group by functionality
- Personal and shared views

[Views Module Details →](./FRONTEND_ARCHITECTURE.md#core-modules)

### 4. Workflow Automation

Powerful automation capabilities:
- Various trigger types (record events, scheduled, webhook)
- Multiple actions (update record, send email, webhook, code)
- Conditional execution
- Version management

[Workflow Module Details →](./BACKEND_ARCHITECTURE.md#key-business-modules)

## 🧪 Testing Strategy

- **Unit Tests**: Jest for both frontend and backend
- **Integration Tests**: Backend API testing with database
- **E2E Tests**: Playwright for critical user flows
- **Component Tests**: Storybook for UI components
- **Visual Regression**: Chromatic for visual testing

## 📚 Additional Resources

### Official Documentation

- [Official Website](https://twenty.com)
- [Developer Documentation](https://twenty.com/developers)
- [Local Setup Guide](https://twenty.com/developers/local-setup)
- [Self-Hosting Guide](https://twenty.com/developers/section/self-hosting)

### Repository Documentation

Located in `packages/twenty-website/src/content/developers/`:

**Frontend:**
- [Folder Architecture](./packages/twenty-website/src/content/developers/frontend-development/folder-architecture-front.mdx)
- [Frontend Commands](./packages/twenty-website/src/content/developers/frontend-development/frontend-commands.mdx)
- [Style Guide](./packages/twenty-website/src/content/developers/frontend-development/style-guide.mdx)
- [Best Practices](./packages/twenty-website/src/content/developers/frontend-development/best-practices-front.mdx)

**Backend:**
- [Folder Architecture](./packages/twenty-website/src/content/developers/backend-development/folder-architecture-server.mdx)
- [Server Commands](./packages/twenty-website/src/content/developers/backend-development/server-commands.mdx)
- [Best Practices](./packages/twenty-website/src/content/developers/backend-development/best-practices-server.mdx)
- [Custom Objects](./packages/twenty-website/src/content/developers/backend-development/custom-objects.mdx)

### Community Resources

- [Discord Server](https://discord.gg/cx5n4Jzs57) - Join the community
- [GitHub Discussions](https://github.com/twentyhq/twenty/discussions) - Ask questions
- [Contributing Guide](https://github.com/twentyhq/twenty/blob/main/.github/CONTRIBUTING.md) - Contribute to the project
- [Figma Design Files](https://www.figma.com/file/xt8O9mFeLl46C5InWwoMrN/Twenty) - View designs

### API Documentation

- [GraphQL API Documentation](https://twenty.com/developers/graphql-apis)
- [REST API Documentation](https://twenty.com/developers/rest-apis)
- [Webhooks Documentation](https://twenty.com/developers/api-and-webhooks)

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. **Read the documentation** (you're already doing this! 🎉)
2. **Set up your development environment** using the [Development Workflow](./PROJECT_OVERVIEW.md#development-workflow) guide
3. **Find an issue** to work on or propose a new feature
4. **Follow the code style** and [Development Guidelines](./FRONTEND_ARCHITECTURE.md#development-guidelines)
5. **Submit a pull request** with your changes

For detailed contribution guidelines, see the [Contributing Guide](https://github.com/twentyhq/twenty/blob/main/.github/CONTRIBUTING.md).

## 📝 Documentation Updates

These documentation files are actively maintained. If you find any errors or have suggestions for improvements:

1. Open an issue describing the problem or improvement
2. Submit a pull request with your changes
3. Tag your PR with the `documentation` label

## 🔍 Finding Information

Use this quick reference to find specific information:

| Looking for... | Check this file | Section |
|---------------|----------------|---------|
| Project overview | PROJECT_OVERVIEW.md | All sections |
| Monorepo structure | PROJECT_OVERVIEW.md | Monorepo Structure |
| Tech stack details | PROJECT_OVERVIEW.md or specific architecture docs | Technology Stack |
| Frontend modules | FRONTEND_ARCHITECTURE.md | Core Modules |
| State management | FRONTEND_ARCHITECTURE.md | State Management |
| GraphQL integration | FRONTEND_ARCHITECTURE.md | GraphQL Integration |
| Backend modules | BACKEND_ARCHITECTURE.md | Core Engine |
| Metadata system | BACKEND_ARCHITECTURE.md | Metadata System |
| Database design | BACKEND_ARCHITECTURE.md | Database Layer |
| Workspace architecture | BACKEND_ARCHITECTURE.md | Workspace Architecture |
| Background jobs | BACKEND_ARCHITECTURE.md | Background Jobs |
| Development commands | PROJECT_OVERVIEW.md | Development Workflow |
| Testing strategy | PROJECT_OVERVIEW.md or specific docs | Testing sections |

## 🚀 Next Steps

Now that you've found the documentation:

1. **For new contributors**: Start with [PROJECT_OVERVIEW.md](./PROJECT_OVERVIEW.md)
2. **For frontend work**: Read [FRONTEND_ARCHITECTURE.md](./FRONTEND_ARCHITECTURE.md)
3. **For backend work**: Read [BACKEND_ARCHITECTURE.md](./BACKEND_ARCHITECTURE.md)
4. **Set up your environment**: Follow the [Development Workflow](./PROJECT_OVERVIEW.md#development-workflow)
5. **Join the community**: [Discord](https://discord.gg/cx5n4Jzs57) or [GitHub Discussions](https://github.com/twentyhq/twenty/discussions)

## 📧 Questions?

If you have questions not covered in the documentation:

- Check [GitHub Discussions](https://github.com/twentyhq/twenty/discussions)
- Join the [Discord Server](https://discord.gg/cx5n4Jzs57)
- Open an issue with the `question` label

---

**Happy coding!** 🎉

Built with ❤️ by the Twenty community
