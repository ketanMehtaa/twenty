# Twenty Workers

## Overview

Twenty Workers is the background job processing system for the Twenty CRM application. It handles asynchronous tasks, scheduled jobs, and long-running operations separately from the main API server to ensure optimal performance and scalability.

## What are Twenty Workers?

Twenty Workers are separate Node.js processes that consume and execute jobs from Redis-backed message queues. They operate independently from the main Twenty server, allowing for:

- **Asynchronous Processing**: Offload time-consuming tasks from HTTP request/response cycles
- **Scalability**: Scale workers independently based on workload
- **Reliability**: Retry failed jobs automatically with configurable strategies
- **Resource Isolation**: Prevent heavy background tasks from affecting API responsiveness

## Architecture

### High-Level Architecture

```mermaid
graph TB
    subgraph "Twenty Application"
        Server[Twenty Server<br/>NestJS API]
        Worker[Twenty Worker<br/>Background Processor]
    end
    
    subgraph "Data Layer"
        Redis[(Redis<br/>Message Queue)]
        Postgres[(PostgreSQL<br/>Database)]
    end
    
    subgraph "External Services"
        Email[Email Services]
        Storage[File Storage]
        Calendar[Calendar APIs]
        Messaging[Messaging APIs]
    end
    
    Server -->|Add Jobs| Redis
    Worker -->|Consume Jobs| Redis
    Worker -->|Read/Write| Postgres
    Server -->|Read/Write| Postgres
    Worker -->|Send| Email
    Worker -->|Upload/Download| Storage
    Worker -->|Sync| Calendar
    Worker -->|Sync| Messaging
```

### Component Architecture

```mermaid
graph LR
    subgraph "Worker Process"
        QWM[QueueWorkerModule]
        MQE[MessageQueueExplorer]
        
        subgraph "Job Processors"
            EmailJob[Email Jobs]
            WebhookJob[Webhook Jobs]
            MessagingJob[Messaging Jobs]
            CalendarJob[Calendar Jobs]
            CronJob[Cron Jobs]
            WorkflowJob[Workflow Jobs]
            OtherJobs[Other Jobs...]
        end
        
        QWM --> MQE
        MQE --> EmailJob
        MQE --> WebhookJob
        MQE --> MessagingJob
        MQE --> CalendarJob
        MQE --> CronJob
        MQE --> WorkflowJob
        MQE --> OtherJobs
    end
    
    Redis[(Redis/BullMQ)] -->|Jobs| MQE
```

## Core Components

### 1. Queue Worker Module

**Location**: `src/queue-worker/queue-worker.module.ts`

The main module that bootstraps the worker process. It imports:

- **CoreEngineModule**: Core Twenty engine functionality
- **MessageQueueModule**: Message queue infrastructure with job explorer
- **WorkspaceEventEmitterModule**: Event emission system
- **JobsModule**: All job processor definitions
- **TwentyORMModule**: Database access layer

```typescript
@Module({
  imports: [
    CoreEngineModule,
    MessageQueueModule.registerExplorer(),
    WorkspaceEventEmitterModule,
    JobsModule,
    TwentyORMModule,
  ],
})
export class QueueWorkerModule {}
```

### 2. Queue Worker Bootstrap

**Location**: `src/queue-worker/queue-worker.ts`

Entry point that initializes the worker process:

```typescript
async function bootstrap() {
  const app = await NestFactory.createApplicationContext(QueueWorkerModule, {
    bufferLogs: process.env.LOGGER_IS_BUFFER_ENABLED === 'true',
  });

  loggerService = app.get(LoggerService);
  exceptionHandlerService = app.get(ExceptionHandlerService);
  
  app.useLogger(loggerService ?? false);
}
```

### 3. Message Queue System

**Location**: `src/engine/core-modules/message-queue/`

Built on top of **BullMQ** (a Redis-based queue library), the message queue system provides:

#### BullMQ Driver

**File**: `drivers/bullmq.driver.ts`

- Manages Queue and Worker instances
- Handles job addition, removal, and processing
- Supports both regular jobs and cron jobs
- Provides job retry and failure handling

#### Message Queue Service

**File**: `services/message-queue.service.ts`

High-level API for interacting with queues:

```typescript
class MessageQueueService {
  // Add a job to the queue
  add<T>(jobName: string, data: T, options?: QueueJobOptions): Promise<void>
  
  // Add a recurring cron job
  addCron<T>({jobName, data, options, jobId}): Promise<void>
  
  // Remove a cron job
  removeCron({jobName, jobId}): Promise<void>
  
  // Register a worker to process jobs
  work<T>(handler: (job: Job<T>) => Promise<void>, options?: WorkerOptions)
}
```

### 4. Job Processors

Job processors are classes decorated with `@Processor` that handle specific job types.

#### Processor Decorator

```typescript
@Processor({ queueName: MessageQueue.emailQueue, scope: Scope.REQUEST })
export class EmailSenderJob {
  @Process(EmailSenderJob.name)
  async handle(data: EmailJobData): Promise<void> {
    // Job implementation
  }
}
```

**Key Decorators**:
- `@Processor`: Marks a class as a job processor and associates it with a queue
- `@Process`: Marks a method as the handler for a specific job name
- `@InjectMessageQueue`: Injects a message queue service for adding jobs

#### Scope Options

- **Scope.DEFAULT**: Singleton instance shared across all jobs
- **Scope.REQUEST**: New instance created for each job (with workspace context)

### 5. Message Queue Explorer

**Location**: `src/engine/core-modules/message-queue/message-queue.explorer.ts`

Automatically discovers and registers job processors at startup:

1. **Discovery**: Scans for classes decorated with `@Processor`
2. **Grouping**: Groups processors by queue name
3. **Registration**: Registers worker handlers for each queue
4. **Execution**: Routes incoming jobs to the appropriate processor methods

## Available Job Queues

Twenty uses multiple specialized queues for different types of operations:

| Queue Name | Purpose | Example Jobs |
|-----------|---------|--------------|
| `emailQueue` | Email sending operations | Welcome emails, notifications, alerts |
| `webhookQueue` | Webhook delivery | Trigger external webhooks on events |
| `messagingQueue` | Email/messaging sync | Gmail, Outlook message synchronization |
| `calendarQueue` | Calendar sync | Google Calendar, Microsoft Calendar sync |
| `cronQueue` | Scheduled recurring jobs | Cleanup tasks, periodic syncs |
| `workflowQueue` | Workflow automation | Workflow triggers and execution |
| `workspaceQueue` | Workspace operations | Workspace cleanup, member management |
| `billingQueue` | Billing operations | Subscription updates, usage tracking |
| `contactCreationQueue` | Contact auto-creation | Auto-create contacts from messages |
| `entityEventsToDbQueue` | Event persistence | Save events to database |
| `deleteCascadeQueue` | Cascading deletes | Delete related records |
| `serverlessFunctionQueue` | Serverless function execution | Execute custom serverless functions |
| `triggerQueue` | Database event triggers | React to database changes |
| `taskAssignedQueue` | Task notifications | Notify users of task assignments |

## Job Types

### 1. Regular Jobs

One-time jobs added to the queue for immediate or delayed processing:

```typescript
// Adding a job from anywhere in the application
@InjectMessageQueue(MessageQueue.emailQueue)
private messageQueueService: MessageQueueService;

await this.messageQueueService.add(
  EmailSenderJob.name,
  { email: 'user@example.com', template: 'welcome' },
  { priority: 1 }
);
```

### 2. Cron Jobs

Recurring jobs that run on a schedule:

```typescript
@Processor(MessageQueue.cronQueue)
export class CleanOnboardingWorkspacesJob {
  @Process(CleanOnboardingWorkspacesJob.name)
  @SentryCronMonitor(
    CleanOnboardingWorkspacesJob.name,
    '0 0 * * *' // Daily at midnight
  )
  async handle(): Promise<void> {
    // Cleanup logic
  }
}
```

**Cron Pattern Examples**:
- `* * * * *` - Every minute
- `0 * * * *` - Every hour
- `0 0 * * *` - Daily at midnight
- `0 0 * * 0` - Weekly on Sunday

### 3. Request-Scoped Jobs

Jobs that need workspace-specific context:

```typescript
@Processor({ 
  queueName: MessageQueue.workspaceQueue, 
  scope: Scope.REQUEST 
})
export class WorkspaceSpecificJob {
  constructor(
    private readonly twentyORMGlobalManager: TwentyORMGlobalManager
  ) {}

  @Process(WorkspaceSpecificJob.name)
  async handle(data: { workspaceId: string }): Promise<void> {
    // Access workspace-scoped services
  }
}
```

## Deployment

### Docker Compose

The worker runs as a separate service alongside the main server:

```yaml
services:
  server:
    image: twentycrm/twenty:latest
    # Server configuration...

  worker:
    image: twentycrm/twenty:latest
    command: ["yarn", "worker:prod"]
    environment:
      PG_DATABASE_URL: postgres://user:pass@db:5432/default
      REDIS_URL: redis://redis:6379
      DISABLE_DB_MIGRATIONS: "true"
      DISABLE_CRON_JOBS_REGISTRATION: "true"
    depends_on:
      - db
      - redis
```

**Important Environment Variables**:

- `REDIS_URL`: Redis connection string for job queues
- `PG_DATABASE_URL`: PostgreSQL connection string
- `DISABLE_DB_MIGRATIONS`: Should be "true" for workers (run on server only)
- `DISABLE_CRON_JOBS_REGISTRATION`: Set to "true" to prevent duplicate cron jobs

### Kubernetes

**Deployment Configuration**: `packages/twenty-docker/k8s/manifests/deployment-worker.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: twentycrm-worker
spec:
  replicas: 1  # Scale based on workload
  template:
    spec:
      containers:
        - name: twentycrm
          image: twentycrm/twenty:latest
          command: ["yarn", "worker:prod"]
          resources:
            requests:
              memory: "1024Mi"
              cpu: "250m"
            limits:
              memory: "2048Mi"
              cpu: "1000m"
```

**Scaling Considerations**:
- Start with 1 replica and monitor queue depths
- Scale horizontally by increasing replicas
- Each worker instance can process multiple jobs concurrently
- BullMQ handles job distribution across workers automatically

### Podman

**Script**: `packages/twenty-docker/podman/manual-steps-to-deploy-twenty-on-podman`

```bash
podman run -d --pod twenty-pod --name twenty-worker \
  --init \
  -e SERVER_URL="$SERVER_URL" \
  -e PG_DATABASE_URL="postgresql://twenty:$POSTGRES_PASSWORD@twenty-db:5432/twenty" \
  -e REDIS_URL="redis://twenty-redis:6379" \
  -e APP_SECRET="$APP_SECRET" \
  -e DISABLE_DB_MIGRATIONS=true \
  -e NODE_ENV=production \
  -v twenty-server-data:/app/docker-data:Z \
  docker.io/twentycrm/twenty:latest \
  yarn worker:prod
```

## Development

### Running Workers Locally

**Development Mode**:
```bash
# Start the worker in development mode with auto-reload
npx nx run twenty-server:worker

# Or start the full stack including worker
yarn start
```

**Production Build**:
```bash
# Build the server (includes worker)
npx nx build twenty-server

# Run the built worker
yarn workspace twenty-server worker:prod
```

### Creating a New Job

1. **Create the Job Processor**:

```typescript
// src/modules/my-feature/jobs/my-task.job.ts
import { Processor } from 'src/engine/core-modules/message-queue/decorators/processor.decorator';
import { Process } from 'src/engine/core-modules/message-queue/decorators/process.decorator';
import { MessageQueue } from 'src/engine/core-modules/message-queue/message-queue.constants';

export type MyTaskJobData = {
  taskId: string;
  workspaceId: string;
};

@Processor({ queueName: MessageQueue.workspaceQueue })
export class MyTaskJob {
  constructor(
    // Inject required services
  ) {}

  @Process(MyTaskJob.name)
  async handle(data: MyTaskJobData): Promise<void> {
    // Implementation
    console.log(`Processing task ${data.taskId}`);
  }
}
```

2. **Register in JobsModule**:

```typescript
// src/engine/core-modules/message-queue/jobs.module.ts
import { MyTaskJob } from 'src/modules/my-feature/jobs/my-task.job';

@Module({
  imports: [
    // ... other imports
  ],
  providers: [
    // ... other providers
    MyTaskJob,
  ],
})
export class JobsModule {}
```

3. **Add the Job to Queue**:

```typescript
// From any service
import { InjectMessageQueue } from 'src/engine/core-modules/message-queue/decorators/message-queue.decorator';
import { MessageQueueService } from 'src/engine/core-modules/message-queue/services/message-queue.service';
import { MyTaskJob } from './jobs/my-task.job';

@Injectable()
export class MyService {
  constructor(
    @InjectMessageQueue(MessageQueue.workspaceQueue)
    private messageQueueService: MessageQueueService,
  ) {}

  async triggerTask(taskId: string, workspaceId: string) {
    await this.messageQueueService.add(
      MyTaskJob.name,
      { taskId, workspaceId },
      { priority: 1 }
    );
  }
}
```

### Creating a Cron Job

```typescript
// src/modules/my-feature/crons/my-scheduled-task.cron.job.ts
import { Processor } from 'src/engine/core-modules/message-queue/decorators/processor.decorator';
import { Process } from 'src/engine/core-modules/message-queue/decorators/process.decorator';
import { SentryCronMonitor } from 'src/engine/core-modules/cron/sentry-cron-monitor.decorator';
import { MessageQueue } from 'src/engine/core-modules/message-queue/message-queue.constants';

export const MY_SCHEDULED_TASK_CRON_PATTERN = '0 2 * * *'; // 2 AM daily

@Processor(MessageQueue.cronQueue)
export class MyScheduledTaskCronJob {
  @Process(MyScheduledTaskCronJob.name)
  @SentryCronMonitor(
    MyScheduledTaskCronJob.name,
    MY_SCHEDULED_TASK_CRON_PATTERN
  )
  async handle(): Promise<void> {
    // Scheduled task implementation
  }
}
```

## Job Options

### Queue Job Options

```typescript
interface QueueJobOptions {
  priority?: number;        // Job priority (lower = higher priority)
  delay?: number;          // Delay in milliseconds before processing
  attempts?: number;       // Number of retry attempts
  backoff?: {             // Retry backoff strategy
    type: 'exponential' | 'fixed';
    delay: number;
  };
  removeOnComplete?: boolean | number;  // Remove job after completion
  removeOnFail?: boolean | number;      // Remove job after failure
}
```

**Example**:
```typescript
await messageQueueService.add(
  JobName.name,
  jobData,
  {
    priority: 1,
    attempts: 3,
    backoff: { type: 'exponential', delay: 5000 },
    removeOnComplete: true,
  }
);
```

### Worker Options

```typescript
interface MessageQueueWorkerOptions {
  concurrency?: number;  // Number of jobs to process simultaneously
}
```

## Monitoring and Observability

### Health Checks

The worker process includes health monitoring:

**Location**: `src/engine/core-modules/health/indicators/worker.health.ts`

Monitors:
- Queue connection status
- Job processing metrics
- Worker health status
- Failed job counts

### Logging

Workers use the same logging infrastructure as the main server:

```typescript
import { Logger } from '@nestjs/common';

@Processor(MessageQueue.myQueue)
export class MyJob {
  private readonly logger = new Logger(MyJob.name);

  @Process(MyJob.name)
  async handle(data: MyJobData): Promise<void> {
    this.logger.log(`Processing job for ${data.id}`);
    // ...
    this.logger.log(`Completed job for ${data.id}`);
  }
}
```

### Error Handling

The message queue system includes automatic error handling:

1. **Automatic Retries**: Failed jobs are retried based on configuration
2. **Exception Capture**: Errors are captured and sent to Sentry
3. **Dead Letter Queue**: Jobs that exceed retry attempts are moved to failed state

```typescript
@Process(MyJob.name)
async handle(data: MyJobData): Promise<void> {
  try {
    // Job logic
  } catch (error) {
    // Error is automatically captured
    // Job will be retried based on configuration
    throw error;
  }
}
```

## Performance Considerations

### Concurrency

Each worker can process multiple jobs concurrently:

```typescript
// In the worker registration
queue.work(
  async (job) => {
    // Process job
  },
  { concurrency: 5 } // Process up to 5 jobs simultaneously
);
```

**Guidelines**:
- Start with concurrency of 1-5 per worker
- Monitor memory and CPU usage
- Increase concurrency for I/O-bound jobs
- Keep concurrency low for CPU-intensive jobs

### Queue Priorities

Use priorities to ensure critical jobs are processed first:

- Priority 1: Critical (immediate user-facing operations)
- Priority 5: Normal (standard background tasks)
- Priority 10: Low (cleanup, maintenance tasks)

### Job Batching

For high-volume operations, consider batching:

```typescript
const jobs = items.map(item => ({
  name: MyJob.name,
  data: { itemId: item.id },
}));

// Add jobs in bulk (more efficient)
await queue.addBulk(jobs);
```

## Troubleshooting

### Worker Not Starting

**Check**:
1. Redis connection: `REDIS_URL` environment variable
2. Database connection: `PG_DATABASE_URL` environment variable
3. Application logs for startup errors

```bash
# Check worker logs
docker logs twenty-worker

# Or in Kubernetes
kubectl logs -f deployment/twentycrm-worker
```

### Jobs Not Being Processed

**Possible Causes**:
1. Worker not running
2. Job processor not registered in `JobsModule`
3. Queue name mismatch between producer and consumer
4. Worker crashed (check logs)

**Debugging**:
```typescript
// Add detailed logging
@Process(MyJob.name)
async handle(data: MyJobData): Promise<void> {
  this.logger.log(`Starting job processing`, data);
  // ...
  this.logger.log(`Job completed`);
}
```

### Jobs Failing Repeatedly

**Check**:
1. Error messages in worker logs
2. Job data validity
3. External service availability (email, storage, APIs)
4. Database constraints and permissions

**Solution**:
- Increase retry attempts with exponential backoff
- Add input validation
- Implement circuit breakers for external services

### Memory Issues

**Symptoms**:
- Worker process crashes
- Out of memory errors
- Slow job processing

**Solutions**:
1. Reduce worker concurrency
2. Process large datasets in smaller batches
3. Increase worker memory limits
4. Scale horizontally (more worker instances)

```yaml
# Kubernetes resource limits
resources:
  limits:
    memory: "2048Mi"  # Increase if needed
    cpu: "1000m"
```

### Redis Connection Issues

**Check**:
- Redis server is running
- Network connectivity
- Redis URL format: `redis://[username][:password]@host:port`
- Redis authentication if required

## Best Practices

### 1. Job Design

- **Idempotent**: Jobs should produce the same result when executed multiple times
- **Small Payloads**: Keep job data small; store large data in database and pass IDs
- **Single Responsibility**: Each job should do one thing well
- **Timeout Handling**: Implement timeouts for external API calls

### 2. Error Handling

- **Graceful Degradation**: Handle failures gracefully
- **Meaningful Errors**: Throw errors with clear messages
- **Retry Strategy**: Configure appropriate retry attempts and backoff
- **Logging**: Log both success and failure cases

### 3. Performance

- **Batch Operations**: Group multiple database operations
- **Connection Pooling**: Reuse database connections
- **Rate Limiting**: Respect external API rate limits
- **Monitoring**: Track job execution times and failure rates

### 4. Testing

```typescript
describe('MyJob', () => {
  it('should process job successfully', async () => {
    const job = new MyJob(/* inject dependencies */);
    
    await expect(
      job.handle({ taskId: '123', workspaceId: 'abc' })
    ).resolves.not.toThrow();
  });

  it('should retry on failure', async () => {
    // Test retry logic
  });
});
```

## Related Documentation

- [Message Queue Module](./src/engine/core-modules/message-queue/README.md) - Message queue system details
- [BullMQ Documentation](https://docs.bullmq.io/) - Underlying queue library
- [NestJS Workers](https://docs.nestjs.com/techniques/queues) - NestJS queue concepts
- [Redis Documentation](https://redis.io/docs/) - Redis server documentation

## Example Jobs in Twenty

### Email Sender Job

Sends transactional emails:

**Location**: `src/engine/core-modules/email/email-sender.job.ts`

```typescript
@Processor({ queueName: MessageQueue.emailQueue })
export class EmailSenderJob {
  @Process(EmailSenderJob.name)
  async handle(data: EmailJobData): Promise<void> {
    await this.emailService.send({
      from: data.from,
      to: data.to,
      subject: data.subject,
      html: data.html,
    });
  }
}
```

### Webhook Job

Delivers webhooks to external endpoints:

**Location**: `src/engine/core-modules/webhook/jobs/call-webhook.job.ts`

Handles webhook delivery with retry logic and failure tracking.

### Messaging Sync Jobs

Synchronize emails from Gmail/Outlook:

**Location**: `src/modules/messaging/`

Periodically fetches and processes messages from external providers.

### Calendar Sync Jobs

Synchronize calendar events:

**Location**: `src/modules/calendar/`

Syncs events from Google Calendar and Microsoft Calendar.

### Workflow Jobs

Execute workflow automation:

**Location**: `src/modules/workflow/`

Triggers and executes automated workflows based on events.

## Conclusion

Twenty Workers provide a robust, scalable background job processing system that:

- Separates long-running tasks from API requests
- Scales independently based on workload
- Handles failures gracefully with automatic retries
- Supports scheduled recurring jobs
- Integrates seamlessly with the rest of the Twenty application

By understanding the worker architecture and following best practices, you can build reliable background processing for any feature in Twenty CRM.
