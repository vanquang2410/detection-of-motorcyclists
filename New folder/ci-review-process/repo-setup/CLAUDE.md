# CLAUDE.md — Template

> Copy file này vào root repo dự án và điền thông tin cụ thể.

## Project Overview

{MÔ TẢ DỰ ÁN} — Spring Boot 4.0.1 service.

## Tech Stack

- Java 25 + Spring Boot 4.0.1
- PostgreSQL with Spring Data JPA
- Redis for caching
- Flyway for database migrations
- Lombok for boilerplate reduction
- Maven build system

## Build Commands

```bash
./mvnw clean install        # Build project
./mvnw spring-boot:run      # Run application
./mvnw test                 # Run tests
./mvnw test -Dtest=ClassName # Run single test class
./mvnw package -DskipTests  # Package without tests
```

## Architecture

3-layer architecture:

```
src/main/java/...
├── controller/      # REST endpoints (@RestController)
├── service/         # Business logic (interface + impl)
├── repository/      # JPA Data access (@Repository)
├── entity/          # JPA entities (@Entity)
├── dto/             # Request/Response DTOs
├── config/          # Configuration classes
├── constants/       # Centralized constants & enums
└── exception/       # Custom exceptions & global handler
```

## Coding Standards

### Interface Injection (BẮT BUỘC)

```java
public interface UserService { ... }

@Service
public class UserServiceImpl implements UserService { ... }

// Inject interface, KHÔNG impl
private final UserService userService;
```

### Entity Design — NO Relationship Annotations

```java
// ✅ ĐÚNG — chỉ UUID
@Column(name = "workspace_id", nullable = false)
private UUID workspaceId;

// ❌ SAI — không dùng
@ManyToOne private Workspace workspace;
```

### Google Java Style

- `final` cho ALL method parameters
- `this.` khi truy cập instance fields/methods
- 2-space indent, không wildcard import

### N+1 Prevention

```java
// ❌ N+1: findById trong loop
// ✅ Batch: findAllById + Map
```

## Database

- Flyway: `V{version}__{description}.sql`
- Migration đã merge → KHÔNG sửa
- Soft-delete: query PHẢI có `is_deleted = false`

## Review Process

Xem `docs/process/05-review-rules.md` cho bộ rule đầy đủ.
