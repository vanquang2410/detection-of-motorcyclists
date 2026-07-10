# Spring Boot Conventions (Auto-loaded)

## Architecture: 3-layer

- Controller → Service (interface) → Repository
- Controller KHÔNG gọi Repository trực tiếp
- Service KHÔNG trả Entity ra ngoài (map sang DTO)

## Interface Injection (BẮT BUỘC)

```java
// Interface
public interface UserService { ... }

// Implementation
@Service
public class UserServiceImpl implements UserService { ... }

// Injection — inject INTERFACE
private final UserService userService;
```

## Entity Design

- KHÔNG dùng @OneToMany, @ManyToOne, @ManyToMany
- Chỉ lưu UUID foreign key
- Related data load trong Service bằng explicit query

## Google Java Style

- `final` cho ALL method parameters
- `this.` khi truy cập instance fields/methods
- 2-space indent
- Không wildcard import

## Database

- Flyway migrations: `V{version}__{description}.sql`
- Migration đã merge → KHÔNG sửa, tạo migration mới
- Soft-delete: query phải có `is_deleted = false`
