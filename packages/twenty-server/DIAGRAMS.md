# Twenty Server - Visual Architecture Guide

Quick reference diagrams for understanding Twenty Server's architecture.

## System Architecture Overview

```mermaid
graph TB
    subgraph "External World"
        USER[Users/Clients]
        INTEGRATIONS[External Integrations]
    end
    
    subgraph "Twenty Server"
        subgraph "API Layer"
            GRAPHQL[GraphQL API<br/>/graphql]
            REST[REST API<br/>/rest]
            METADATA[Metadata API<br/>/metadata]
        end
        
        subgraph "Core Services"
            AUTH[Authentication]
            AUTHZ[Authorization]
            WORKSPACE[Workspace Manager]
            SCHEMA[Schema Builder]
        end
        
        subgraph "Business Logic"
            CRM[CRM Modules]
            WORKFLOW[Workflows]
            CALENDAR[Calendar]
            MESSAGING[Messaging]
        end
        
        subgraph "Data Access"
            ORM[Twenty ORM]
            CACHE[Cache Manager]
            QUEUE[Job Queue]
        end
    end
    
    subgraph "Data Stores"
        POSTGRES[(PostgreSQL<br/>Main Database)]
        REDIS[(Redis<br/>Cache & Queue)]
        CLICKHOUSE[(ClickHouse<br/>Analytics)]
        S3[S3/Storage<br/>Files]
    end
    
    USER --> GRAPHQL
    USER --> REST
    INTEGRATIONS --> REST
    
    GRAPHQL --> AUTH
    REST --> AUTH
    METADATA --> AUTH
    
    AUTH --> AUTHZ
    AUTHZ --> WORKSPACE
    WORKSPACE --> SCHEMA
    
    SCHEMA --> CRM
    SCHEMA --> WORKFLOW
    SCHEMA --> CALENDAR
    SCHEMA --> MESSAGING
    
    CRM --> ORM
    WORKFLOW --> ORM
    CALENDAR --> ORM
    MESSAGING --> ORM
    
    ORM --> POSTGRES
    CACHE --> REDIS
    QUEUE --> REDIS
    
    CRM --> QUEUE
    WORKFLOW --> QUEUE
    CALENDAR --> QUEUE
    MESSAGING --> QUEUE
    
    ORM --> CLICKHOUSE
    CRM --> S3
    
    style GRAPHQL fill:#4CAF50
    style REST fill:#2196F3
    style METADATA fill:#FF9800
    style POSTGRES fill:#336791
    style REDIS fill:#DC382D
    style CLICKHOUSE fill:#FFCC00
```

---

## Request Flow

### GraphQL Query Flow

```mermaid
sequenceDiagram
    autonumber
    participant Client
    participant Gateway as API Gateway
    participant Auth as Auth Middleware
    participant Workspace as Workspace Resolver
    participant Resolver as GraphQL Resolver
    participant Service as Business Service
    participant Cache as Redis Cache
    participant DB as PostgreSQL
    
    Client->>Gateway: POST /graphql<br/>{query, variables}
    Gateway->>Auth: Extract & verify token
    Auth->>Auth: Decode JWT
    Auth->>Workspace: Resolve workspace context
    Workspace->>Cache: Check workspace cache
    
    alt Cache Hit
        Cache-->>Workspace: Workspace data
    else Cache Miss
        Workspace->>DB: Query workspace
        DB-->>Workspace: Workspace data
        Workspace->>Cache: Store in cache
    end
    
    Workspace-->>Gateway: Set context
    Gateway->>Resolver: Execute query
    Resolver->>Service: Business logic
    
    Service->>Cache: Check data cache
    alt Cache Hit
        Cache-->>Service: Cached data
    else Cache Miss
        Service->>DB: Query data
        DB-->>Service: Results
        Service->>Cache: Cache results
    end
    
    Service-->>Resolver: Processed data
    Resolver-->>Gateway: GraphQL response
    Gateway-->>Client: JSON response
```

### Mutation with Background Job

```mermaid
sequenceDiagram
    autonumber
    participant Client
    participant API
    participant Service
    participant DB as PostgreSQL
    participant Events as Event Emitter
    participant Queue as Redis Queue
    participant Worker as Background Worker
    participant External as External Service
    
    Client->>API: Mutation request
    API->>Service: Process mutation
    Service->>DB: Write data
    DB-->>Service: Success
    
    Service->>Events: Emit event<br/>(company.created)
    Events->>Queue: Enqueue jobs
    
    Note over Queue: Job 1: Send email<br/>Job 2: Sync CRM<br/>Job 3: Update analytics
    
    Service-->>API: Mutation result
    API-->>Client: Success response
    
    par Async Processing
        Worker->>Queue: Fetch Job 1
        Worker->>External: Send email
        Worker->>Queue: Mark complete
    and
        Worker->>Queue: Fetch Job 2
        Worker->>External: Sync to CRM
        Worker->>Queue: Mark complete
    and
        Worker->>Queue: Fetch Job 3
        Worker->>DB: Update stats
        Worker->>Queue: Mark complete
    end
```

---

## Multi-Tenancy Architecture

```mermaid
graph TB
    subgraph "Workspace A"
        WA[Workspace Config]
        SA[workspace_a schema]
        
        subgraph "Workspace A Tables"
            CA[companies]
            PA[people]
            OA[opportunities]
            CTA[custom_object_1]
        end
    end
    
    subgraph "Workspace B"
        WB[Workspace Config]
        SB[workspace_b schema]
        
        subgraph "Workspace B Tables"
            CB[companies]
            PB[people]
            OB[opportunities]
            CTB[custom_object_2]
        end
    end
    
    subgraph "Core Schema (Shared)"
        CORE[Core Tables]
        
        subgraph "Core Tables"
            WORKSPACES[workspaces]
            USERS[users]
            MEMBERS[workspace_members]
            METADATA[object_metadata]
            FIELDS[field_metadata]
        end
    end
    
    WORKSPACES --> WA
    WORKSPACES --> WB
    
    WA --> SA
    WB --> SB
    
    SA --> CA
    SA --> PA
    SA --> OA
    SA --> CTA
    
    SB --> CB
    SB --> PB
    SB --> OB
    SB --> CTB
    
    METADATA --> CTA
    METADATA --> CTB
    
    style WA fill:#E3F2FD
    style WB fill:#FFF3E0
    style CORE fill:#F3E5F5
```

---

## GraphQL Schema Generation

```mermaid
graph TD
    START[Workspace Request] --> LOAD[Load Workspace Metadata]
    
    LOAD --> CACHE{Schema<br/>Cached?}
    
    CACHE -->|Yes| RETURN[Return Cached Schema]
    
    CACHE -->|No| FETCH[Fetch Object Metadata]
    FETCH --> OBJECTS[Load Objects]
    OBJECTS --> FIELDS[Load Fields]
    FIELDS --> RELATIONS[Load Relations]
    
    RELATIONS --> BUILD[Schema Builder]
    
    BUILD --> TYPES[Generate GraphQL Types]
    BUILD --> RESOLVERS[Generate Resolvers]
    BUILD --> QUERIES[Generate Queries]
    BUILD --> MUTATIONS[Generate Mutations]
    
    TYPES --> SCHEMA[Compile Schema]
    RESOLVERS --> SCHEMA
    QUERIES --> SCHEMA
    MUTATIONS --> SCHEMA
    
    SCHEMA --> STORE[Store in Cache]
    STORE --> RETURN
    
    RETURN --> END[Execute Query]
    
    style START fill:#4CAF50
    style END fill:#4CAF50
    style CACHE fill:#FFC107
    style SCHEMA fill:#2196F3
```

---

## Module Dependency Tree

```mermaid
graph TB
    APP[AppModule]
    
    APP --> CORE[CoreEngineModule]
    APP --> BUSINESS[ModulesModule]
    APP --> API[API Modules]
    
    subgraph "Core Engine"
        CORE --> AUTH[AuthModule]
        CORE --> USER[UserModule]
        CORE --> WORKSPACE[WorkspaceModule]
        CORE --> FILE[FileModule]
        CORE --> MESSAGING_CORE[MessagingModule]
        CORE --> CALENDAR_CORE[CalendarModule]
    end
    
    subgraph "Business Modules"
        BUSINESS --> COMPANY[CompanyModule]
        BUSINESS --> PERSON[PersonModule]
        BUSINESS --> OPPORTUNITY[OpportunityModule]
        BUSINESS --> WORKFLOW[WorkflowModule]
        BUSINESS --> TASK[TaskModule]
    end
    
    subgraph "APIs"
        API --> GRAPHQL[GraphQL API]
        API --> REST_API[REST API]
        API --> METADATA_API[Metadata API]
    end
    
    AUTH --> USER
    WORKSPACE --> USER
    
    COMPANY --> WORKSPACE
    PERSON --> WORKSPACE
    OPPORTUNITY --> WORKSPACE
    WORKFLOW --> WORKSPACE
    
    GRAPHQL --> COMPANY
    GRAPHQL --> PERSON
    REST_API --> COMPANY
    REST_API --> PERSON
    
    style APP fill:#E1BEE7
    style CORE fill:#BBDEFB
    style BUSINESS fill:#C8E6C9
    style API fill:#FFE0B2
```

---

## Authentication & Authorization Flow

```mermaid
graph TB
    START[Request with Token] --> EXTRACT[Extract Token]
    
    EXTRACT --> TYPE{Token Type?}
    
    TYPE -->|JWT| JWT_VERIFY[Verify JWT Signature]
    TYPE -->|API Key| API_VERIFY[Verify API Key]
    TYPE -->|OAuth| OAUTH_VERIFY[Verify OAuth Token]
    
    JWT_VERIFY --> DECODE[Decode Token]
    API_VERIFY --> LOOKUP[Lookup API Key]
    OAUTH_VERIFY --> VALIDATE[Validate with Provider]
    
    DECODE --> USER_ID[Extract User ID]
    LOOKUP --> USER_ID
    VALIDATE --> USER_ID
    
    USER_ID --> LOAD_USER[Load User from DB]
    
    LOAD_USER --> 2FA{2FA<br/>Enabled?}
    
    2FA -->|Yes| CHECK_2FA[Verify 2FA Code]
    2FA -->|No| WORKSPACE_CHECK
    
    CHECK_2FA -->|Valid| WORKSPACE_CHECK[Load Workspace Context]
    CHECK_2FA -->|Invalid| DENY[Deny Access]
    
    WORKSPACE_CHECK --> AUTHZ[Check Permissions]
    
    AUTHZ --> ROLE{User Role?}
    
    ROLE -->|Owner| GRANT[Grant Full Access]
    ROLE -->|Admin| GRANT
    ROLE -->|Member| CHECK_PERM[Check Specific Permission]
    ROLE -->|Guest| CHECK_PERM
    
    CHECK_PERM -->|Allowed| GRANT
    CHECK_PERM -->|Denied| DENY
    
    GRANT --> EXECUTE[Execute Request]
    DENY --> ERROR[Return 403 Error]
    
    style START fill:#4CAF50
    style GRANT fill:#4CAF50
    style DENY fill:#F44336
    style EXECUTE fill:#2196F3
```

---

## Background Job Processing

```mermaid
graph TB
    subgraph "Job Sources"
        API[API Requests]
        EVENTS[Domain Events]
        SCHEDULE[Scheduled Jobs]
        WEBHOOK[Webhooks]
    end
    
    subgraph "Job Queue (Redis)"
        QUEUE[BullMQ Queue]
        
        subgraph "Job Types"
            EMAIL[Email Jobs]
            CALENDAR[Calendar Jobs]
            WORKFLOW_JOB[Workflow Jobs]
            SYNC[Sync Jobs]
            IMPORT[Import Jobs]
        end
    end
    
    subgraph "Workers"
        WORKER1[Worker Instance 1]
        WORKER2[Worker Instance 2]
        WORKER3[Worker Instance N]
    end
    
    subgraph "Job Handlers"
        EMAIL_HANDLER[Email Handler]
        CALENDAR_HANDLER[Calendar Handler]
        WORKFLOW_HANDLER[Workflow Handler]
        SYNC_HANDLER[Sync Handler]
    end
    
    subgraph "External Services"
        SMTP[Email Service]
        GCAL[Google Calendar]
        EXTERNAL_API[External APIs]
    end
    
    API --> QUEUE
    EVENTS --> QUEUE
    SCHEDULE --> QUEUE
    WEBHOOK --> QUEUE
    
    QUEUE --> EMAIL
    QUEUE --> CALENDAR
    QUEUE --> WORKFLOW_JOB
    QUEUE --> SYNC
    QUEUE --> IMPORT
    
    EMAIL --> WORKER1
    CALENDAR --> WORKER2
    WORKFLOW_JOB --> WORKER3
    
    WORKER1 --> EMAIL_HANDLER
    WORKER2 --> CALENDAR_HANDLER
    WORKER3 --> WORKFLOW_HANDLER
    
    EMAIL_HANDLER --> SMTP
    CALENDAR_HANDLER --> GCAL
    WORKFLOW_HANDLER --> EXTERNAL_API
    SYNC_HANDLER --> EXTERNAL_API
    
    style QUEUE fill:#DC382D
    style WORKER1 fill:#4CAF50
    style WORKER2 fill:#4CAF50
    style WORKER3 fill:#4CAF50
```

---

## Data Access Patterns

```mermaid
graph TB
    RESOLVER[GraphQL Resolver] --> SERVICE[Business Service]
    
    SERVICE --> CACHE_CHECK{Check Cache}
    
    CACHE_CHECK -->|Hit| CACHE_HIT[Return from Cache]
    CACHE_CHECK -->|Miss| REPO[Repository]
    
    REPO --> ORM[Twenty ORM]
    ORM --> QUERY_BUILDER[Query Builder]
    
    QUERY_BUILDER --> OPTIMIZATIONS{Apply Optimizations}
    
    OPTIMIZATIONS --> DATALOADER[DataLoader<br/>Batch Queries]
    OPTIMIZATIONS --> EAGER[Eager Loading<br/>JOIN Relations]
    OPTIMIZATIONS --> INDEX[Use Indexes]
    
    DATALOADER --> DB_QUERY[Database Query]
    EAGER --> DB_QUERY
    INDEX --> DB_QUERY
    
    DB_QUERY --> POSTGRES[(PostgreSQL)]
    
    POSTGRES --> RESULTS[Query Results]
    
    RESULTS --> TRANSFORM[Transform to Entities]
    TRANSFORM --> CACHE_STORE[Store in Cache]
    CACHE_STORE --> RETURN[Return Results]
    CACHE_HIT --> RETURN
    
    RETURN --> SERVICE
    SERVICE --> RESOLVER
    
    style CACHE_CHECK fill:#FFC107
    style POSTGRES fill:#336791
    style DATALOADER fill:#4CAF50
```

---

## Deployment Architecture

```mermaid
graph TB
    subgraph "Load Balancing"
        LB[Load Balancer<br/>Nginx/ALB]
    end
    
    subgraph "Application Tier"
        API1[Server Instance 1<br/>GraphQL + REST]
        API2[Server Instance 2<br/>GraphQL + REST]
        API3[Server Instance N<br/>GraphQL + REST]
    end
    
    subgraph "Worker Tier"
        WORKER1[Worker Instance 1<br/>Job Processing]
        WORKER2[Worker Instance 2<br/>Job Processing]
        WORKER3[Worker Instance N<br/>Job Processing]
    end
    
    subgraph "Data Layer"
        PG_PRIMARY[(PostgreSQL<br/>Primary)]
        PG_REPLICA[(PostgreSQL<br/>Read Replica)]
        REDIS_CLUSTER[(Redis Cluster<br/>3 nodes)]
        CLICKHOUSE_CLUSTER[(ClickHouse<br/>Cluster)]
    end
    
    subgraph "Storage"
        S3[Object Storage<br/>S3/GCS]
    end
    
    subgraph "Monitoring"
        SENTRY[Sentry<br/>Error Tracking]
        PROMETHEUS[Prometheus<br/>Metrics]
        GRAFANA[Grafana<br/>Dashboards]
    end
    
    USERS[Users] --> LB
    
    LB --> API1
    LB --> API2
    LB --> API3
    
    API1 --> PG_PRIMARY
    API2 --> PG_PRIMARY
    API3 --> PG_PRIMARY
    
    API1 --> PG_REPLICA
    API2 --> PG_REPLICA
    API3 --> PG_REPLICA
    
    API1 --> REDIS_CLUSTER
    API2 --> REDIS_CLUSTER
    API3 --> REDIS_CLUSTER
    
    REDIS_CLUSTER --> WORKER1
    REDIS_CLUSTER --> WORKER2
    REDIS_CLUSTER --> WORKER3
    
    WORKER1 --> PG_PRIMARY
    WORKER2 --> PG_PRIMARY
    WORKER3 --> PG_PRIMARY
    
    API1 --> S3
    API2 --> S3
    API3 --> S3
    
    API1 --> CLICKHOUSE_CLUSTER
    API2 --> CLICKHOUSE_CLUSTER
    API3 --> CLICKHOUSE_CLUSTER
    
    API1 --> SENTRY
    API2 --> SENTRY
    API3 --> SENTRY
    
    API1 --> PROMETHEUS
    API2 --> PROMETHEUS
    API3 --> PROMETHEUS
    
    PROMETHEUS --> GRAFANA
    
    PG_PRIMARY -.->|Replication| PG_REPLICA
    
    style LB fill:#9C27B0
    style API1 fill:#2196F3
    style API2 fill:#2196F3
    style API3 fill:#2196F3
    style WORKER1 fill:#4CAF50
    style WORKER2 fill:#4CAF50
    style WORKER3 fill:#4CAF50
    style PG_PRIMARY fill:#336791
    style REDIS_CLUSTER fill:#DC382D
```

---

## Entity Relationship Diagram (Core Tables)

```mermaid
erDiagram
    WORKSPACE ||--o{ WORKSPACE_MEMBER : has
    WORKSPACE ||--o{ OBJECT_METADATA : defines
    WORKSPACE ||--o{ API_KEY : has
    WORKSPACE ||--o{ WEBHOOK : has
    
    USER ||--o{ WORKSPACE_MEMBER : belongs_to
    USER ||--o{ CONNECTED_ACCOUNT : has
    
    WORKSPACE_MEMBER }o--|| ROLE : has
    
    OBJECT_METADATA ||--o{ FIELD_METADATA : contains
    OBJECT_METADATA ||--o{ RELATION_METADATA : defines
    
    RELATION_METADATA }o--|| OBJECT_METADATA : from
    RELATION_METADATA }o--|| OBJECT_METADATA : to
    
    CONNECTED_ACCOUNT ||--o{ MESSAGE_CHANNEL : has
    MESSAGE_CHANNEL ||--o{ MESSAGE : contains
    
    WORKSPACE {
        uuid id PK
        string name
        string subdomain
        string logo
        boolean isActive
        timestamp createdAt
    }
    
    USER {
        uuid id PK
        string email UK
        string firstName
        string lastName
        string passwordHash
        boolean emailVerified
        timestamp createdAt
    }
    
    WORKSPACE_MEMBER {
        uuid id PK
        uuid workspaceId FK
        uuid userId FK
        uuid roleId FK
        timestamp createdAt
    }
    
    OBJECT_METADATA {
        uuid id PK
        uuid workspaceId FK
        string nameSingular UK
        string namePlural
        string labelSingular
        string labelPlural
        string description
        string icon
        boolean isActive
        boolean isCustom
        boolean isSystem
    }
    
    FIELD_METADATA {
        uuid id PK
        uuid objectMetadataId FK
        string name UK
        string label
        string type
        string description
        jsonb options
        boolean isNullable
        boolean isCustom
        jsonb defaultValue
    }
    
    RELATION_METADATA {
        uuid id PK
        string relationType
        uuid fromObjectMetadataId FK
        uuid toObjectMetadataId FK
        uuid fromFieldMetadataId FK
        uuid toFieldMetadataId FK
    }
```

---

## Performance Optimization Strategy

```mermaid
graph TB
    REQUEST[Incoming Request] --> L1_CACHE{L1: Memory Cache}
    
    L1_CACHE -->|Hit| RETURN[Return Response]
    L1_CACHE -->|Miss| L2_CACHE{L2: Redis Cache}
    
    L2_CACHE -->|Hit| STORE_L1[Store in L1]
    L2_CACHE -->|Miss| OPTIMIZE[Query Optimization]
    
    STORE_L1 --> RETURN
    
    OPTIMIZE --> DATALOADER[DataLoader<br/>Batch N+1 Queries]
    OPTIMIZE --> EAGER_LOAD[Eager Loading<br/>JOIN Relations]
    OPTIMIZE --> PAGINATION[Cursor Pagination<br/>Limit Results]
    
    DATALOADER --> EXECUTE[Execute Query]
    EAGER_LOAD --> EXECUTE
    PAGINATION --> EXECUTE
    
    EXECUTE --> DB_POOL[Connection Pool]
    DB_POOL --> QUERY[SQL Query with Indexes]
    
    QUERY --> POSTGRES[(PostgreSQL)]
    
    POSTGRES --> RESULTS[Results]
    RESULTS --> CACHE_RESULTS[Cache in Redis]
    CACHE_RESULTS --> RETURN
    
    subgraph "Performance Layers"
        L1_CACHE
        L2_CACHE
        DATALOADER
        EAGER_LOAD
        PAGINATION
        DB_POOL
    end
    
    style L1_CACHE fill:#4CAF50
    style L2_CACHE fill:#FFC107
    style DATALOADER fill:#2196F3
    style POSTGRES fill:#336791
```

---

## Security Layers

```mermaid
graph TB
    REQUEST[HTTP Request] --> HTTPS[HTTPS/TLS Layer]
    
    HTTPS --> CORS[CORS Validation]
    CORS --> RATE_LIMIT[Rate Limiting]
    RATE_LIMIT --> AUTH[Authentication]
    
    AUTH --> JWT{Valid JWT?}
    AUTH --> API_KEY{Valid API Key?}
    
    JWT -->|Yes| USER_LOAD[Load User]
    JWT -->|No| REJECT[401 Unauthorized]
    
    API_KEY -->|Yes| USER_LOAD
    API_KEY -->|No| REJECT
    
    USER_LOAD --> TWO_FA{2FA Required?}
    
    TWO_FA -->|Yes| VERIFY_2FA[Verify 2FA Code]
    TWO_FA -->|No| AUTHZ
    
    VERIFY_2FA -->|Valid| AUTHZ[Authorization]
    VERIFY_2FA -->|Invalid| REJECT
    
    AUTHZ --> WORKSPACE_CHECK[Workspace Access Check]
    WORKSPACE_CHECK --> PERMISSION[Permission Check]
    
    PERMISSION -->|Allowed| INPUT_VAL[Input Validation]
    PERMISSION -->|Denied| REJECT2[403 Forbidden]
    
    INPUT_VAL --> SANITIZE[Sanitize Input]
    SANITIZE --> EXECUTE[Execute Request]
    
    EXECUTE --> AUDIT[Audit Log]
    AUDIT --> RESPONSE[Send Response]
    
    style HTTPS fill:#4CAF50
    style AUTH fill:#2196F3
    style AUTHZ fill:#FF9800
    style REJECT fill:#F44336
    style REJECT2 fill:#F44336
    style EXECUTE fill:#4CAF50
```

---

## Legend

### Common Colors Used

- 🟢 **Green**: Entry points, success paths, workers
- 🔵 **Blue**: Core services, APIs, processing
- 🟠 **Orange**: Metadata, configuration, warnings
- 🔴 **Red**: Errors, denials, failures
- 🟡 **Yellow**: Cache layers, decisions
- 🟣 **Purple**: Infrastructure, load balancers

### Symbol Meanings

- **Rectangle**: Process/Service
- **Cylinder**: Database/Storage
- **Diamond**: Decision Point
- **Rounded Rectangle**: External Service
- **Subgraph**: Logical Grouping

---

## Quick Reference

### Key Endpoints
- GraphQL: `/graphql`
- REST: `/rest/*`
- Metadata: `/metadata`
- Health: `/healthz`

### Key Technologies
- Framework: NestJS
- Database: PostgreSQL + TypeORM
- Cache: Redis
- Queue: BullMQ
- Analytics: ClickHouse (optional)

### Default Ports
- Server: 3000
- PostgreSQL: 5432
- Redis: 6379
- ClickHouse: 8123

---

This visual guide provides quick reference diagrams for understanding Twenty Server's architecture, flows, and patterns.
