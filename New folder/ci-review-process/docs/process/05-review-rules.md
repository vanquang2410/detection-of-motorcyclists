# 05 — Bộ Rule Review Code

> File này là **source-of-truth** cho AI review (tầng 1) và tham chiếu cho người review (tầng 2).
> Áp dụng cho dự án **Spring Boot 4.0.1 / Java 25** với **PostgreSQL + Redis + Flyway**.

---

## 1. Nguyên tắc chung

- **Chỉ review code trong diff** — không soi code ngoài phạm vi PR trừ khi cần kiểm chứng
  (VD: kiểm tra query đã có `is_deleted = false` chưa).
- **Finding phải có căn cứ** — trỏ về rule cụ thể hoặc lỗi correctness rõ ràng.
- **Không bịa rule mới** — mọi finding phải thuộc bộ rule bên dưới.
- **AI không approve / request-changes** — chỉ liệt kê finding, người review quyết định.

---

## 2. Nhóm 1 — Đối chiếu giải pháp

| Rule | Nội dung |
|------|----------|
| **1.1** | Code phải khớp với giải pháp trong solution doc (`docs/solutions/{PREFIX}-*.md`). Sai lệch đáng kể → `[must]`. |
| **1.2** | Mỗi AC trong solution doc phải có code + test tương ứng. AC thiếu code/test → `[must]`. |
| **1.3** | Không có code ngoài scope solution doc mà không giải thích trong PR description → `[nit]`. |
| **1.4** | Solution doc phải **đã tồn tại trên `develop`** (PR doc được Approve + merge trước khi code). Kiểm tra: `git show origin/develop:<path>` — chưa tồn tại → `[must]` (code trước khi giải pháp được duyệt). Đã tồn tại trên develop nhưng còn trong diff → `[nit]` nhắc dev chạy `git pull --no-rebase origin develop`. |

---

## 3. Nhóm 2 — Correctness & Safety

| Rule | Nội dung |
|------|----------|
| **2.1** | Null safety: không trả `null` khi contract là `Optional` hoặc non-null. Dùng `Optional` + `orElseThrow()`. |
| **2.2** | Exception handling: custom exception kế thừa `BusinessException` hoặc `ResourceNotFoundException`. Không catch generic `Exception` trừ khi cần thiết, không nuốt exception (empty catch). |
| **2.3** | SQL injection: query phải dùng parameterized (`@Param`) hoặc JPA method naming. Không nối chuỗi trong `@Query`. |
| **2.4** | Soft-delete: query đọc phải có `is_deleted = false` (hoặc dùng `@Where`). Thiếu → trả dữ liệu đã xóa → `[must]`. |
| **2.5** | Race condition: thao tác write concurrent phải có cơ chế bảo vệ (`@Version` optimistic lock, hoặc DB constraint). |
| **2.6** | Secrets: không hardcode API key, password, token. Dùng `@Value("${...}")` hoặc environment variable. |
| **2.7** | Authorization: endpoint phải kiểm tra quyền (role/permission) trước khi thực thi business logic. Thiếu check → `[must]`. |
| **2.8** | Input validation: request DTO phải có `@Valid` + Bean Validation annotations (`@NotNull`, `@Size`, `@Email`...). Thiếu → `[must]`. |

---

## 4. Nhóm 3 — Convention Backend (Spring Boot 4.0.1 / Java 25)

| Rule | Nội dung |
|------|----------|
| **3.1** | **3-layer architecture**: Controller → Service (interface) → Repository. Controller không gọi Repository trực tiếp. Service không trả Entity ra ngoài (phải map sang DTO). |
| **3.2** | **Interface injection**: Service phải có interface (`UserService`) và implementation (`UserServiceImpl`). Controller inject interface, không inject impl class. |
| **3.3** | **Entity design**: KHÔNG dùng JPA relationship annotations (`@OneToMany`, `@ManyToOne`, `@ManyToMany`). Chỉ lưu UUID của foreign key. Related data load trong Service layer bằng explicit query. |
| **3.4** | **N+1 prevention**: Không gọi `findById()` trong loop. Dùng `findAllById()` hoặc `@Query` với `IN(...)` + batch map. |
| **3.5** | **Transaction**: `@Transactional` trên Service method (không phải Controller). Class-level `@Transactional(readOnly = true)`, method-level `@Transactional` cho write operations. |
| **3.6** | **Naming**: Package lowercase, Class PascalCase, method camelCase, constant SCREAMING_SNAKE_CASE. DTO: `Create*Request`, `Update*Request`, `*Response`, `*Query`. |
| **3.7** | **Google Java Style**: `final` cho tất cả method parameters và local variables không đổi. `this.` khi truy cập instance fields/methods. 2-space indent, không wildcard import. |
| **3.8** | **Migration**: Flyway convention `V{version}__{description}.sql`. File migration ĐÃ merge vào develop thì KHÔNG ĐƯỢC sửa — tạo migration mới để thay đổi. |
| **3.9** | **Lombok**: Dùng `@RequiredArgsConstructor` cho DI (không dùng `@Autowired`). `@Slf4j` cho logging. `@Builder` cho DTO. Không dùng `@Data` trên Entity (dùng `@Getter` + `@Setter`). |
| **3.10** | **API Response**: Tất cả endpoint trả về `ApiResponse<T>`. Success → `ApiResponse.success(data)`. Error → exception handler trả `ApiResponse.error(message)`. |
| **3.11** | **Spotless / Checkstyle**: Nếu project có config formatter (Spotless plugin, Checkstyle), code phải pass format check. CI sẽ fail nếu format sai. |

---

## 5. Nhóm 4 — Testing

| Rule | Nội dung |
|------|----------|
| **5.1** | Mỗi AC phải có ít nhất 1 test case. AC không có test → `[must]`. |
| **5.2** | Test method name mô tả hành vi: `should_returnUser_when_validId()`, `should_throw_when_userNotFound()`. |
| **5.3** | Test class đặt cùng package với class được test. `*Test.java` cho unit test, `*IntegrationTest.java` cho integration test. |

---

## 6. Nhóm 5 — PR Hygiene

| Rule | Nội dung |
|------|----------|
| **6.1** | Tiêu đề PR theo conventional commit: `feat(module): mô tả`, `fix(module): mô tả`, `docs(solution): {PREFIX}-{SEQ} ...`. |
| **6.2** | PR code không chứa file không liên quan (IDE config, `.DS_Store`, `*.iml`). |
| **6.3** | Không commit code bị comment out. Xóa code cũ thay vì comment. |
| **6.4** | PR description có link đến task Plane và solution doc. |

---

## 7. Format output AI Review

```markdown
> Bản review mới nhất — các bản trước đó hết hiệu lực.

**Đối chiếu solution doc:** `docs/solutions/{PREFIX}-{SEQ}-*.md`
- Doc đã merge vào develop: ✅ / ❌ [must] (rule 1.4)
- Code khớp doc: ✅ / ❌

**Đối chiếu AC:** {n}/{tổng} AC có code + test
<!-- Liệt kê từng AC và status -->

**Findings:**

| # | Mức | File:dòng | Rule | Mô tả | Hướng sửa |
|---|-----|-----------|------|-------|-----------|
| 1 | [must] | `src/.../File.java:42` | 2.4 | Query thiếu `is_deleted = false` | Thêm `AND is_deleted = false` vào WHERE |
| 2 | [nit] | `src/.../File.java:78` | 3.7 | Thiếu `final` cho parameter | Thêm `final` |

**Kết luận:**
- [ ] Sẵn sàng review người ← chỉ khi 0 [must]
- [x] Còn {n} [must] cần sửa
```

### Phân loại finding

| Mức | Ý nghĩa | Hành động |
|-----|---------|-----------|
| `[must]` | Lỗi phải sửa trước khi merge | Dev sửa → push → AI review lại |
| `[nit]` | Gợi ý cải thiện, không bắt buộc | Dev tự quyết, không block merge |
