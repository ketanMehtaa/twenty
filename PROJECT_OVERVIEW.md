# Twenty Project - Complete Documentation

## Table of Contents
1. [Overview](#overview)
2. [Project Architecture](#project-architecture)
3. [Monorepo Structure](#monorepo-structure)
4. [Frontend Architecture (twenty-front)](#frontend-architecture-twenty-front)
5. [Backend Architecture (twenty-server)](#backend-architecture-twenty-server)
6. [Technology Stack](#technology-stack)
7. [Key Modules and Features](#key-modules-and-features)
8. [Development Workflow](#development-workflow)
9. [Additional Resources](#additional-resources)

---

## Overview

Twenty is an open-source CRM (Customer Relationship Management) platform built with modern web technologies. The project is designed to be flexible, extensible, and developer-friendly, offering a fresh alternative to traditional CRM systems.

### Key Features
- **Customizable Data Models**: Create and manage custom objects and fields
- **Flexible Views**: Table, Kanban, and other view types with filters, sorting, and grouping
- **Workflow Automation**: Triggers and actions for automating business processes
- **Role-Based Permissions**: Fine-grained access control with custom roles
- **Email & Calendar Integration**: Seamless integration with email and calendar events
- **GraphQL & REST APIs**: Modern API architecture for integration

### Design Philosophy
- Open-source and community-driven
- Modern UX patterns inspired by tools like Notion, Airtable, and Linear
- Extensible architecture with plugin capabilities
- Developer-friendly with comprehensive documentation

---

## Project Architecture

Twenty follows a **monorepo architecture** managed with Nx, containing multiple interconnected packages that work together to provide a complete CRM solution.

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
│                                                              │
│  ┌──────────────────┐        ┌──────────────────┐          │
│  │  twenty-emails   │        │  twenty-zapier   │          │
│  │ (Email Templates)│        │  (Integration)   │          │
│  └──────────────────┘        └──────────────────┘          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Architecture Principles

1. **Separation of Concerns**: Clear boundaries between frontend, backend, and shared code
2. **Modular Design**: Features organized into self-contained modules
3. **API-First**: GraphQL and REST APIs for all interactions
4. **Type Safety**: TypeScript throughout the stack
5. **Scalability**: Horizontal scaling with Redis and PostgreSQL
6. **Testability**: Comprehensive test infrastructure at all levels

---

## Monorepo Structure

The project uses **Nx** for monorepo management and **Yarn 4** for package management.

```
twenty/
├── packages/
│   ├── twenty-front/           # React frontend application
│   ├── twenty-server/          # NestJS backend API
│   ├── twenty-ui/              # Shared UI component library
│   ├── twenty-shared/          # Shared types and utilities
│   ├── twenty-emails/          # Email templates (React Email)
│   ├── twenty-website/         # Next.js documentation website
│   ├── twenty-zapier/          # Zapier integration package
│   ├── twenty-e2e-testing/     # Playwright E2E tests
│   ├── twenty-apps/            # App marketplace
│   ├── twenty-cli/             # CLI tools
│   ├── twenty-docker/          # Docker configuration
│   └── twenty-utils/           # Utility functions
├── tools/                       # Build and development tools
├── .github/                     # GitHub workflows and actions
├── nx.json                      # Nx workspace configuration
├── package.json                 # Root package configuration
└── tsconfig.base.json          # Base TypeScript configuration
```

### Package Details

| Package | Purpose | Technology |
|---------|---------|------------|
| **twenty-front** | Main frontend application | React 18, Recoil, Emotion, Vite |
| **twenty-server** | Backend API and worker | NestJS, TypeORM, GraphQL Yoga |
| **twenty-ui** | Reusable UI components | React, Emotion, Storybook |
| **twenty-shared** | Shared types and utilities | TypeScript |
| **twenty-emails** | Email templates | React Email |
| **twenty-website** | Documentation site | Next.js |
| **twenty-zapier** | Zapier integration | Node.js |
| **twenty-e2e-testing** | End-to-end tests | Playwright |
| **twenty-apps** | App marketplace | - |
| **twenty-cli** | Command-line tools | Node.js |

---

## Frontend Architecture (twenty-front)

The frontend is a modern React application built with TypeScript, using Recoil for state management and Emotion for styling.

### Directory Structure

```
twenty-front/
├── src/
│   ├── modules/                 # Feature modules
│   │   ├── activities/         # Activity tracking
│   │   ├── auth/               # Authentication
│   │   ├── object-record/      # Record management
│   │   ├── object-metadata/    # Metadata management
│   │   ├── settings/           # Settings UI
│   │   ├── views/              # View management
│   │   ├── workflow/           # Workflow automation
│   │   ├── ui/                 # UI components
│   │   └── ...                 # Many more modules
│   ├── pages/                   # Route-level components
│   │   ├── auth/               # Auth pages
│   │   ├── object-record/      # Record pages
│   │   ├── onboarding/         # Onboarding flow
│   │   └── not-found/          # 404 page
│   ├── generated/              # GraphQL generated code
│   ├── generated-metadata/     # Metadata generated code
│   ├── hooks/                   # Global hooks
│   ├── utils/                   # Utility functions
│   ├── config/                  # Configuration
│   └── index.tsx               # Application entry
├── .storybook/                  # Storybook configuration
├── public/                      # Static assets
└── package.json                 # Package configuration
```

### Module Structure

Each module follows a consistent structure for maintainability:

```
module-name/
├── components/                  # React components
│   ├── ComponentA.tsx
│   └── ComponentB.tsx
├── hooks/                       # Custom React hooks
│   ├── internal/               # Internal-only hooks
│   └── useModuleHook.ts
├── states/                      # Recoil state atoms
│   ├── selectors/              # Recoil selectors
│   └── moduleState.ts
├── graphql/                     # GraphQL operations
│   ├── queries/                # GraphQL queries
│   ├── mutations/              # GraphQL mutations
│   └── fragments/              # GraphQL fragments
├── contexts/                    # React contexts
├── constants/                   # Module constants
├── types/                       # TypeScript types
└── utils/                       # Utility functions
```

### Key Frontend Modules

1. **auth**: Authentication and authorization
   - Login, signup, password reset
   - Token management
   - OAuth integration

2. **object-record**: Core record management
   - CRUD operations for records
   - Record display and editing
   - Record relations

3. **object-metadata**: Metadata system
   - Object definitions
   - Field definitions
   - Schema management

4. **views**: View management
   - Table views
   - Kanban views
   - Filters, sorting, grouping

5. **activities**: Activity tracking
   - Tasks, notes, emails
   - Activity timeline
   - Activity notifications

6. **workflow**: Workflow automation
   - Workflow builder
   - Trigger configuration
   - Action execution

7. **settings**: Settings management
   - Workspace settings
   - User settings
   - Integration settings

8. **ui**: UI component library
   - Display components (chips, tags, icons)
   - Input components (buttons, forms, fields)
   - Navigation components (menus, breadcrumbs)
   - Data components (tables, lists)
   - Layout components (pages, sections)

### State Management

**Recoil** is used for global state management with the following patterns:

- **Atoms**: Single source of truth for state
- **Selectors**: Derived state and computations
- **Component-scoped state**: Recoil state with component IDs
- **Atom families**: Dynamic collections of atoms

Example state structure:
```typescript
// Atom for current user
const currentUserState = atom({
  key: 'currentUserState',
  default: null,
});

// Selector for user permissions
const userPermissionsSelector = selector({
  key: 'userPermissionsSelector',
  get: ({ get }) => {
    const user = get(currentUserState);
    return computePermissions(user);
  },
});
```

### GraphQL Integration

The frontend uses Apollo Client for GraphQL:

- **Code generation**: Automatic TypeScript types from schema
- **Queries**: Fetching data with caching
- **Mutations**: Updating data
- **Subscriptions**: Real-time updates
- **Optimistic updates**: Instant UI feedback

### Routing

React Router v6 is used for routing with nested routes:

```
/                           # Home (redirects to index)
/objects/:objectNamePlural  # Object list view
/object/:objectNameSingular/:objectRecordId  # Record detail
/settings/*                 # Settings pages
/auth/*                     # Authentication pages
/onboarding/*              # Onboarding flow
```

### Styling

**Emotion** is used for CSS-in-JS styling:

- Styled components pattern
- Theme support (light/dark mode)
- Responsive design
- Consistent spacing and typography

---

## Backend Architecture (twenty-server)

The backend is built with NestJS, providing a robust and scalable API layer.

### Directory Structure

```
twenty-server/
├── src/
│   ├── engine/                  # Core engine modules
│   │   ├── core-modules/       # Core functionality
│   │   │   ├── auth/           # Authentication
│   │   │   ├── user/           # User management
│   │   │   ├── workspace/      # Workspace management
│   │   │   ├── billing/        # Billing integration
│   │   │   └── ...
│   │   ├── metadata-modules/   # Metadata system
│   │   │   ├── object-metadata/ # Object definitions
│   │   │   ├── field-metadata/  # Field definitions
│   │   │   └── relation-metadata/ # Relations
│   │   ├── workspace-manager/  # Workspace isolation
│   │   ├── workspace-datasource/ # Dynamic data sources
│   │   └── api/                # API layer
│   ├── modules/                 # Business logic modules
│   │   ├── messaging/          # Email integration
│   │   ├── calendar/           # Calendar integration
│   │   ├── workflow/           # Workflow engine
│   │   ├── connected-account/  # Account connections
│   │   └── ...
│   ├── database/               # Database layer
│   │   ├── typeorm/            # TypeORM configuration
│   │   └── typeorm-seeds/      # Database seeds
│   ├── queue-worker/           # Background job worker
│   ├── command/                # CLI commands
│   ├── filters/                # Exception filters
│   ├── utils/                  # Utility functions
│   └── app.module.ts           # Root module
├── test/                        # Integration tests
└── package.json                 # Package configuration
```

### Core Architecture Concepts

#### 1. Workspace Isolation

Each workspace (tenant) has:
- Isolated database schema
- Separate GraphQL schema
- Independent metadata
- Isolated data

```
┌─────────────────────────────────────────┐
│         PostgreSQL Database             │
├─────────────────────────────────────────┤
│  Core Schema (core)                     │
│  - users, workspaces, auth              │
├─────────────────────────────────────────┤
│  Metadata Schema (metadata)             │
│  - object definitions                   │
│  - field definitions                    │
├─────────────────────────────────────────┤
│  Workspace Schema 1 (workspace_xxx)     │
│  - companies, people, opportunities     │
├─────────────────────────────────────────┤
│  Workspace Schema 2 (workspace_yyy)     │
│  - companies, people, opportunities     │
└─────────────────────────────────────────┘
```

#### 2. Dynamic GraphQL Schema

The GraphQL schema is generated dynamically per workspace based on metadata:

```typescript
// Metadata defines objects and fields
const personMetadata = {
  nameSingular: 'person',
  namePlural: 'people',
  fields: [
    { name: 'firstName', type: 'TEXT' },
    { name: 'lastName', type: 'TEXT' },
    { name: 'email', type: 'EMAIL' },
  ],
};

// Generated GraphQL schema
type Person {
  id: ID!
  firstName: String
  lastName: String
  email: String
  createdAt: DateTime!
  updatedAt: DateTime!
}

type Query {
  person(id: ID!): Person
  people(filter: PersonFilterInput, orderBy: [PersonOrderByInput]): [Person]
}

type Mutation {
  createPerson(data: PersonCreateInput!): Person
  updatePerson(id: ID!, data: PersonUpdateInput!): Person
  deletePerson(id: ID!): Person
}
```

#### 3. Metadata System

The metadata system defines the data model:

- **Object Metadata**: Defines entities (tables)
- **Field Metadata**: Defines fields (columns)
- **Relation Metadata**: Defines relationships

#### 4. Background Jobs

BullMQ is used for background job processing:

- Email sync jobs
- Calendar sync jobs
- Workflow execution
- Data import/export
- Analytics computation

### Key Backend Modules

1. **engine/core-modules/auth**: Authentication system
   - JWT token management
   - OAuth providers (Google, Microsoft)
   - API key authentication
   - Workspace access control

2. **engine/core-modules/workspace**: Workspace management
   - Workspace creation
   - Member management
   - Workspace settings

3. **engine/metadata-modules**: Metadata management
   - Dynamic object creation
   - Field type system
   - Relation management
   - Schema migration

4. **modules/messaging**: Email integration
   - Gmail sync
   - Outlook sync
   - Email threading
   - Email search

5. **modules/calendar**: Calendar integration
   - Google Calendar sync
   - Outlook Calendar sync
   - Event management

6. **modules/workflow**: Workflow automation
   - Trigger system
   - Action execution
   - Workflow versioning

### API Layer

#### GraphQL API
- Dynamic schema per workspace
- Query complexity analysis
- Field-level authorization
- Dataloader for batching

#### REST API
- Webhook endpoints
- Integration endpoints
- Legacy compatibility

### Database Layer

**PostgreSQL** is used with TypeORM:

- Multi-schema architecture
- Migration system
- Connection pooling
- Query optimization

**Redis** is used for:

- Session storage
- GraphQL response caching
- Rate limiting
- Job queue

---

## Technology Stack

### Frontend Technologies

| Technology | Purpose | Version |
|------------|---------|---------|
| **React** | UI framework | 18.x |
| **TypeScript** | Type safety | 5.x |
| **Recoil** | State management | Latest |
| **Emotion** | CSS-in-JS styling | Latest |
| **Apollo Client** | GraphQL client | Latest |
| **React Router** | Routing | 6.x |
| **Vite** | Build tool | Latest |
| **Lingui** | Internationalization | Latest |
| **React Email** | Email templates | Latest |
| **Storybook** | Component documentation | Latest |

### Backend Technologies

| Technology | Purpose | Version |
|------------|---------|---------|
| **NestJS** | Backend framework | 10.x |
| **TypeScript** | Type safety | 5.x |
| **TypeORM** | Database ORM | Latest |
| **GraphQL Yoga** | GraphQL server | Latest |
| **PostgreSQL** | Primary database | 14+ |
| **Redis** | Cache & sessions | Latest |
| **BullMQ** | Job queue | Latest |
| **Passport** | Authentication | Latest |
| **Jest** | Testing framework | Latest |

### Development Tools

| Tool | Purpose |
|------|---------|
| **Nx** | Monorepo management |
| **Yarn 4** | Package manager |
| **ESLint** | Code linting |
| **Prettier** | Code formatting |
| **Playwright** | E2E testing |
| **Docker** | Containerization |
| **GitHub Actions** | CI/CD |

---

## Key Modules and Features

### 1. Object & Field Management

The metadata system allows users to create custom objects and fields:

- **Standard Objects**: Companies, People, Opportunities
- **Custom Objects**: User-defined entities
- **Field Types**: Text, Number, Date, Select, Relation, etc.
- **Relations**: One-to-Many, Many-to-One, Many-to-Many

### 2. Views & Filters

Flexible data presentation:

- **View Types**: Table, Kanban, Calendar (upcoming)
- **Filters**: Multi-level filtering with AND/OR logic
- **Sorting**: Multi-column sorting
- **Grouping**: Group by any field
- **Saved Views**: Personal and shared views

### 3. Activities

Comprehensive activity tracking:

- **Tasks**: To-do items with due dates
- **Notes**: Free-form notes
- **Emails**: Integrated email tracking
- **Timeline**: Chronological activity feed

### 4. Workflow Automation

Automate business processes:

- **Triggers**: Record events, scheduled, webhook
- **Actions**: Update record, send email, webhook, code
- **Conditions**: Filter execution
- **Versioning**: Workflow version history

### 5. Permissions & Roles

Fine-grained access control:

- **Role-Based Access**: Admin, Member, Custom
- **Object-Level Permissions**: CRUD per object
- **Field-Level Permissions**: Read/Write per field
- **Workspace Isolation**: Complete data separation

### 6. Integrations

Connect with external services:

- **Email**: Gmail, Outlook
- **Calendar**: Google Calendar, Outlook Calendar
- **Zapier**: 5000+ app integrations
- **Webhooks**: Custom integrations
- **API**: GraphQL & REST APIs

### 7. Search

Powerful search capabilities:

- **Full-text search**: Across all objects
- **Quick search**: Command-K interface
- **Recent items**: Quick access
- **Favorites**: Bookmark records

---

## Development Workflow

### Getting Started

```bash
# Clone the repository
git clone https://github.com/twentyhq/twenty.git
cd twenty

# Install dependencies
yarn install

# Start development environment
yarn start
```

This starts:
- Frontend dev server (http://localhost:3001)
- Backend API server (http://localhost:3000)
- Background worker
- PostgreSQL (via Docker)
- Redis (via Docker)

### Development Commands

#### Frontend
```bash
# Start frontend dev server
npx nx start twenty-front

# Run frontend tests
npx nx test twenty-front

# Run frontend linting
npx nx lint twenty-front

# Fix linting issues
npx nx lint twenty-front --fix

# Build frontend
npx nx build twenty-front

# Run Storybook
npx nx storybook:dev twenty-front

# Generate GraphQL types
npx nx run twenty-front:graphql:generate
```

#### Backend
```bash
# Start backend server
npx nx start twenty-server

# Start background worker
npx nx run twenty-server:worker

# Run backend tests
npx nx test twenty-server

# Run integration tests
npx nx run twenty-server:test:integration:with-db-reset

# Run backend linting
npx nx lint twenty-server

# Build backend
npx nx build twenty-server

# Database commands
npx nx database:reset twenty-server
npx nx run twenty-server:database:migrate:prod
npx nx run twenty-server:command workspace:sync-metadata -f
```

#### Testing
```bash
# Run all tests
npx nx run-many -t test

# Run E2E tests
npx nx e2e twenty-e2e-testing

# Run Storybook tests
npx nx storybook:serve-and-test:static twenty-front
```

#### Code Quality
```bash
# Lint all packages
npx nx run-many -t lint

# Format all packages
npx nx run-many -t fmt

# Type check all packages
npx nx run-many -t typecheck
```

### Project Structure Best Practices

#### Frontend Module Guidelines

1. **Functional components only** - no class components
2. **Named exports only** - no default exports
3. **Types over interfaces** - except when extending third-party
4. **Event handlers over useEffect** - for state updates
5. **No 'any' type allowed** - always use proper types

#### Backend Module Guidelines

1. **Modular architecture** - features in separate modules
2. **Dependency injection** - use NestJS DI
3. **DTOs for validation** - input validation with class-validator
4. **Repository pattern** - for data access
5. **Service layer** - business logic in services

### Testing Strategy

1. **Unit Tests**: Test individual functions/components
   - Frontend: Jest + React Testing Library
   - Backend: Jest

2. **Integration Tests**: Test module interactions
   - Backend: Jest with database
   - API endpoint testing

3. **E2E Tests**: Test complete user flows
   - Playwright for browser automation
   - Critical user journeys

4. **Storybook Tests**: Visual component testing
   - Component stories
   - Interaction testing
   - Visual regression

### CI/CD Pipeline

GitHub Actions automate:
- **Linting**: ESLint + Prettier
- **Type checking**: TypeScript compilation
- **Testing**: Unit, integration, E2E
- **Building**: Production builds
- **Deployment**: Automated deployments

---

## Additional Resources

### Documentation
- [Official Documentation](https://twenty.com/developers)
- [Local Setup Guide](https://twenty.com/developers/local-setup)
- [Self-Hosting Guide](https://twenty.com/developers/section/self-hosting)
- [Frontend Development](https://twenty.com/developers/frontend-development)
- [Backend Development](https://twenty.com/developers/backend-development)

### Community
- [Discord Server](https://discord.gg/cx5n4Jzs57)
- [GitHub Discussions](https://github.com/twentyhq/twenty/discussions)
- [Contributing Guide](https://github.com/twentyhq/twenty/blob/main/.github/CONTRIBUTING.md)

### Design
- [Figma Design Files](https://www.figma.com/file/xt8O9mFeLl46C5InWwoMrN/Twenty)
- [UI Component Library](https://twenty.com/twenty-ui)

### API
- [GraphQL API Documentation](https://twenty.com/developers/graphql-apis)
- [REST API Documentation](https://twenty.com/developers/rest-apis)
- [Webhooks Documentation](https://twenty.com/developers/api-and-webhooks)

---

## Architecture Diagrams

### Data Flow Architecture

```
┌──────────────┐
│   Browser    │
└──────┬───────┘
       │ HTTP/WebSocket
       ▼
┌──────────────────────────────────────────────┐
│          Frontend (twenty-front)              │
│  ┌────────────────────────────────────────┐  │
│  │  React Components + Recoil State       │  │
│  └────────────────────────────────────────┘  │
│  ┌────────────────────────────────────────┐  │
│  │  Apollo Client (GraphQL)               │  │
│  └────────────────────────────────────────┘  │
└──────────────┬───────────────────────────────┘
               │ GraphQL/REST
               ▼
┌──────────────────────────────────────────────┐
│          Backend (twenty-server)              │
│  ┌────────────────────────────────────────┐  │
│  │  NestJS Controllers & Resolvers        │  │
│  └────────────────────────────────────────┘  │
│  ┌────────────────────────────────────────┐  │
│  │  Business Logic Services               │  │
│  └────────────────────────────────────────┘  │
│  ┌────────────────────────────────────────┐  │
│  │  TypeORM Repository Layer              │  │
│  └────────────────────────────────────────┘  │
└──────────────┬───────────────────────────────┘
               │
      ┌────────┴────────┐
      │                 │
      ▼                 ▼
┌─────────────┐   ┌──────────┐
│ PostgreSQL  │   │  Redis   │
│  Database   │   │  Cache   │
└─────────────┘   └──────────┘
```

### Workspace Architecture

```
┌─────────────────────────────────────────────────────┐
│               Request Flow                           │
└─────────────────────────────────────────────────────┘

User Request → Authentication → Workspace Context
                                       │
                ┌──────────────────────┼────────────────────┐
                │                      │                    │
                ▼                      ▼                    ▼
         ┌──────────┐           ┌──────────┐        ┌──────────┐
         │ Metadata │           │  Schema  │        │   Data   │
         │  Schema  │           │ Generator│        │  Schema  │
         └──────────┘           └──────────┘        └──────────┘
                │                      │                    │
                └──────────────────────┼────────────────────┘
                                       ▼
                              ┌─────────────────┐
                              │  GraphQL Schema │
                              │  (Workspace)    │
                              └─────────────────┘
                                       │
                                       ▼
                              Execute Query/Mutation
```

### Module Dependency Graph

```
┌──────────────────────────────────────────────┐
│          Core Modules (twenty-shared)        │
│  - Types, Interfaces, Constants              │
└──────────────┬───────────────────────────────┘
               │
      ┌────────┴────────┐
      │                 │
      ▼                 ▼
┌─────────────┐   ┌─────────────┐
│  twenty-ui  │   │twenty-server│
│ Components  │   │   Engine    │
└──────┬──────┘   └──────┬──────┘
       │                 │
       │                 │
       ▼                 ▼
┌─────────────┐   ┌─────────────┐
│ twenty-front│   │   Business  │
│   Modules   │   │   Modules   │
└─────────────┘   └─────────────┘
```

---

## Conclusion

Twenty is a comprehensive, modern CRM platform built with scalability, extensibility, and developer experience in mind. The monorepo architecture with Nx provides excellent organization, the React + NestJS stack delivers performance and type safety, and the dynamic metadata system enables unlimited customization.

Whether you're contributing to the project or deploying your own instance, this documentation should give you a solid understanding of how Twenty works under the hood.

For more detailed information on specific topics, refer to the [Additional Resources](#additional-resources) section.
