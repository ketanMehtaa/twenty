# Twenty Server - Development Guide

Practical guide for developing with Twenty Server.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Environment](#development-environment)
- [Common Development Tasks](#common-development-tasks)
- [Creating Custom Modules](#creating-custom-modules)
- [Working with Metadata](#working-with-metadata)
- [Database Migrations](#database-migrations)
- [Testing Strategies](#testing-strategies)
- [Debugging](#debugging)
- [Code Style Guide](#code-style-guide)
- [Troubleshooting](#troubleshooting)

---

## Getting Started

### Initial Setup

1. **Clone the repository:**
```bash
git clone https://github.com/twentyhq/twenty.git
cd twenty
```

2. **Install dependencies:**
```bash
yarn install
```

3. **Set up environment:**
```bash
cd packages/twenty-server
cp .env.example .env
# Edit .env with your configuration
```

4. **Start PostgreSQL and Redis:**
```bash
# Using Docker
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres:15
docker run -d -p 6379:6379 redis:7-alpine
```

5. **Initialize database:**
```bash
npx nx database:reset twenty-server
```

6. **Start development server:**
```bash
npx nx start twenty-server
```

The server will be available at `http://localhost:3000`.

### Verify Installation

Test the health endpoint:
```bash
curl http://localhost:3000/healthz
```

Access GraphQL playground:
```
http://localhost:3000/graphql
```

---

## Development Environment

### Recommended Tools

- **IDE**: VS Code with extensions:
  - ESLint
  - Prettier
  - GraphQL
  - TypeScript
  - NestJS Snippets
  - REST Client

- **Database Client**: 
  - DBeaver
  - pgAdmin
  - Postico (Mac)

- **API Testing**:
  - GraphQL Playground (built-in)
  - Postman
  - Insomnia

- **Redis Client**:
  - RedisInsight
  - redis-cli

### VS Code Configuration

`.vscode/settings.json`:
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true
}
```

`.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Debug Server",
      "runtimeExecutable": "npx",
      "runtimeArgs": ["nx", "start", "twenty-server"],
      "console": "integratedTerminal",
      "skipFiles": ["<node_internals>/**"]
    },
    {
      "type": "node",
      "request": "launch",
      "name": "Debug Worker",
      "runtimeExecutable": "npx",
      "runtimeArgs": ["nx", "run", "twenty-server:worker"],
      "console": "integratedTerminal"
    },
    {
      "type": "node",
      "request": "launch",
      "name": "Debug Tests",
      "runtimeExecutable": "npx",
      "runtimeArgs": ["nx", "test", "twenty-server", "--watch"],
      "console": "integratedTerminal"
    }
  ]
}
```

---

## Common Development Tasks

### Running the Application

**Development mode with hot reload:**
```bash
npx nx start twenty-server
```

**Production mode:**
```bash
npx nx build twenty-server
yarn start:prod
```

**Worker (background jobs):**
```bash
npx nx run twenty-server:worker
```

### Database Operations

**Reset database (drops all data):**
```bash
npx nx database:reset twenty-server
```

**Run migrations:**
```bash
yarn database:migrate:prod
```

**Generate migration:**
```bash
npx nx run twenty-server:typeorm migration:generate \
  src/database/typeorm/core/migrations/MyMigration \
  -d src/database/typeorm/core/core.datasource.ts
```

**Sync workspace metadata:**
```bash
npx nx run twenty-server:command workspace:sync-metadata -f
```

### Testing

**Run all tests:**
```bash
npx nx test twenty-server
```

**Run specific test file:**
```bash
npx nx test twenty-server --testFile=company.service.spec.ts
```

**Run tests in watch mode:**
```bash
npx nx test twenty-server --watch
```

**Run integration tests:**
```bash
npx nx run twenty-server:test:integration:with-db-reset
```

**Test coverage:**
```bash
npx nx test twenty-server --coverage
```

### Linting and Formatting

**Lint code:**
```bash
npx nx lint twenty-server
```

**Fix linting issues:**
```bash
npx nx lint twenty-server --fix
```

**Type checking:**
```bash
npx nx typecheck twenty-server
```

**Format code:**
```bash
npx nx fmt twenty-server
```

### GraphQL

**Generate GraphQL types (frontend):**
```bash
npx nx run twenty-front:graphql:generate
```

---

## Creating Custom Modules

### Module Structure

Create a new business module following the established pattern:

```bash
mkdir -p src/modules/my-module
cd src/modules/my-module
```

**File structure:**
```
my-module/
├── my-module.module.ts
├── my-module.service.ts
├── my-module.resolver.ts       # For GraphQL
├── my-module.controller.ts     # For REST (optional)
├── dto/
│   ├── create-my-entity.input.ts
│   └── update-my-entity.input.ts
├── entities/
│   └── my-entity.entity.ts
└── __tests__/
    └── my-module.service.spec.ts
```

### Step 1: Create Entity

`entities/my-entity.entity.ts`:
```typescript
import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { Field, ObjectType, ID } from '@nestjs/graphql';

@Entity('my_entities')
@ObjectType()
export class MyEntity {
  @PrimaryGeneratedColumn('uuid')
  @Field(() => ID)
  id: string;

  @Column()
  @Field()
  name: string;

  @Column({ type: 'text', nullable: true })
  @Field({ nullable: true })
  description?: string;

  @CreateDateColumn()
  @Field()
  createdAt: Date;

  @UpdateDateColumn()
  @Field()
  updatedAt: Date;
}
```

### Step 2: Create DTOs

`dto/create-my-entity.input.ts`:
```typescript
import { InputType, Field } from '@nestjs/graphql';
import { IsString, IsOptional } from 'class-validator';

@InputType()
export class CreateMyEntityInput {
  @Field()
  @IsString()
  name: string;

  @Field({ nullable: true })
  @IsString()
  @IsOptional()
  description?: string;
}
```

`dto/update-my-entity.input.ts`:
```typescript
import { InputType, Field, PartialType } from '@nestjs/graphql';
import { CreateMyEntityInput } from './create-my-entity.input';

@InputType()
export class UpdateMyEntityInput extends PartialType(CreateMyEntityInput) {}
```

### Step 3: Create Service

`my-module.service.ts`:
```typescript
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MyEntity } from './entities/my-entity.entity';
import { CreateMyEntityInput } from './dto/create-my-entity.input';
import { UpdateMyEntityInput } from './dto/update-my-entity.input';

@Injectable()
export class MyModuleService {
  constructor(
    @InjectRepository(MyEntity)
    private myEntityRepository: Repository<MyEntity>,
  ) {}

  async findAll(): Promise<MyEntity[]> {
    return this.myEntityRepository.find();
  }

  async findOne(id: string): Promise<MyEntity> {
    const entity = await this.myEntityRepository.findOne({ where: { id } });
    
    if (!entity) {
      throw new NotFoundException(`MyEntity with ID ${id} not found`);
    }
    
    return entity;
  }

  async create(input: CreateMyEntityInput): Promise<MyEntity> {
    const entity = this.myEntityRepository.create(input);
    return this.myEntityRepository.save(entity);
  }

  async update(id: string, input: UpdateMyEntityInput): Promise<MyEntity> {
    const entity = await this.findOne(id);
    Object.assign(entity, input);
    return this.myEntityRepository.save(entity);
  }

  async remove(id: string): Promise<void> {
    const entity = await this.findOne(id);
    await this.myEntityRepository.remove(entity);
  }
}
```

### Step 4: Create Resolver

`my-module.resolver.ts`:
```typescript
import { Resolver, Query, Mutation, Args, ID } from '@nestjs/graphql';
import { UseGuards } from '@nestjs/common';
import { MyModuleService } from './my-module.service';
import { MyEntity } from './entities/my-entity.entity';
import { CreateMyEntityInput } from './dto/create-my-entity.input';
import { UpdateMyEntityInput } from './dto/update-my-entity.input';
import { WorkspaceGuard } from 'src/engine/guards/workspace.guard';

@Resolver(() => MyEntity)
@UseGuards(WorkspaceGuard)
export class MyModuleResolver {
  constructor(private readonly myModuleService: MyModuleService) {}

  @Query(() => [MyEntity], { name: 'myEntities' })
  async findAll(): Promise<MyEntity[]> {
    return this.myModuleService.findAll();
  }

  @Query(() => MyEntity, { name: 'myEntity' })
  async findOne(
    @Args('id', { type: () => ID }) id: string,
  ): Promise<MyEntity> {
    return this.myModuleService.findOne(id);
  }

  @Mutation(() => MyEntity)
  async createMyEntity(
    @Args('input') input: CreateMyEntityInput,
  ): Promise<MyEntity> {
    return this.myModuleService.create(input);
  }

  @Mutation(() => MyEntity)
  async updateMyEntity(
    @Args('id', { type: () => ID }) id: string,
    @Args('input') input: UpdateMyEntityInput,
  ): Promise<MyEntity> {
    return this.myModuleService.update(id, input);
  }

  @Mutation(() => Boolean)
  async removeMyEntity(
    @Args('id', { type: () => ID }) id: string,
  ): Promise<boolean> {
    await this.myModuleService.remove(id);
    return true;
  }
}
```

### Step 5: Create Module

`my-module.module.ts`:
```typescript
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MyModuleService } from './my-module.service';
import { MyModuleResolver } from './my-module.resolver';
import { MyEntity } from './entities/my-entity.entity';

@Module({
  imports: [TypeOrmModule.forFeature([MyEntity])],
  providers: [MyModuleService, MyModuleResolver],
  exports: [MyModuleService],
})
export class MyModuleModule {}
```

### Step 6: Register Module

Add to `src/modules/modules.module.ts`:
```typescript
import { MyModuleModule } from './my-module/my-module.module';

@Module({
  imports: [
    // ... existing modules
    MyModuleModule,
  ],
})
export class ModulesModule {}
```

### Step 7: Create Tests

`__tests__/my-module.service.spec.ts`:
```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MyModuleService } from '../my-module.service';
import { MyEntity } from '../entities/my-entity.entity';

describe('MyModuleService', () => {
  let service: MyModuleService;
  let repository: Repository<MyEntity>;

  const mockRepository = {
    find: jest.fn(),
    findOne: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
    remove: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MyModuleService,
        {
          provide: getRepositoryToken(MyEntity),
          useValue: mockRepository,
        },
      ],
    }).compile();

    service = module.get<MyModuleService>(MyModuleService);
    repository = module.get<Repository<MyEntity>>(getRepositoryToken(MyEntity));
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('findAll', () => {
    it('should return an array of entities', async () => {
      const entities = [{ id: '1', name: 'Test' }];
      mockRepository.find.mockResolvedValue(entities);

      const result = await service.findAll();
      expect(result).toEqual(entities);
      expect(repository.find).toHaveBeenCalled();
    });
  });

  describe('create', () => {
    it('should create a new entity', async () => {
      const input = { name: 'Test', description: 'Description' };
      const entity = { id: '1', ...input };
      
      mockRepository.create.mockReturnValue(entity);
      mockRepository.save.mockResolvedValue(entity);

      const result = await service.create(input);
      expect(result).toEqual(entity);
      expect(repository.create).toHaveBeenCalledWith(input);
      expect(repository.save).toHaveBeenCalledWith(entity);
    });
  });
});
```

---

## Working with Metadata

### Creating Custom Objects via API

```typescript
// In a service or script
import { ObjectMetadataService } from 'src/engine/metadata-modules/object-metadata/object-metadata.service';

@Injectable()
export class CustomSetupService {
  constructor(
    private objectMetadataService: ObjectMetadataService,
  ) {}

  async createCustomObject() {
    const object = await this.objectMetadataService.createOne({
      workspaceId: 'workspace-id',
      nameSingular: 'property',
      namePlural: 'properties',
      labelSingular: 'Property',
      labelPlural: 'Properties',
      description: 'Real estate properties',
      icon: 'IconBuilding',
    });

    return object;
  }
}
```

### Adding Custom Fields

```typescript
import { FieldMetadataService } from 'src/engine/metadata-modules/field-metadata/field-metadata.service';

async addCustomField(objectId: string) {
  const field = await this.fieldMetadataService.createOne({
    objectMetadataId: objectId,
    name: 'squareFeet',
    label: 'Square Feet',
    type: 'NUMBER',
    description: 'Property size in square feet',
    isNullable: true,
  });

  return field;
}
```

---

## Database Migrations

### Creating Migrations

1. **Make entity changes:**
```typescript
// Add new column to entity
@Column({ nullable: true })
newField?: string;
```

2. **Generate migration:**
```bash
npx nx run twenty-server:typeorm migration:generate \
  src/database/typeorm/core/migrations/AddNewFieldToEntity \
  -d src/database/typeorm/core/core.datasource.ts
```

3. **Review generated migration:**
```typescript
// Generated file: src/database/typeorm/core/migrations/1234567890-AddNewFieldToEntity.ts
export class AddNewFieldToEntity1234567890 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.addColumn(
      'entity_table',
      new TableColumn({
        name: 'new_field',
        type: 'varchar',
        isNullable: true,
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropColumn('entity_table', 'new_field');
  }
}
```

4. **Run migration:**
```bash
yarn database:migrate:prod
```

### Manual Migration

For complex changes, create migration manually:

```bash
touch src/database/typeorm/core/migrations/1234567890-CustomMigration.ts
```

```typescript
import { MigrationInterface, QueryRunner } from 'typeorm';

export class CustomMigration1234567890 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    // Your SQL operations
    await queryRunner.query(`
      ALTER TABLE my_table 
      ADD COLUMN new_field VARCHAR(255)
    `);
    
    // Update existing data
    await queryRunner.query(`
      UPDATE my_table 
      SET new_field = 'default' 
      WHERE new_field IS NULL
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE my_table 
      DROP COLUMN new_field
    `);
  }
}
```

---

## Testing Strategies

### Unit Tests

Test individual components in isolation:

```typescript
describe('CompanyService', () => {
  let service: CompanyService;
  let repository: MockType<Repository<Company>>;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        CompanyService,
        {
          provide: getRepositoryToken(Company),
          useFactory: repositoryMockFactory,
        },
      ],
    }).compile();

    service = module.get(CompanyService);
    repository = module.get(getRepositoryToken(Company));
  });

  it('should find companies by industry', async () => {
    const companies = [{ id: '1', name: 'Acme', industry: 'Tech' }];
    repository.find.mockReturnValue(companies);

    const result = await service.findByIndustry('Tech');
    
    expect(result).toEqual(companies);
    expect(repository.find).toHaveBeenCalledWith({
      where: { industry: 'Tech' },
    });
  });
});
```

### Integration Tests

Test API endpoints with a test database:

```typescript
describe('Company API (e2e)', () => {
  let app: INestApplication;
  let accessToken: string;

  beforeAll(async () => {
    const moduleFixture = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();

    // Get auth token
    const response = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: 'test@test.com', password: 'password' });
    
    accessToken = response.body.accessToken;
  });

  afterAll(async () => {
    await app.close();
  });

  it('POST /rest/companies', async () => {
    const company = {
      name: 'Test Company',
      industry: 'Technology',
    };

    const response = await request(app.getHttpServer())
      .post('/rest/companies')
      .set('Authorization', `Bearer ${accessToken}`)
      .send(company)
      .expect(201);

    expect(response.body.data).toMatchObject(company);
    expect(response.body.data.id).toBeDefined();
  });
});
```

### GraphQL Integration Tests

```typescript
describe('Company GraphQL', () => {
  const gql = '/graphql';

  it('should create a company', () => {
    const mutation = `
      mutation CreateCompany($input: CompanyCreateInput!) {
        createCompany(data: $input) {
          id
          name
          industry
        }
      }
    `;

    return request(app.getHttpServer())
      .post(gql)
      .set('Authorization', `Bearer ${accessToken}`)
      .send({
        query: mutation,
        variables: {
          input: {
            name: 'GraphQL Test Co',
            industry: 'Technology',
          },
        },
      })
      .expect(200)
      .expect((res) => {
        expect(res.body.data.createCompany).toMatchObject({
          name: 'GraphQL Test Co',
          industry: 'Technology',
        });
      });
  });
});
```

---

## Debugging

### Enable Debug Logging

```bash
# In .env
LOG_LEVELS=error,warn,log,debug
LOGGER_DRIVER=console
```

### Debug Specific Module

```typescript
import { Logger } from '@nestjs/common';

@Injectable()
export class MyService {
  private logger = new Logger(MyService.name);

  myMethod() {
    this.logger.debug('Debug information', { data: 'value' });
    this.logger.log('Info message');
    this.logger.warn('Warning message');
    this.logger.error('Error message', stack);
  }
}
```

### Debug Database Queries

```bash
# In .env
TYPEORM_LOGGING=true
```

Or programmatically:
```typescript
// In datasource config
{
  logging: ['query', 'error', 'schema'],
  logger: 'advanced-console',
}
```

### Debug GraphQL Queries

GraphQL Playground includes query history and variable management at `http://localhost:3000/graphql`.

### Using VS Code Debugger

1. Set breakpoints in code
2. Press F5 or use Debug panel
3. Select "Debug Server" configuration
4. Trigger the code path

---

## Code Style Guide

### TypeScript Best Practices

**DO:**
```typescript
// Named exports
export class MyService { }
export type MyType = { };

// Types over interfaces (except extending third-party)
type User = {
  id: string;
  name: string;
};

// Functional components (in React contexts)
export const MyComponent = ({ prop }: Props) => { };

// Async/await over promises
async function getData() {
  const result = await fetchData();
  return result;
}
```

**DON'T:**
```typescript
// Default exports
export default class MyService { }

// any type
const value: any = getData();

// Interfaces for plain objects
interface User {
  id: string;
}

// Promise chains
function getData() {
  return fetchData().then(result => result);
}
```

### NestJS Patterns

```typescript
// Proper dependency injection
@Injectable()
export class MyService {
  constructor(
    private readonly otherService: OtherService,
    @InjectRepository(Entity)
    private repository: Repository<Entity>,
  ) {}
}

// Use guards for authorization
@UseGuards(WorkspaceGuard, PermissionGuard)
@Resolver(() => Company)
export class CompanyResolver { }

// Use interceptors for cross-cutting concerns
@UseInterceptors(LoggingInterceptor)
@Controller('companies')
export class CompanyController { }
```

---

## Troubleshooting

### Common Issues

**1. Port Already in Use**
```bash
Error: listen EADDRINUSE: address already in use :::3000
```
Solution:
```bash
# Find and kill process
lsof -ti:3000 | xargs kill -9
# Or change port in .env
NODE_PORT=3001
```

**2. Database Connection Failed**
```bash
Error: connect ECONNREFUSED 127.0.0.1:5432
```
Solution:
```bash
# Check PostgreSQL is running
docker ps | grep postgres
# Or start it
docker start postgres-container
```

**3. Redis Connection Failed**
```bash
Error: connect ECONNREFUSED 127.0.0.1:6379
```
Solution:
```bash
# Check Redis is running
docker ps | grep redis
# Or start it
docker start redis-container
```

**4. Migration Fails**
```bash
Error: relation "table_name" already exists
```
Solution:
```bash
# Check migration history
npx nx run twenty-server:typeorm migration:show \
  -d src/database/typeorm/core/core.datasource.ts

# Revert last migration
npx nx run twenty-server:typeorm migration:revert \
  -d src/database/typeorm/core/core.datasource.ts
```

**5. GraphQL Schema Issues**
```bash
Error: Cannot query field "xxx" on type "Company"
```
Solution:
```bash
# Sync metadata
npx nx run twenty-server:command workspace:sync-metadata -f

# Or restart server
npx nx start twenty-server
```

### Debug Checklist

When debugging issues:

1. ✅ Check logs for error messages
2. ✅ Verify environment variables in `.env`
3. ✅ Confirm database is running and accessible
4. ✅ Check Redis connection
5. ✅ Review recent code changes
6. ✅ Clear cache: `redis-cli FLUSHALL`
7. ✅ Restart server
8. ✅ Check for version mismatches in dependencies

---

## Additional Resources

- [NestJS Documentation](https://docs.nestjs.com/)
- [TypeORM Documentation](https://typeorm.io/)
- [GraphQL Documentation](https://graphql.org/learn/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Twenty Documentation](https://docs.twenty.com/)

---

## Getting Help

- **GitHub Issues**: [github.com/twentyhq/twenty/issues](https://github.com/twentyhq/twenty/issues)
- **Discord**: [discord.gg/twenty](https://discord.gg/twenty)
- **Stack Overflow**: Tag questions with `twenty-crm`
