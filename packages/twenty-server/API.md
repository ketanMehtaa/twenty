# Twenty Server - API Documentation

Complete reference for Twenty Server's GraphQL and REST APIs.

## Table of Contents

- [Authentication](#authentication)
- [GraphQL Core API](#graphql-core-api)
- [GraphQL Metadata API](#graphql-metadata-api)
- [REST API](#rest-api)
- [Error Handling](#error-handling)
- [Rate Limiting](#rate-limiting)
- [Pagination](#pagination)
- [Filtering & Sorting](#filtering--sorting)

---

## Authentication

### API Key Authentication

Create an API key in your workspace settings and include it in requests:

```bash
Authorization: Bearer <your-api-key>
```

### Creating API Keys

```graphql
# GraphQL Metadata API
mutation CreateApiKey {
  createOneApiKey(
    data: {
      name: "My Integration"
      expiresAt: "2025-12-31T23:59:59Z"
    }
  ) {
    id
    name
    token
    expiresAt
  }
}
```

### Token-Based Authentication

Login to get access and refresh tokens:

```bash
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "secret123"
}

# Response
{
  "accessToken": "eyJhbGciOiJIUzI1NiIs...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
  "expiresIn": 1800
}
```

Use the access token in subsequent requests:
```bash
Authorization: Bearer <access-token>
```

---

## GraphQL Core API

**Endpoint:** `POST /graphql`

The Core API provides CRUD operations for all workspace objects (both standard and custom).

### Schema Exploration

Introspection query to explore available types:

```graphql
query IntrospectSchema {
  __schema {
    types {
      name
      kind
      description
      fields {
        name
        type {
          name
          kind
        }
      }
    }
  }
}
```

### Standard Objects

#### Companies

**Query Companies:**
```graphql
query GetCompanies(
  $filter: CompanyFilterInput
  $orderBy: [CompanyOrderByInput!]
  $limit: Int
  $after: String
) {
  companies(
    filter: $filter
    orderBy: $orderBy
    first: $limit
    after: $after
  ) {
    edges {
      node {
        id
        name
        domainName
        address
        employees
        industry
        linkedinLink
        xLink
        annualRecurringRevenue {
          amountMicros
          currencyCode
        }
        idealCustomerProfile
        createdAt
        updatedAt
        # Relations
        people {
          edges {
            node {
              id
              name {
                firstName
                lastName
              }
              email
              phone
            }
          }
        }
        opportunities {
          edges {
            node {
              id
              name
              amount {
                amountMicros
                currencyCode
              }
              stage
              closeDate
            }
          }
        }
      }
      cursor
    }
    pageInfo {
      hasNextPage
      hasPreviousPage
      startCursor
      endCursor
    }
    totalCount
  }
}
```

**Variables:**
```json
{
  "filter": {
    "industry": { "eq": "Technology" },
    "employees": { "gte": 100 }
  },
  "orderBy": [
    { "createdAt": "DescNullsLast" }
  ],
  "limit": 20
}
```

**Create Company:**
```graphql
mutation CreateCompany($input: CompanyCreateInput!) {
  createCompany(data: $input) {
    id
    name
    domainName
    industry
    createdAt
  }
}
```

**Variables:**
```json
{
  "input": {
    "name": "Acme Corporation",
    "domainName": "acme.com",
    "industry": "Technology",
    "employees": 500,
    "address": "123 Main St, San Francisco, CA",
    "idealCustomerProfile": true
  }
}
```

**Update Company:**
```graphql
mutation UpdateCompany($id: ID!, $input: CompanyUpdateInput!) {
  updateCompany(id: $id, data: $input) {
    id
    name
    employees
    updatedAt
  }
}
```

**Variables:**
```json
{
  "id": "company-id-here",
  "input": {
    "employees": 600,
    "linkedinLink": "https://linkedin.com/company/acme"
  }
}
```

**Delete Company:**
```graphql
mutation DeleteCompany($id: ID!) {
  deleteCompany(id: $id) {
    id
  }
}
```

#### People (Contacts)

**Query People:**
```graphql
query GetPeople($filter: PersonFilterInput, $limit: Int) {
  people(filter: $filter, first: $limit) {
    edges {
      node {
        id
        name {
          firstName
          lastName
        }
        email
        phone
        city
        jobTitle
        linkedinLink
        xLink
        avatarUrl
        position
        createdAt
        updatedAt
        # Relations
        company {
          id
          name
        }
        opportunities {
          edges {
            node {
              id
              name
              stage
            }
          }
        }
      }
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
}
```

**Create Person:**
```graphql
mutation CreatePerson($input: PersonCreateInput!) {
  createPerson(data: $input) {
    id
    name {
      firstName
      lastName
    }
    email
    phone
    createdAt
  }
}
```

**Variables:**
```json
{
  "input": {
    "name": {
      "firstName": "John",
      "lastName": "Doe"
    },
    "email": "john.doe@example.com",
    "phone": "+1-555-0123",
    "jobTitle": "CTO",
    "companyId": "company-id-here",
    "city": "San Francisco"
  }
}
```

#### Opportunities

**Query Opportunities:**
```graphql
query GetOpportunities($filter: OpportunityFilterInput) {
  opportunities(filter: $filter) {
    edges {
      node {
        id
        name
        amount {
          amountMicros
          currencyCode
        }
        stage
        probability
        closeDate
        createdAt
        # Relations
        company {
          id
          name
        }
        pointOfContact {
          id
          name {
            firstName
            lastName
          }
        }
      }
    }
  }
}
```

**Create Opportunity:**
```graphql
mutation CreateOpportunity($input: OpportunityCreateInput!) {
  createOpportunity(data: $input) {
    id
    name
    amount {
      amountMicros
      currencyCode
    }
    stage
    probability
  }
}
```

**Variables:**
```json
{
  "input": {
    "name": "Enterprise License",
    "amount": {
      "amountMicros": 50000000000,
      "currencyCode": "USD"
    },
    "stage": "QUALIFICATION",
    "probability": 25,
    "closeDate": "2024-12-31",
    "companyId": "company-id-here",
    "pointOfContactId": "person-id-here"
  }
}
```

#### Tasks

**Query Tasks:**
```graphql
query GetTasks($filter: TaskFilterInput) {
  tasks(filter: $filter, orderBy: [{ dueAt: "AscNullsLast" }]) {
    edges {
      node {
        id
        title
        body
        status
        dueAt
        createdAt
        # Relations
        assignee {
          id
          name {
            firstName
            lastName
          }
        }
      }
    }
  }
}
```

**Create Task:**
```graphql
mutation CreateTask($input: TaskCreateInput!) {
  createTask(data: $input) {
    id
    title
    body
    status
    dueAt
  }
}
```

#### Notes

**Query Notes:**
```graphql
query GetNotes($filter: NoteFilterInput) {
  notes(filter: $filter, orderBy: [{ createdAt: "DescNullsLast" }]) {
    edges {
      node {
        id
        title
        body
        position
        createdAt
        updatedAt
      }
    }
  }
}
```

### Custom Objects

Custom objects follow the same pattern as standard objects.

**Example: Query Custom "Property" Object:**
```graphql
query GetProperties($filter: PropertyFilterInput) {
  properties(filter: $filter) {
    edges {
      node {
        id
        address
        price {
          amountMicros
          currencyCode
        }
        bedrooms
        bathrooms
        squareFeet
        status
        # Custom fields
        parkingSpaces
        hasGarage
        yearBuilt
      }
    }
  }
}
```

### Batch Operations

**Batch Create:**
```graphql
mutation BatchCreateCompanies($inputs: [CompanyCreateInput!]!) {
  createCompanies(data: $inputs) {
    id
    name
  }
}
```

**Batch Update:**
```graphql
mutation BatchUpdateCompanies($ids: [ID!]!, $input: CompanyUpdateInput!) {
  updateCompanies(ids: $ids, data: $input) {
    id
    updatedAt
  }
}
```

**Batch Delete:**
```graphql
mutation BatchDeleteCompanies($ids: [ID!]!) {
  deleteCompanies(ids: $ids) {
    id
  }
}
```

---

## GraphQL Metadata API

**Endpoint:** `POST /metadata`

The Metadata API manages workspace schema and configuration.

### Objects

**List Objects:**
```graphql
query ListObjects {
  objects {
    edges {
      node {
        id
        nameSingular
        namePlural
        labelSingular
        labelPlural
        description
        icon
        isActive
        isCustom
        isSystem
        createdAt
        updatedAt
        # Relations
        fields {
          edges {
            node {
              id
              name
              label
              type
              description
              icon
              isCustom
              isActive
              isNullable
              defaultValue
            }
          }
        }
      }
    }
  }
}
```

**Create Object:**
```graphql
mutation CreateObject($input: CreateObjectInput!) {
  createOneObject(data: $input) {
    id
    nameSingular
    namePlural
    labelSingular
    labelPlural
    icon
  }
}
```

**Variables:**
```json
{
  "input": {
    "nameSingular": "property",
    "namePlural": "properties",
    "labelSingular": "Property",
    "labelPlural": "Properties",
    "description": "Real estate properties",
    "icon": "IconBuilding"
  }
}
```

**Update Object:**
```graphql
mutation UpdateObject($id: ID!, $input: UpdateObjectInput!) {
  updateOneObject(id: $id, data: $input) {
    id
    labelSingular
    description
    updatedAt
  }
}
```

**Delete Object:**
```graphql
mutation DeleteObject($id: ID!) {
  deleteOneObject(id: $id) {
    id
  }
}
```

### Fields

**Create Field:**
```graphql
mutation CreateField($input: CreateFieldInput!) {
  createOneField(data: $input) {
    id
    name
    label
    type
    description
  }
}
```

**Variables:**
```json
{
  "input": {
    "objectMetadataId": "object-id-here",
    "name": "price",
    "label": "Price",
    "type": "CURRENCY",
    "description": "Property listing price",
    "icon": "IconCurrencyDollar",
    "isNullable": true,
    "defaultValue": null
  }
}
```

**Field Types:**
- `TEXT`: Single-line text
- `NUMBER`: Integer or decimal
- `BOOLEAN`: True/false
- `DATE_TIME`: Timestamp
- `DATE`: Date only
- `EMAIL`: Email address
- `PHONE`: Phone number
- `URL`: Web address
- `CURRENCY`: Money amount
- `SELECT`: Dropdown (single choice)
- `MULTI_SELECT`: Multiple choices
- `RELATION`: Relationship to another object
- `RATING`: Star rating
- `JSON`: JSON data

**Update Field:**
```graphql
mutation UpdateField($id: ID!, $input: UpdateFieldInput!) {
  updateOneField(id: $id, data: $input) {
    id
    label
    description
    updatedAt
  }
}
```

**Delete Field:**
```graphql
mutation DeleteField($id: ID!) {
  deleteOneField(id: $id) {
    id
  }
}
```

### Relations

**Create Relation:**
```graphql
mutation CreateRelation($input: CreateRelationInput!) {
  createOneRelation(data: $input) {
    id
    relationType
    fromObjectMetadataId
    toObjectMetadataId
  }
}
```

**Variables:**
```json
{
  "input": {
    "relationType": "ONE_TO_MANY",
    "fromObjectMetadataId": "company-object-id",
    "toObjectMetadataId": "property-object-id",
    "fromFieldMetadataName": "properties",
    "toFieldMetadataName": "company"
  }
}
```

**Relation Types:**
- `ONE_TO_MANY`: One parent, many children (e.g., Company → People)
- `MANY_TO_ONE`: Many children, one parent (reverse of above)
- `ONE_TO_ONE`: One-to-one relationship
- `MANY_TO_MANY`: Many-to-many (via junction table)

---

## REST API

**Base URL:** `/rest`

The REST API provides CRUD operations following OpenAPI 3.0 specification.

### Authentication

```bash
Authorization: Bearer <api-key>
Content-Type: application/json
```

### Companies

**List Companies:**
```bash
GET /rest/companies?limit=20&filter[industry][eq]=Technology&order[createdAt]=desc

# Response
{
  "data": [
    {
      "id": "uuid",
      "name": "Acme Corp",
      "industry": "Technology",
      "employees": 500,
      "createdAt": "2024-01-15T10:00:00Z"
    }
  ],
  "meta": {
    "totalCount": 150,
    "hasMore": true
  }
}
```

**Get Single Company:**
```bash
GET /rest/companies/{id}

# Response
{
  "data": {
    "id": "uuid",
    "name": "Acme Corp",
    "domainName": "acme.com",
    "industry": "Technology",
    "employees": 500
  }
}
```

**Create Company:**
```bash
POST /rest/companies
Content-Type: application/json

{
  "name": "New Company",
  "industry": "Technology",
  "employees": 100
}

# Response
{
  "data": {
    "id": "new-uuid",
    "name": "New Company",
    "industry": "Technology",
    "employees": 100,
    "createdAt": "2024-01-20T10:00:00Z"
  }
}
```

**Update Company:**
```bash
PATCH /rest/companies/{id}
Content-Type: application/json

{
  "employees": 150,
  "linkedinLink": "https://linkedin.com/company/new-co"
}

# Response
{
  "data": {
    "id": "uuid",
    "employees": 150,
    "linkedinLink": "https://linkedin.com/company/new-co",
    "updatedAt": "2024-01-20T11:00:00Z"
  }
}
```

**Delete Company:**
```bash
DELETE /rest/companies/{id}

# Response
{
  "data": {
    "id": "uuid",
    "deleted": true
  }
}
```

### People

**List People:**
```bash
GET /rest/people?limit=50&filter[company.id][eq]=company-uuid
```

**Create Person:**
```bash
POST /rest/people
Content-Type: application/json

{
  "name": {
    "firstName": "Jane",
    "lastName": "Smith"
  },
  "email": "jane.smith@example.com",
  "companyId": "company-uuid"
}
```

### Opportunities

**List Opportunities:**
```bash
GET /rest/opportunities?filter[stage][eq]=PROPOSAL
```

### Custom Objects

Custom objects are accessible at `/rest/{object-name-plural}`:

```bash
GET /rest/properties?limit=10
POST /rest/properties
PATCH /rest/properties/{id}
DELETE /rest/properties/{id}
```

### OpenAPI Specification

Access the full OpenAPI schema:

```bash
GET /rest/open-api/core?token=<your-token>

# Returns OpenAPI 3.0 JSON specification
```

Import this into tools like Postman, Swagger, or Insomnia for interactive API testing.

---

## Error Handling

### Error Response Format

```json
{
  "error": {
    "message": "Validation failed",
    "code": "VALIDATION_ERROR",
    "statusCode": 400,
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ]
  }
}
```

### Common Error Codes

| Code | Status | Description |
|------|--------|-------------|
| `UNAUTHORIZED` | 401 | Missing or invalid authentication |
| `FORBIDDEN` | 403 | Insufficient permissions |
| `NOT_FOUND` | 404 | Resource not found |
| `VALIDATION_ERROR` | 400 | Invalid input data |
| `CONFLICT` | 409 | Resource conflict (e.g., duplicate) |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests |
| `INTERNAL_ERROR` | 500 | Server error |

### GraphQL Errors

```json
{
  "errors": [
    {
      "message": "Field 'unknownField' doesn't exist on type 'Company'",
      "locations": [{ "line": 3, "column": 5 }],
      "path": ["companies", 0, "unknownField"],
      "extensions": {
        "code": "GRAPHQL_VALIDATION_FAILED"
      }
    }
  ],
  "data": null
}
```

---

## Rate Limiting

Rate limits apply per API key/user:

- **GraphQL API**: 100 requests/minute
- **REST API**: 200 requests/minute
- **Metadata API**: 50 requests/minute

**Rate Limit Headers:**
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 85
X-RateLimit-Reset: 1640000000
```

**Rate Limit Exceeded Response:**
```json
{
  "error": {
    "message": "Rate limit exceeded",
    "code": "RATE_LIMIT_EXCEEDED",
    "statusCode": 429,
    "retryAfter": 60
  }
}
```

---

## Pagination

### Cursor-Based Pagination (GraphQL)

```graphql
query GetCompanies($after: String, $limit: Int!) {
  companies(first: $limit, after: $after) {
    edges {
      node { id name }
      cursor
    }
    pageInfo {
      hasNextPage
      hasPreviousPage
      startCursor
      endCursor
    }
    totalCount
  }
}
```

**First Page:**
```json
{
  "limit": 20
}
```

**Next Page:**
```json
{
  "after": "cursor-from-previous-page",
  "limit": 20
}
```

### Offset-Based Pagination (REST)

```bash
GET /rest/companies?limit=20&offset=0     # Page 1
GET /rest/companies?limit=20&offset=20    # Page 2
GET /rest/companies?limit=20&offset=40    # Page 3
```

---

## Filtering & Sorting

### GraphQL Filters

**Comparison Operators:**
```graphql
{
  eq: "value"          # Equals
  neq: "value"         # Not equals
  in: ["val1", "val2"] # In list
  is: "NULL"           # Is null
  gt: 100              # Greater than
  gte: 100             # Greater than or equal
  lt: 100              # Less than
  lte: 100             # Less than or equal
  like: "%search%"     # String contains
  ilike: "%search%"    # Case-insensitive like
}
```

**Complex Filters:**
```graphql
query GetCompanies {
  companies(
    filter: {
      and: [
        { industry: { eq: "Technology" } }
        { or: [
          { employees: { gte: 100 } }
          { annualRecurringRevenue: { amountMicros: { gte: 1000000000000 } } }
        ]}
      ]
    }
  ) {
    edges { node { id name } }
  }
}
```

### GraphQL Sorting

```graphql
query GetCompanies {
  companies(
    orderBy: [
      { createdAt: "DescNullsLast" }
      { name: "AscNullsFirst" }
    ]
  ) {
    edges { node { id name createdAt } }
  }
}
```

**Sort Directions:**
- `Asc`: Ascending
- `Desc`: Descending
- `AscNullsFirst`: Ascending, nulls first
- `AscNullsLast`: Ascending, nulls last
- `DescNullsFirst`: Descending, nulls first
- `DescNullsLast`: Descending, nulls last

### REST Filters

```bash
# Equals
GET /rest/companies?filter[industry][eq]=Technology

# Greater than
GET /rest/companies?filter[employees][gt]=100

# In list
GET /rest/companies?filter[industry][in]=Technology,Finance

# Like (contains)
GET /rest/companies?filter[name][like]=%Acme%

# Multiple filters (AND)
GET /rest/companies?filter[industry][eq]=Technology&filter[employees][gte]=100

# Sorting
GET /rest/companies?order[createdAt]=desc&order[name]=asc
```

---

## Webhooks

Subscribe to events in your workspace:

```graphql
mutation CreateWebhook {
  createOneWebhook(
    data: {
      targetUrl: "https://your-app.com/webhook"
      operation: "create"
      description: "Company created webhook"
    }
  ) {
    id
    targetUrl
    operation
  }
}
```

**Webhook Payload:**
```json
{
  "event": "company.created",
  "workspaceId": "workspace-uuid",
  "objectName": "company",
  "recordId": "company-uuid",
  "data": {
    "id": "company-uuid",
    "name": "New Company",
    "createdAt": "2024-01-20T10:00:00Z"
  },
  "timestamp": "2024-01-20T10:00:01Z"
}
```

---

## Best Practices

1. **Use API Keys for integrations** - More secure than user tokens
2. **Implement retry logic** - Handle rate limits and transient errors
3. **Cache responses** - Reduce API calls with client-side caching
4. **Use cursor pagination** - More efficient than offset pagination
5. **Request only needed fields** - GraphQL allows precise data fetching
6. **Batch operations** - Use batch mutations when creating/updating multiple records
7. **Handle errors gracefully** - Check error codes and provide user feedback
8. **Monitor rate limits** - Track usage to avoid hitting limits

---

## Support

- **API Status**: [status.twenty.com](https://status.twenty.com)
- **Support Email**: support@twenty.com
- **Discord**: [discord.gg/twenty](https://discord.gg/twenty)
