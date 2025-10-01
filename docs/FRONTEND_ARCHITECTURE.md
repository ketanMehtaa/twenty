# Twenty Frontend Architecture Documentation

## Table of Contents
1. [Overview](#overview)
2. [Technology Stack](#technology-stack)
3. [Project Structure](#project-structure)
4. [Architecture Patterns](#architecture-patterns)
5. [Core Modules](#core-modules)
6. [State Management](#state-management)
7. [Routing](#routing)
8. [GraphQL Integration](#graphql-integration)
9. [Styling System](#styling-system)
10. [Component Library (UI Module)](#component-library-ui-module)
11. [Development Guidelines](#development-guidelines)

---

## Overview

The Twenty frontend (`twenty-front`) is a sophisticated React-based Single Page Application (SPA) that provides the user interface for the Twenty CRM platform. Built with modern web technologies and best practices, it offers a responsive, accessible, and performant user experience.

### Key Characteristics

- **Type-Safe**: Full TypeScript coverage with strict mode
- **Reactive**: Real-time updates via GraphQL subscriptions
- **Modular**: Feature-based architecture with clear boundaries
- **Testable**: Comprehensive test coverage with Jest and Storybook
- **Accessible**: ARIA compliance and keyboard navigation
- **Internationalized**: Multi-language support via Lingui

---

## Technology Stack

### Core Technologies

```
React 18.x              # UI Framework
├── TypeScript 5.x      # Type System
├── Recoil              # State Management
├── Emotion             # Styling (CSS-in-JS)
└── Vite                # Build Tool & Dev Server

Apollo Client           # GraphQL Client
├── GraphQL Code Gen    # Type Generation
└── Apollo Cache        # Normalized Cache

React Router 6.x        # Routing
Lingui                  # i18n
React Email             # Email Templates
```

### Development Tools

```
Storybook               # Component Documentation
Jest                    # Unit Testing
React Testing Library   # Component Testing
ESLint                  # Code Linting
Prettier                # Code Formatting
```

---

## Project Structure

```
twenty-front/
├── src/
│   ├── modules/                    # Feature modules (main application logic)
│   │   ├── activities/            # Activity management
│   │   ├── action-menu/           # Context menus
│   │   ├── auth/                  # Authentication
│   │   ├── object-record/         # Record CRUD operations
│   │   ├── object-metadata/       # Metadata management
│   │   ├── settings/              # Settings pages
│   │   ├── views/                 # View system (table/kanban)
│   │   ├── workflow/              # Workflow automation
│   │   ├── command-menu/          # Command palette (Cmd+K)
│   │   ├── favorites/             # Favorites system
│   │   ├── navigation/            # Navigation components
│   │   ├── search/                # Search functionality
│   │   └── ui/                    # UI component library
│   │       ├── display/           # Display components
│   │       ├── input/             # Input components
│   │       ├── feedback/          # Feedback components
│   │       ├── navigation/        # Navigation components
│   │       ├── layout/            # Layout components
│   │       └── utilities/         # Utility components
│   ├── pages/                      # Page-level components
│   │   ├── auth/                  # Auth pages (login, signup)
│   │   ├── object-record/         # Record pages
│   │   ├── onboarding/            # Onboarding flow
│   │   └── not-found/             # 404 page
│   ├── generated/                  # Generated GraphQL types
│   ├── generated-metadata/         # Generated metadata types
│   ├── hooks/                      # Global custom hooks
│   ├── utils/                      # Utility functions
│   ├── config/                     # Configuration
│   ├── locales/                    # i18n translations
│   └── index.tsx                   # Application entry point
├── .storybook/                     # Storybook configuration
├── public/                         # Static assets
├── __mocks__/                      # Test mocks
└── package.json                    # Dependencies
```

---

## Architecture Patterns

### Module-Based Architecture

Each feature is organized as a self-contained module following this structure:

```
feature-module/
├── components/              # React components
│   ├── FeatureComponent.tsx
│   └── __tests__/          # Component tests
├── hooks/                   # Custom hooks
│   ├── useFeature.ts
│   └── internal/           # Internal-only hooks
├── states/                  # Recoil atoms/selectors
│   ├── featureState.ts
│   └── selectors/          # Derived state
├── graphql/                 # GraphQL operations
│   ├── queries/            # Queries
│   ├── mutations/          # Mutations
│   └── fragments/          # Reusable fragments
├── contexts/                # React contexts (if needed)
├── constants/               # Module constants
├── types/                   # TypeScript types
└── utils/                   # Utility functions
```

### Component Architecture

```
┌─────────────────────────────────────────┐
│              Pages Layer                 │
│  (Route-level components)                │
│  - Compose features                      │
│  - Handle page-level logic               │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│           Module Layer                   │
│  (Feature-specific components)           │
│  - Business logic                        │
│  - Feature composition                   │
│  - State management                      │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│            UI Layer                      │
│  (Reusable UI components)                │
│  - No business logic                     │
│  - Pure presentation                     │
│  - Fully reusable                        │
└─────────────────────────────────────────┘
```

### Data Flow

```
User Action
    │
    ▼
Event Handler (Component)
    │
    ▼
Custom Hook (Business Logic)
    │
    ├──► Recoil State Update (Local State)
    │
    └──► GraphQL Mutation (Server State)
         │
         ▼
    Apollo Cache Update
         │
         ▼
    Component Re-render
         │
         ▼
    UI Update
```

---

## Core Modules

### 1. Auth Module (`modules/auth`)

Handles authentication and authorization:

**Components:**
- `SignInUp`: Login/signup form
- `PasswordReset`: Password reset flow
- `VerifyLoginTokenEffect`: Token verification

**Key Features:**
- JWT token management
- OAuth integration (Google, Microsoft)
- Session persistence
- Protected routes

**State:**
```typescript
// Current user state
const currentUserState = atom<User | null>({
  key: 'currentUserState',
  default: null,
});

// Authentication token
const authTokenState = atom<string | null>({
  key: 'authTokenState',
  default: null,
});
```

### 2. Object Record Module (`modules/object-record`)

Core CRUD functionality for records:

**Sub-modules:**
- `record-table/`: Table view implementation
- `record-board/`: Kanban view implementation
- `record-show/`: Record detail page
- `record-field/`: Field display/editing
- `record-inline-cell-edit/`: Inline editing

**Key Features:**
- Dynamic record rendering based on metadata
- Inline editing with optimistic updates
- Field validation
- Record relations
- Batch operations

**State:**
```typescript
// Selected record IDs
const selectedRecordIdsState = atomFamily<string[], string>({
  key: 'selectedRecordIdsState',
  default: [],
});

// Current record
const currentRecordState = atom<ObjectRecord | null>({
  key: 'currentRecordState',
  default: null,
});
```

### 3. Object Metadata Module (`modules/object-metadata`)

Manages object and field definitions:

**Key Features:**
- Object metadata CRUD
- Field metadata CRUD
- Relation management
- Type system handling

**GraphQL Operations:**
```graphql
query GetObjects {
  objects {
    id
    nameSingular
    namePlural
    labelSingular
    labelPlural
    fields {
      id
      name
      type
      label
    }
  }
}

mutation CreateField($input: CreateFieldInput!) {
  createField(input: $input) {
    id
    name
    type
  }
}
```

### 4. Views Module (`modules/views`)

Implements the view system (filters, sorting, grouping):

**Sub-modules:**
- `view-filter/`: Filter system
- `view-sort/`: Sorting system
- `view-group/`: Grouping system
- `view-bar/`: View toolbar

**Key Features:**
- Multiple view types (table, kanban)
- Complex filtering with AND/OR logic
- Multi-column sorting
- Group by functionality
- View persistence

**State:**
```typescript
// Current view
const currentViewState = atom<View | null>({
  key: 'currentViewState',
  default: null,
});

// View filters
const viewFiltersState = atomFamily<Filter[], string>({
  key: 'viewFiltersState',
  default: [],
});

// View sorts
const viewSortsState = atomFamily<Sort[], string>({
  key: 'viewSortsState',
  default: [],
});
```

### 5. Activities Module (`modules/activities`)

Activity tracking and timeline:

**Key Features:**
- Task management
- Note creation
- Email integration
- Activity timeline
- Comments

**Types:**
```typescript
type Activity = {
  id: string;
  type: 'TASK' | 'NOTE' | 'EMAIL';
  title: string;
  body?: string;
  dueAt?: Date;
  completedAt?: Date;
  assignee?: User;
  relatedRecords: ObjectRecord[];
};
```

### 6. Workflow Module (`modules/workflow`)

Workflow automation:

**Key Features:**
- Workflow builder UI
- Trigger configuration
- Action configuration
- Workflow execution status
- Version management

**Components:**
- `WorkflowBuilder`: Visual workflow editor
- `WorkflowTrigger`: Trigger configuration
- `WorkflowAction`: Action configuration
- `WorkflowVersions`: Version history

### 7. Settings Module (`modules/settings`)

Settings management:

**Sub-modules:**
- `settings-accounts/`: Account settings
- `settings-workspace/`: Workspace settings
- `settings-developers/`: API keys, webhooks
- `settings-data-model/`: Object/field management
- `settings-integrations/`: Integration settings

### 8. Command Menu Module (`modules/command-menu`)

Command palette (Cmd+K):

**Key Features:**
- Quick navigation
- Search across objects
- Keyboard shortcuts
- Action execution
- Recent items

**State:**
```typescript
const commandMenuOpenState = atom<boolean>({
  key: 'commandMenuOpenState',
  default: false,
});

const commandMenuSearchState = atom<string>({
  key: 'commandMenuSearchState',
  default: '',
});
```

### 9. Navigation Module (`modules/navigation`)

App navigation:

**Components:**
- `NavigationDrawer`: Main sidebar
- `NavigationBar`: Top navigation
- `Breadcrumbs`: Breadcrumb navigation
- `ObjectNavigationItems`: Dynamic object menu

### 10. UI Module (`modules/ui`)

Reusable UI component library (covered in detail below).

---

## State Management

### Recoil Architecture

Twenty uses **Recoil** for state management with these patterns:

#### 1. Atoms (State)

```typescript
import { atom } from 'recoil';

// Simple atom
export const counterState = atom<number>({
  key: 'counterState',
  default: 0,
});

// Atom with persistence
export const themeState = atom<'light' | 'dark'>({
  key: 'themeState',
  default: 'light',
  effects: [
    ({ setSelf, onSet }) => {
      const savedTheme = localStorage.getItem('theme');
      if (savedTheme) setSelf(savedTheme as 'light' | 'dark');
      
      onSet((newValue) => {
        localStorage.setItem('theme', newValue);
      });
    },
  ],
});
```

#### 2. Atom Families (Dynamic State)

```typescript
import { atomFamily } from 'recoil';

// State per component instance
export const componentStateFamily = atomFamily<State, string>({
  key: 'componentStateFamily',
  default: (instanceId) => getDefaultState(instanceId),
});

// Usage
const state = useRecoilValue(componentStateFamily('instance-1'));
```

#### 3. Selectors (Derived State)

```typescript
import { selector } from 'recoil';

// Computed value
export const filteredItemsSelector = selector<Item[]>({
  key: 'filteredItemsSelector',
  get: ({ get }) => {
    const items = get(itemsState);
    const filter = get(filterState);
    
    return items.filter(item => matchesFilter(item, filter));
  },
});

// Async selector
export const userDataSelector = selector<User>({
  key: 'userDataSelector',
  get: async ({ get }) => {
    const userId = get(currentUserIdState);
    const response = await fetch(`/api/users/${userId}`);
    return response.json();
  },
});
```

#### 4. Selector Families (Derived State per Parameter)

```typescript
import { selectorFamily } from 'recoil';

export const recordByIdSelector = selectorFamily<ObjectRecord | null, string>({
  key: 'recordByIdSelector',
  get: (recordId) => ({ get }) => {
    const records = get(recordsState);
    return records.find(r => r.id === recordId) ?? null;
  },
});
```

### State Organization

```
State Layer Organization:

Global State (atom)
    │
    ├─► UI State
    │   ├─► Theme, locale, sidebar state
    │   └─► Modal, drawer, dialog state
    │
    ├─► User State
    │   ├─► Current user, preferences
    │   └─► Authentication tokens
    │
    ├─► Domain State
    │   ├─► Records, metadata
    │   └─► Views, filters
    │
    └─► Component State (atomFamily)
        ├─► Table state per instance
        ├─► Form state per instance
        └─► Menu state per instance

Derived State (selector)
    │
    ├─► Filtered/sorted data
    ├─► Computed values
    └─► Async data fetching
```

---

## Routing

### Route Structure

```typescript
// Route hierarchy
<Route element={<AppRouterProviders />}>
  <Route element={<DefaultLayout />}>
    {/* Main app routes */}
    <Route path="/" element={<Navigate to="/objects/companies" />} />
    <Route path="/objects/:objectNamePlural" element={<RecordIndexPage />} />
    <Route path="/object/:objectNameSingular/:recordId" element={<RecordShowPage />} />
    
    {/* Settings routes */}
    <Route path="/settings/*" element={<SettingsRoutes />} />
    
    {/* 404 */}
    <Route path="*" element={<NotFound />} />
  </Route>
  
  <Route element={<BlankLayout />}>
    {/* Auth routes */}
    <Route path="/auth/signin" element={<SignInUp />} />
    <Route path="/auth/verify" element={<VerifyLoginTokenEffect />} />
    <Route path="/auth/reset-password" element={<PasswordReset />} />
    
    {/* Onboarding */}
    <Route path="/welcome" element={<CreateProfile />} />
    <Route path="/create-workspace" element={<CreateWorkspace />} />
  </Route>
</Route>
```

### Dynamic Routing

Routes are generated dynamically based on object metadata:

```typescript
// Object list route
/objects/companies  // List of companies
/objects/people     // List of people
/objects/tasks      // List of tasks

// Object detail route
/object/company/123    // Company detail
/object/person/456     // Person detail
/object/task/789       // Task detail
```

### Route Protection

```typescript
// Protected route wrapper
function ProtectedRoute({ children }) {
  const isAuthenticated = useRecoilValue(isAuthenticatedState);
  
  if (!isAuthenticated) {
    return <Navigate to="/auth/signin" />;
  }
  
  return children;
}
```

---

## GraphQL Integration

### Apollo Client Setup

```typescript
import { ApolloClient, InMemoryCache, createHttpLink } from '@apollo/client';

const httpLink = createHttpLink({
  uri: '/graphql',
  credentials: 'include',
});

const client = new ApolloClient({
  link: httpLink,
  cache: new InMemoryCache({
    typePolicies: {
      Query: {
        fields: {
          // Custom cache policies
        },
      },
    },
  }),
});
```

### Code Generation

GraphQL types are automatically generated:

```bash
# Generate types
npx nx run twenty-front:graphql:generate
```

This creates:
- TypeScript types for all GraphQL types
- Typed hooks for queries and mutations
- Type-safe fragment types

### Query Example

```typescript
import { useGetCompaniesQuery } from '~/generated/graphql';

function CompanyList() {
  const { data, loading, error } = useGetCompaniesQuery({
    variables: {
      filter: { name: { startsWith: 'A' } },
      orderBy: [{ name: 'ASC' }],
    },
  });
  
  if (loading) return <Loader />;
  if (error) return <Error error={error} />;
  
  return (
    <div>
      {data?.companies.map(company => (
        <CompanyCard key={company.id} company={company} />
      ))}
    </div>
  );
}
```

### Mutation Example

```typescript
import { useCreateCompanyMutation } from '~/generated/graphql';

function CreateCompanyForm() {
  const [createCompany, { loading }] = useCreateCompanyMutation({
    // Optimistic update
    optimisticResponse: {
      createCompany: {
        __typename: 'Company',
        id: 'temp-id',
        name: formData.name,
      },
    },
    // Cache update
    update: (cache, { data }) => {
      cache.modify({
        fields: {
          companies(existing = []) {
            const newRef = cache.writeFragment({
              data: data?.createCompany,
              fragment: CompanyFragmentDoc,
            });
            return [...existing, newRef];
          },
        },
      });
    },
  });
  
  const handleSubmit = async (formData) => {
    await createCompany({
      variables: { input: formData },
    });
  };
  
  return <form onSubmit={handleSubmit}>...</form>;
}
```

### Fragment Example

```graphql
# fragments.graphql
fragment CompanyFields on Company {
  id
  name
  domainName
  employees
  createdAt
  updatedAt
}

# query using fragment
query GetCompanies {
  companies {
    ...CompanyFields
  }
}
```

---

## Styling System

### Emotion CSS-in-JS

Twenty uses Emotion for styling with a styled-components pattern:

```typescript
import styled from '@emotion/styled';

const StyledButton = styled.button<{ variant: 'primary' | 'secondary' }>`
  padding: ${({ theme }) => theme.spacing(2)};
  background: ${({ theme, variant }) => 
    variant === 'primary' ? theme.palette.primary : theme.palette.secondary
  };
  border-radius: ${({ theme }) => theme.borderRadius};
  
  &:hover {
    opacity: 0.8;
  }
`;
```

### Theme System

```typescript
// Theme structure
const theme = {
  palette: {
    primary: '#0088ff',
    secondary: '#6c757d',
    success: '#28a745',
    error: '#dc3545',
    warning: '#ffc107',
    background: '#ffffff',
    text: '#212529',
  },
  spacing: (factor: number) => `${factor * 8}px`,
  borderRadius: '8px',
  typography: {
    fontFamily: 'Inter, sans-serif',
    fontSize: {
      small: '12px',
      medium: '14px',
      large: '16px',
    },
  },
  shadows: {
    small: '0 1px 3px rgba(0,0,0,0.1)',
    medium: '0 4px 6px rgba(0,0,0,0.1)',
    large: '0 10px 20px rgba(0,0,0,0.1)',
  },
};
```

### Responsive Design

```typescript
const breakpoints = {
  mobile: '576px',
  tablet: '768px',
  desktop: '1024px',
  wide: '1440px',
};

const StyledContainer = styled.div`
  padding: 16px;
  
  @media (min-width: ${breakpoints.tablet}) {
    padding: 24px;
  }
  
  @media (min-width: ${breakpoints.desktop}) {
    padding: 32px;
  }
`;
```

---

## Component Library (UI Module)

The `modules/ui` directory contains all reusable UI components organized by category:

### Display Components (`modules/ui/display`)

- **Chip**: Small tag/label component
- **Tag**: Larger tag with colors
- **Checkmark**: Success indicator
- **Icon**: Icon component (using Tabler Icons)
- **SoonPill**: "Coming soon" indicator
- **AppTooltip**: Tooltip component

### Input Components (`modules/ui/input`)

- **Button**: Various button styles
- **TextInput**: Text field
- **Checkbox**: Checkbox input
- **Radio**: Radio button
- **Select**: Dropdown select
- **Toggle**: Toggle switch
- **IconPicker**: Icon selection UI
- **ImageInput**: Image upload
- **ColorPicker**: Color selection
- **BlockEditor**: Rich text editor

### Feedback Components (`modules/ui/feedback`)

- **ProgressBar**: Progress indicator
- **Loader**: Loading spinner
- **SnackBar**: Toast notifications
- **ConfirmationModal**: Confirmation dialog

### Navigation Components (`modules/ui/navigation`)

- **NavigationDrawer**: Side drawer
- **Breadcrumb**: Breadcrumb trail
- **Tabs**: Tab navigation
- **VerticalMenu**: Vertical menu
- **Dropdown**: Dropdown menu

### Layout Components (`modules/ui/layout`)

- **Card**: Card container
- **Section**: Content section
- **Page**: Page wrapper
- **ShowPageContainer**: Detail page layout
- **RightDrawer**: Right side drawer
- **Modal**: Modal dialog

### Data Components (`modules/ui/data`)

- **RecordTable**: Data table
- **RecordBoard**: Kanban board
- **DataGrid**: Grid view
- **FilterBar**: Filter controls
- **SortBar**: Sort controls

---

## Development Guidelines

### Code Style

1. **Use functional components**
```typescript
// ✅ Good
export const MyComponent = ({ prop }: Props) => {
  return <div>{prop}</div>;
};

// ❌ Bad
export class MyComponent extends React.Component {
  render() {
    return <div>{this.props.prop}</div>;
  }
}
```

2. **Named exports only**
```typescript
// ✅ Good
export const MyComponent = () => { ... };

// ❌ Bad
export default MyComponent;
```

3. **Types over interfaces**
```typescript
// ✅ Good
type User = {
  id: string;
  name: string;
};

// ❌ Bad (unless extending)
interface User {
  id: string;
  name: string;
}
```

4. **Event handlers over useEffect**
```typescript
// ✅ Good
const handleClick = () => {
  setCount(count + 1);
};

// ❌ Bad (unless necessary)
useEffect(() => {
  setCount(count + 1);
}, [someValue]);
```

5. **No 'any' type**
```typescript
// ✅ Good
const processData = (data: UserData) => { ... };

// ❌ Bad
const processData = (data: any) => { ... };
```

### Testing

```typescript
// Component test example
import { render, screen } from '@testing-library/react';
import { MyComponent } from './MyComponent';

describe('MyComponent', () => {
  it('renders correctly', () => {
    render(<MyComponent title="Test" />);
    expect(screen.getByText('Test')).toBeInTheDocument();
  });
  
  it('handles click events', async () => {
    const handleClick = jest.fn();
    render(<MyComponent onClick={handleClick} />);
    
    await userEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});
```

### Storybook

```typescript
// Component story example
import type { Meta, StoryObj } from '@storybook/react';
import { MyComponent } from './MyComponent';

const meta: Meta<typeof MyComponent> = {
  title: 'UI/MyComponent',
  component: MyComponent,
  args: {
    variant: 'primary',
  },
};

export default meta;
type Story = StoryObj<typeof MyComponent>;

export const Default: Story = {
  args: {
    title: 'Default Button',
  },
};

export const Secondary: Story = {
  args: {
    variant: 'secondary',
    title: 'Secondary Button',
  },
};
```

### Performance Optimization

1. **Use React.memo for expensive components**
```typescript
export const ExpensiveComponent = React.memo(({ data }: Props) => {
  // Expensive rendering logic
  return <div>...</div>;
});
```

2. **Use useMemo for expensive computations**
```typescript
const sortedData = useMemo(
  () => data.sort(sortFn),
  [data, sortFn]
);
```

3. **Use useCallback for event handlers**
```typescript
const handleClick = useCallback(() => {
  doSomething(value);
}, [value]);
```

4. **Lazy load routes**
```typescript
const SettingsPage = lazy(() => import('./pages/Settings'));
```

---

## Additional Resources

### Internal Documentation
- [Folder Architecture](../packages/twenty-website/src/content/developers/frontend-development/folder-architecture-front.mdx)
- [Frontend Commands](../packages/twenty-website/src/content/developers/frontend-development/frontend-commands.mdx)
- [Style Guide](../packages/twenty-website/src/content/developers/frontend-development/style-guide.mdx)
- [Best Practices](../packages/twenty-website/src/content/developers/frontend-development/best-practices-front.mdx)

### External Resources
- [React Documentation](https://react.dev)
- [Recoil Documentation](https://recoiljs.org)
- [Apollo Client Documentation](https://www.apollographql.com/docs/react)
- [Emotion Documentation](https://emotion.sh/docs/introduction)
- [TypeScript Handbook](https://www.typescriptlang.org/docs)

---

This documentation provides a comprehensive overview of the Twenty frontend architecture. For specific implementation details, refer to the code and inline documentation.
