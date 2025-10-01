# Twenty Backend Architecture Documentation

## Table of Contents
1. [Overview](#overview)
2. [Technology Stack](#technology-stack)
3. [Project Structure](#project-structure)
4. [Architecture Patterns](#architecture-patterns)
5. [Core Engine](#core-engine)
6. [Metadata System](#metadata-system)
7. [Workspace Architecture](#workspace-architecture)
8. [GraphQL API Layer](#graphql-api-layer)
9. [Database Layer](#database-layer)
10. [Background Jobs](#background-jobs)
11. [Key Business Modules](#key-business-modules)
12. [Development Guidelines](#development-guidelines)

---

## Overview

The Twenty backend (`twenty-server`) is a sophisticated NestJS application that provides a robust, scalable, and flexible API layer for the Twenty CRM platform. It implements a multi-tenant architecture with dynamic schema generation, comprehensive metadata management, and powerful workflow capabilities.

### Key Characteristics

- **Multi-Tenant**: Complete workspace isolation with separate schemas
- **Dynamic**: GraphQL schema generated from metadata
- **Type-Safe**: Full TypeScript coverage
- **Scalable**: Horizontal scaling with Redis and PostgreSQL
- **Extensible**: Plugin architecture for custom functionality
- **Secure**: Role-based access control and field-level permissions

---

## Technology Stack

### Core Technologies

```
NestJS 10.x             # Backend Framework
├── TypeScript 5.x      # Type System
├── TypeORM             # Database ORM
├── GraphQL Yoga        # GraphQL Server
└── Class Validator     # Input Validation

PostgreSQL 14+          # Primary Database
Redis                   # Cache & Session Store
BullMQ                  # Job Queue System
```

### Key Libraries

```
Authentication:
├── Passport.js         # Auth middleware
├── JWT                 # Token-based auth
└── OAuth2              # Third-party auth

Data Processing:
├── BullMQ              # Background jobs
├── TypeORM             # ORM
└── DataLoader          # Batch loading

Integration:
├── Google APIs         # Gmail, Calendar
├── Microsoft Graph     # Outlook
└── Stripe              # Payments
```

---

## Project Structure

```
twenty-server/
├── src/
│   ├── engine/                      # Core engine (main architecture)
│   │   ├── core-modules/           # Core functionality modules
│   │   │   ├── auth/               # Authentication & authorization
│   │   │   ├── user/               # User management
│   │   │   ├── workspace/          # Workspace management
│   │   │   ├── workspace-member/   # Member management
│   │   │   ├── billing/            # Billing & subscriptions
│   │   │   ├── feature-flag/       # Feature flags
│   │   │   ├── file/               # File storage
│   │   │   ├── analytics/          # Analytics tracking
│   │   │   ├── api-key/            # API key management
│   │   │   └── webhook/            # Webhook management
│   │   ├── metadata-modules/       # Metadata system
│   │   │   ├── object-metadata/    # Object definitions
│   │   │   ├── field-metadata/     # Field definitions
│   │   │   ├── relation-metadata/  # Relation definitions
│   │   │   ├── data-source/        # Data source management
│   │   │   └── workspace-migration/ # Schema migrations
│   │   ├── workspace-manager/      # Workspace management
│   │   │   ├── workspace-sync-metadata/ # Metadata sync
│   │   │   └── workspace-migration-runner/ # Migration execution
│   │   ├── api/                    # API layer
│   │   │   ├── graphql/            # GraphQL API
│   │   │   └── rest/               # REST API
│   │   ├── workspace-datasource/   # Dynamic data sources
│   │   └── workspace-resolver-builder/ # Dynamic resolvers
│   ├── modules/                     # Business logic modules
│   │   ├── messaging/              # Email integration
│   │   │   ├── message-import-manager/ # Email sync
│   │   │   ├── message-participant/ # Email participants
│   │   │   └── message-thread/     # Email threading
│   │   ├── calendar/               # Calendar integration
│   │   │   ├── calendar-event-import-manager/ # Event sync
│   │   │   └── calendar-event/     # Event management
│   │   ├── connected-account/      # Third-party accounts
│   │   ├── workflow/               # Workflow automation
│   │   │   ├── workflow-runner/    # Workflow execution
│   │   │   ├── workflow-trigger/   # Trigger system
│   │   │   └── workflow-action/    # Action system
│   │   ├── view/                   # View system
│   │   ├── favorite/               # Favorites
│   │   └── favorite-folder/        # Favorite folders
│   ├── database/                    # Database layer
│   │   ├── typeorm/                # TypeORM config
│   │   │   ├── core/               # Core schema
│   │   │   │   ├── migrations/     # Core migrations
│   │   │   │   └── core.datasource.ts # Core connection
│   │   │   └── metadata/           # Metadata schema
│   │   │       ├── migrations/     # Metadata migrations
│   │   │       └── metadata.datasource.ts # Metadata connection
│   │   └── typeorm-seeds/          # Database seeds
│   ├── queue-worker/               # Background worker
│   │   ├── queues/                 # Queue definitions
│   │   └── jobs/                   # Job handlers
│   ├── command/                     # CLI commands
│   │   ├── database/               # Database commands
│   │   └── workspace/              # Workspace commands
│   ├── filters/                     # Exception filters
│   ├── utils/                       # Utility functions
│   └── app.module.ts               # Root module
├── test/                            # Integration tests
│   └── integration/                # Integration test suites
└── package.json                     # Dependencies
```

---

## Architecture Patterns

### Layered Architecture

```
┌─────────────────────────────────────────────┐
│            API Layer (GraphQL/REST)          │
│  - Request validation                        │
│  - Authentication/Authorization              │
│  - Response formatting                       │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│            Service Layer                     │
│  - Business logic                            │
│  - Transaction management                    │
│  - Integration orchestration                 │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│          Repository Layer (TypeORM)          │
│  - Data access                               │
│  - Query building                            │
│  - Cache management                          │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│         Database Layer (PostgreSQL)          │
│  - Data persistence                          │
│  - Transactions                              │
│  - Constraints                               │
└─────────────────────────────────────────────┘
```

### Module Architecture

```
NestJS Module Structure:

@Module({
  imports: [
    // Dependencies
    TypeOrmModule.forFeature([Entity]),
    OtherModule,
  ],
  controllers: [
    // REST controllers
    EntityController,
  ],
  providers: [
    // Services
    EntityService,
    // Resolvers (GraphQL)
    EntityResolver,
    // Repositories
    EntityRepository,
  ],
  exports: [
    // Exported services
    EntityService,
  ],
})
export class EntityModule {}
```

---

## Core Engine

The engine is the heart of Twenty's architecture, providing core functionality:

### Core Modules

#### 1. Auth Module (`engine/core-modules/auth`)

**Purpose**: Authentication and authorization

**Key Components:**
- `AuthService`: Main authentication logic
- `TokenService`: JWT token management
- `AuthResolver`: GraphQL auth endpoints
- `JwtAuthGuard`: Route protection

**Features:**
- Email/password authentication
- OAuth (Google, Microsoft)
- JWT token generation/validation
- Refresh token rotation
- API key authentication

**Flow:**
```
Login Request
    │
    ▼
AuthResolver.signIn()
    │
    ▼
AuthService.validateUser()
    │
    ├─► Verify credentials
    └─► Generate tokens
        │
        ▼
    Return { accessToken, refreshToken }
```

#### 2. User Module (`engine/core-modules/user`)

**Purpose**: User management

**Entities:**
```typescript
@Entity()
class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  email: string;

  @Column({ nullable: true })
  firstName: string;

  @Column({ nullable: true })
  lastName: string;

  @Column({ nullable: true })
  passwordHash: string;

  @ManyToOne(() => Workspace)
  defaultWorkspace: Workspace;

  @OneToMany(() => WorkspaceMember, member => member.user)
  workspaceMembers: WorkspaceMember[];
}
```

#### 3. Workspace Module (`engine/core-modules/workspace`)

**Purpose**: Multi-tenant workspace management

**Key Features:**
- Workspace creation
- Schema provisioning
- Workspace settings
- Member invitation
- Workspace deletion

**Workspace Creation Flow:**
```
1. Create workspace record (core schema)
2. Create PostgreSQL schema (workspace_xxx)
3. Run metadata migrations
4. Sync standard objects
5. Create default data (views, etc.)
6. Add creator as admin member
```

#### 4. Billing Module (`engine/core-modules/billing`)

**Purpose**: Subscription and billing management

**Integration:** Stripe

**Features:**
- Subscription management
- Payment processing
- Plan upgrades/downgrades
- Usage tracking
- Billing portal

---

## Metadata System

The metadata system is what makes Twenty flexible and extensible.

### Metadata Architecture

```
┌─────────────────────────────────────────────┐
│         Metadata Schema (metadata)           │
├─────────────────────────────────────────────┤
│                                              │
│  ┌──────────────────────────────────────┐  │
│  │   Object Metadata                     │  │
│  │   - nameSingular: 'company'          │  │
│  │   - namePlural: 'companies'          │  │
│  │   - labelSingular: 'Company'         │  │
│  │   - isSystem: false                  │  │
│  └──────────────────┬───────────────────┘  │
│                     │                       │
│  ┌──────────────────▼───────────────────┐  │
│  │   Field Metadata                      │  │
│  │   - name: 'name'                     │  │
│  │   - type: 'TEXT'                     │  │
│  │   - label: 'Name'                    │  │
│  │   - isNullable: false                │  │
│  └──────────────────┬───────────────────┘  │
│                     │                       │
│  ┌──────────────────▼───────────────────┐  │
│  │   Relation Metadata                   │  │
│  │   - relationType: 'ONE_TO_MANY'      │  │
│  │   - fromObjectId: xxx                │  │
│  │   - toObjectId: yyy                  │  │
│  └──────────────────────────────────────┘  │
│                                              │
└─────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────┐
│      Schema Generator                        │
│  - Generates GraphQL types                   │
│  - Generates database tables                 │
│  - Generates resolvers                       │
└─────────────────────────────────────────────┘
```

### Object Metadata

```typescript
@Entity()
class ObjectMetadata {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  nameSingular: string;

  @Column()
  namePlural: string;

  @Column()
  labelSingular: string;

  @Column()
  labelPlural: string;

  @Column()
  description: string;

  @Column({ nullable: true })
  icon: string;

  @Column({ default: false })
  isSystem: boolean;

  @Column({ default: true })
  isActive: boolean;

  @OneToMany(() => FieldMetadata, field => field.object)
  fields: FieldMetadata[];

  @ManyToOne(() => Workspace)
  workspace: Workspace;
}
```

### Field Metadata

```typescript
@Entity()
class FieldMetadata {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column()
  label: string;

  @Column()
  type: FieldMetadataType;

  @Column({ type: 'jsonb', nullable: true })
  options: Record<string, any>;

  @Column({ default: false })
  isNullable: boolean;

  @Column({ default: false })
  isSystem: boolean;

  @Column({ default: true })
  isActive: boolean;

  @ManyToOne(() => ObjectMetadata, object => object.fields)
  object: ObjectMetadata;
}
```

### Field Types

```typescript
enum FieldMetadataType {
  UUID = 'UUID',
  TEXT = 'TEXT',
  PHONE = 'PHONE',
  EMAIL = 'EMAIL',
  NUMERIC = 'NUMERIC',
  NUMBER = 'NUMBER',
  BOOLEAN = 'BOOLEAN',
  DATE_TIME = 'DATE_TIME',
  DATE = 'DATE',
  SELECT = 'SELECT',
  MULTI_SELECT = 'MULTI_SELECT',
  CURRENCY = 'CURRENCY',
  LINK = 'LINK',
  LINKS = 'LINKS',
  FULL_NAME = 'FULL_NAME',
  ADDRESS = 'ADDRESS',
  RATING = 'RATING',
  RELATION = 'RELATION',
  RICH_TEXT = 'RICH_TEXT',
}
```

### Metadata Sync Process

When objects/fields are created or modified:

```
1. Update metadata tables
    │
    ▼
2. Generate migration SQL
    │
    ▼
3. Execute migration
    │
    ▼
4. Regenerate GraphQL schema
    │
    ▼
5. Update resolvers
    │
    ▼
6. Clear cache
    │
    ▼
7. Notify clients (if needed)
```

---

## Workspace Architecture

### Multi-Schema Design

Each workspace has its own PostgreSQL schema:

```sql
-- Core schema (shared)
CREATE SCHEMA core;
CREATE TABLE core.users (...);
CREATE TABLE core.workspaces (...);

-- Metadata schema (shared)
CREATE SCHEMA metadata;
CREATE TABLE metadata.object_metadata (...);
CREATE TABLE metadata.field_metadata (...);

-- Workspace 1 schema
CREATE SCHEMA workspace_abc123;
CREATE TABLE workspace_abc123.companies (...);
CREATE TABLE workspace_abc123.people (...);

-- Workspace 2 schema
CREATE SCHEMA workspace_def456;
CREATE TABLE workspace_def456.companies (...);
CREATE TABLE workspace_def456.people (...);
```

### Workspace Datasource

Dynamic datasource creation per workspace:

```typescript
@Injectable()
class WorkspaceDatasourceFactory {
  async createDatasource(workspaceId: string): Promise<DataSource> {
    const workspace = await this.findWorkspace(workspaceId);
    
    return new DataSource({
      type: 'postgres',
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT),
      username: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      schema: `workspace_${workspace.id}`,
      entities: await this.buildEntities(workspace),
    });
  }
}
```

### Workspace Context

Request context with workspace information:

```typescript
// Workspace interceptor
@Injectable()
class WorkspaceInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler) {
    const request = context.switchToHttp().getRequest();
    const workspaceId = this.extractWorkspaceId(request);
    
    request.workspace = await this.workspaceService.findById(workspaceId);
    
    return next.handle();
  }
}

// Usage in resolver
@Query(() => [Company])
async companies(@CurrentWorkspace() workspace: Workspace) {
  const datasource = await this.datasourceFactory.create(workspace.id);
  return datasource.getRepository(Company).find();
}
```

---

## GraphQL API Layer

### Dynamic Schema Generation

Schema is generated from metadata at runtime:

```typescript
class WorkspaceSchemaFactory {
  async createSchema(workspaceId: string): Promise<GraphQLSchema> {
    const objectMetadataCollection = await this.getObjectMetadata(workspaceId);
    
    // Generate types
    const types = objectMetadataCollection.map(object => 
      this.generateType(object)
    );
    
    // Generate queries
    const queries = objectMetadataCollection.map(object => ({
      [object.nameSingular]: this.generateFindOneQuery(object),
      [object.namePlural]: this.generateFindManyQuery(object),
    }));
    
    // Generate mutations
    const mutations = objectMetadataCollection.map(object => ({
      [`create${capitalize(object.nameSingular)}`]: this.generateCreateMutation(object),
      [`update${capitalize(object.nameSingular)}`]: this.generateUpdateMutation(object),
      [`delete${capitalize(object.nameSingular)}`]: this.generateDeleteMutation(object),
    }));
    
    return makeExecutableSchema({
      typeDefs: buildTypeDefs(types, queries, mutations),
      resolvers: buildResolvers(objectMetadataCollection),
    });
  }
}
```

### Generated Schema Example

```graphql
type Company {
  id: ID!
  name: String!
  domainName: String
  employees: Int
  address: Address
  createdAt: DateTime!
  updatedAt: DateTime!
  deletedAt: DateTime
  
  # Relations
  people: [Person!]!
  opportunities: [Opportunity!]!
}

type Query {
  company(id: ID!): Company
  companies(
    filter: CompanyFilterInput
    orderBy: [CompanyOrderByInput!]
    limit: Int
    offset: Int
  ): [Company!]!
}

type Mutation {
  createCompany(data: CompanyCreateInput!): Company!
  updateCompany(id: ID!, data: CompanyUpdateInput!): Company!
  deleteCompany(id: ID!): Company!
}

input CompanyFilterInput {
  and: [CompanyFilterInput!]
  or: [CompanyFilterInput!]
  name: StringFilterInput
  employees: IntFilterInput
}

input CompanyCreateInput {
  name: String!
  domainName: String
  employees: Int
}

input CompanyUpdateInput {
  name: String
  domainName: String
  employees: Int
}
```

### Resolver Generation

Resolvers are dynamically created:

```typescript
class WorkspaceResolverFactory {
  generateFindManyResolver(objectMetadata: ObjectMetadata) {
    return async (parent, args, context) => {
      const { filter, orderBy, limit, offset } = args;
      
      const queryBuilder = this.buildQuery(
        objectMetadata,
        filter,
        orderBy,
        context.workspace
      );
      
      if (limit) queryBuilder.take(limit);
      if (offset) queryBuilder.skip(offset);
      
      return queryBuilder.getMany();
    };
  }
  
  generateCreateResolver(objectMetadata: ObjectMetadata) {
    return async (parent, args, context) => {
      const { data } = args;
      
      const repository = this.getRepository(objectMetadata, context.workspace);
      const entity = repository.create(data);
      
      return repository.save(entity);
    };
  }
}
```

### Query Complexity

Prevent expensive queries:

```typescript
const complexityPlugin = {
  plugin: {
    requestDidStart() {
      return {
        didResolveOperation({ request, document }) {
          const complexity = getComplexity({
            schema,
            query: document,
            variables: request.variables,
            estimators: [
              fieldExtensionsEstimator(),
              simpleEstimator({ defaultComplexity: 1 }),
            ],
          });
          
          if (complexity > MAX_COMPLEXITY) {
            throw new GraphQLError(
              `Query is too complex: ${complexity}. Maximum allowed: ${MAX_COMPLEXITY}`
            );
          }
        },
      };
    },
  },
};
```

---

## Database Layer

### TypeORM Configuration

```typescript
// Core datasource
export const CoreDataSource = new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT),
  username: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  schema: 'core',
  entities: [User, Workspace, WorkspaceMember],
  migrations: ['src/database/typeorm/core/migrations/*.ts'],
});

// Metadata datasource
export const MetadataDataSource = new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT),
  username: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  schema: 'metadata',
  entities: [ObjectMetadata, FieldMetadata, RelationMetadata],
  migrations: ['src/database/typeorm/metadata/migrations/*.ts'],
});
```

### Migrations

```typescript
// Generate migration
// npx nx run twenty-server:typeorm migration:generate src/database/typeorm/core/migrations/AddNewField -d src/database/typeorm/core/core.datasource.ts

// Migration example
export class AddNewField1234567890 implements MigrationInterface {
  name = 'AddNewField1234567890';

  async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "core"."users" 
      ADD COLUMN "phoneNumber" varchar(255)
    `);
  }

  async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "core"."users" 
      DROP COLUMN "phoneNumber"
    `);
  }
}
```

### Repository Pattern

```typescript
@Injectable()
class CompanyService {
  constructor(
    @InjectRepository(Company, 'workspace')
    private companyRepository: Repository<Company>,
  ) {}

  async findAll(filter?: CompanyFilter): Promise<Company[]> {
    const queryBuilder = this.companyRepository.createQueryBuilder('company');
    
    if (filter?.name) {
      queryBuilder.andWhere('company.name ILIKE :name', {
        name: `%${filter.name}%`,
      });
    }
    
    return queryBuilder.getMany();
  }

  async create(data: CreateCompanyDto): Promise<Company> {
    const company = this.companyRepository.create(data);
    return this.companyRepository.save(company);
  }
}
```

### Query Optimization

```typescript
// Use DataLoader for N+1 prevention
class CompanyDataLoader {
  private loader: DataLoader<string, Company>;

  constructor(private companyService: CompanyService) {
    this.loader = new DataLoader(async (ids: string[]) => {
      const companies = await this.companyService.findByIds(ids);
      return ids.map(id => companies.find(c => c.id === id));
    });
  }

  load(id: string): Promise<Company> {
    return this.loader.load(id);
  }
}

// Resolver with DataLoader
@ResolveField(() => Company)
async company(@Parent() person: Person) {
  return this.companyDataLoader.load(person.companyId);
}
```

---

## Background Jobs

### BullMQ Architecture

```
┌─────────────────────────────────────────────┐
│            API Server (Producer)             │
│  - Enqueue jobs                              │
│  - Monitor job status                        │
└──────────────────┬──────────────────────────┘
                   │ Redis
                   ▼
┌─────────────────────────────────────────────┐
│              Redis (Queue)                   │
│  - Job persistence                           │
│  - Job scheduling                            │
│  - Job status                                │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────┐
│          Worker Process (Consumer)           │
│  - Process jobs                              │
│  - Handle retries                            │
│  - Report progress                           │
└─────────────────────────────────────────────┘
```

### Queue Definition

```typescript
// Queue registration
@Module({
  imports: [
    BullModule.registerQueue(
      { name: 'messaging' },
      { name: 'calendar' },
      { name: 'workflow' },
    ),
  ],
})
export class JobModule {}
```

### Job Producer

```typescript
@Injectable()
class MessagingService {
  constructor(
    @InjectQueue('messaging')
    private messagingQueue: Queue,
  ) {}

  async syncMessages(connectedAccountId: string): Promise<void> {
    await this.messagingQueue.add('sync-messages', {
      connectedAccountId,
    }, {
      attempts: 3,
      backoff: {
        type: 'exponential',
        delay: 2000,
      },
    });
  }
}
```

### Job Consumer

```typescript
@Processor('messaging')
class MessagingProcessor {
  constructor(
    private messagingImportService: MessagingImportService,
  ) {}

  @Process('sync-messages')
  async handleSyncMessages(job: Job<{ connectedAccountId: string }>) {
    const { connectedAccountId } = job.data;
    
    // Update progress
    await job.progress(10);
    
    // Process messages
    const messages = await this.messagingImportService.fetchMessages(
      connectedAccountId
    );
    
    await job.progress(50);
    
    await this.messagingImportService.importMessages(messages);
    
    await job.progress(100);
    
    return { imported: messages.length };
  }

  @OnQueueError()
  onError(error: Error) {
    console.error('Queue error:', error);
  }

  @OnQueueFailed()
  onFailed(job: Job, error: Error) {
    console.error(`Job ${job.id} failed:`, error);
  }
}
```

---

## Key Business Modules

### 1. Messaging Module

**Purpose**: Email integration and sync

**Features:**
- Gmail sync
- Outlook sync
- Email threading
- Email search
- Participant extraction

**Architecture:**
```
MessagingModule
├── MessageImportManager
│   ├── Fetch emails from provider
│   ├── Parse email content
│   └── Store in database
├── MessageThreading
│   ├── Detect thread relationships
│   └── Group messages
└── MessageParticipant
    ├── Extract participants
    └── Link to contacts
```

### 2. Calendar Module

**Purpose**: Calendar integration and sync

**Features:**
- Google Calendar sync
- Outlook Calendar sync
- Event management
- Attendee tracking

### 3. Workflow Module

**Purpose**: Workflow automation engine

**Components:**
```
WorkflowModule
├── WorkflowRunner
│   ├── Execute workflows
│   └── Handle errors
├── WorkflowTrigger
│   ├── Record triggers
│   ├── Schedule triggers
│   └── Webhook triggers
└── WorkflowAction
    ├── Update record
    ├── Send email
    ├── Webhook call
    └── Run code
```

**Workflow Execution Flow:**
```
Trigger Event
    │
    ▼
Find Active Workflows
    │
    ▼
Evaluate Conditions
    │
    ▼
Execute Actions (Sequential)
    │
    ├─► Action 1
    ├─► Action 2
    └─► Action 3
        │
        ▼
    Log Results
```

### 4. Connected Account Module

**Purpose**: Manage third-party account connections

**Features:**
- OAuth connection
- Token refresh
- Account status
- Provider management

---

## Development Guidelines

### Module Structure

```typescript
// entity.module.ts
@Module({
  imports: [
    TypeOrmModule.forFeature([Entity]),
  ],
  controllers: [EntityController],
  providers: [EntityService, EntityResolver],
  exports: [EntityService],
})
export class EntityModule {}

// entity.service.ts
@Injectable()
export class EntityService {
  constructor(
    @InjectRepository(Entity)
    private entityRepository: Repository<Entity>,
  ) {}

  async findAll(): Promise<Entity[]> {
    return this.entityRepository.find();
  }
}

// entity.resolver.ts
@Resolver(() => Entity)
export class EntityResolver {
  constructor(private entityService: EntityService) {}

  @Query(() => [Entity])
  async entities(): Promise<Entity[]> {
    return this.entityService.findAll();
  }
}
```

### DTO Validation

```typescript
// dto/create-entity.dto.ts
export class CreateEntityDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsEmail()
  @IsOptional()
  email?: string;

  @IsNumber()
  @Min(0)
  @Max(1000)
  @IsOptional()
  employees?: number;
}
```

### Error Handling

```typescript
// Custom exception
export class EntityNotFoundException extends NotFoundException {
  constructor(id: string) {
    super(`Entity with ID ${id} not found`);
  }
}

// Usage
async findById(id: string): Promise<Entity> {
  const entity = await this.entityRepository.findOne({ where: { id } });
  
  if (!entity) {
    throw new EntityNotFoundException(id);
  }
  
  return entity;
}
```

### Testing

```typescript
// entity.service.spec.ts
describe('EntityService', () => {
  let service: EntityService;
  let repository: Repository<Entity>;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        EntityService,
        {
          provide: getRepositoryToken(Entity),
          useValue: {
            find: jest.fn(),
            findOne: jest.fn(),
            save: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<EntityService>(EntityService);
    repository = module.get<Repository<Entity>>(getRepositoryToken(Entity));
  });

  it('should find all entities', async () => {
    const entities = [{ id: '1', name: 'Test' }];
    jest.spyOn(repository, 'find').mockResolvedValue(entities);

    expect(await service.findAll()).toEqual(entities);
  });
});
```

---

## Additional Resources

### Internal Documentation
- [Folder Architecture](../packages/twenty-website/src/content/developers/backend-development/folder-architecture-server.mdx)
- [Server Commands](../packages/twenty-website/src/content/developers/backend-development/server-commands.mdx)
- [Best Practices](../packages/twenty-website/src/content/developers/backend-development/best-practices-server.mdx)
- [Custom Objects](../packages/twenty-website/src/content/developers/backend-development/custom-objects.mdx)

### External Resources
- [NestJS Documentation](https://docs.nestjs.com)
- [TypeORM Documentation](https://typeorm.io)
- [GraphQL Yoga Documentation](https://the-guild.dev/graphql/yoga-server)
- [BullMQ Documentation](https://docs.bullmq.io)
- [PostgreSQL Documentation](https://www.postgresql.org/docs)

---

This documentation provides a comprehensive overview of the Twenty backend architecture. For specific implementation details, refer to the code and inline documentation.
