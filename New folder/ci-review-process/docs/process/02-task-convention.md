# 02 — Task Convention

## 1. Template tạo task trên Plane

### Tiêu đề task

```
[Module] Mô tả ngắn gọn hành động
```

Ví dụ:
- `[Auth] Implement JWT refresh token rotation`
- `[Document] Add soft-delete for documents`
- `[Workspace] Fix member count N+1 query`

### Mô tả task (Description)

```markdown
## Mục tiêu
Mô tả ngắn gọn task cần đạt được gì.

## Acceptance Criteria
✅ AC1: Mô tả tiêu chí chấp nhận cụ thể, đo được
✅ AC2: ...
✅ AC3: ...

## Context / Background
- Link tài liệu liên quan (nếu có)
- Lý do tại sao cần task này

## Technical Notes
- Gợi ý hướng giải quyết (optional)
- Lưu ý kỹ thuật (optional)
```

## 2. Viết Acceptance Criteria (AC) đúng cách

### Nguyên tắc SMART

- **S**pecific — Cụ thể, không mơ hồ
- **M**easurable — Đo được (có/không, số liệu cụ thể)
- **A**chievable — Khả thi trong scope task
- **R**elevant — Liên quan đến mục tiêu task
- **T**estable — Viết được test case cho AC

### Ví dụ tốt vs xấu

```markdown
# ❌ XẤU — mơ hồ, không đo được
✅ API hoạt động tốt
✅ Code sạch
✅ Có test

# ✅ TỐT — cụ thể, đo được, testable
✅ POST /api/v1/documents trả về 201 với body chứa document ID
✅ Document lưu vào DB với status = DRAFT, owner_id = current user
✅ Trả 400 nếu title trống hoặc > 255 ký tự
✅ Trả 403 nếu user không có role EDITOR trở lên trong workspace
✅ Unit test cover 3 case: success, validation fail, permission denied
```

### Checklist AC cho từng loại task

**API endpoint:**
- [ ] Input validation (required fields, format, length)
- [ ] Response format (status code, body structure)
- [ ] Error cases (400, 401, 403, 404, 409)
- [ ] Permission check (role nào được gọi)

**Business logic:**
- [ ] Happy path
- [ ] Edge cases
- [ ] Error handling & recovery

**Database change:**
- [ ] Migration script (Flyway `V{version}__{description}.sql`)
- [ ] Rollback strategy
- [ ] Data integrity (FK, unique, not null)
- [ ] Impact lên query hiện có

## 3. Sử dụng fields trên Plane

| Field | Bắt buộc | Ai điền | Ý nghĩa |
|-------|----------|---------|---------|
| **Title** | ✅ | Lead | `[Module] Hành động` |
| **Description** | ✅ | Lead | Theo template trên |
| **State** | ✅ | Tự động/Lead | Backlog → Todo → ... |
| **Priority** | ✅ | Lead | Urgent / High / Medium / Low / None |
| **Assignee** | ✅ (khi vào sprint) | Lead/Sub-lead | Dev chịu trách nhiệm |
| **Label** | Nên có | Lead | Backend, Frontend, Feature, Bug, ... |
| **Estimate** | Nên có | Lead + Dev | Story point (1, 2, 3, 5, 8, 13) |
| **Cycle** | Nên có | Lead | Sprint hiện tại |
| **Module** | Optional | Lead | Nhóm feature lớn |

## 4. Definition of Ready (DoR)

Task **chưa sẵn sàng** để dev nhận nếu thiếu bất kỳ mục nào:

- [ ] Tiêu đề theo format `[Module] Hành động`
- [ ] Mô tả có ít nhất 2 AC cụ thể (prefix ✅)
- [ ] Có assignee
- [ ] Có estimate (story point)
- [ ] Có label phân loại (Backend/Frontend/Feature/Bug/...)
- [ ] Không có dependency chưa giải quyết
- [ ] Context đủ để dev bắt đầu viết solution doc

> **Dev**: Nếu nhận task thiếu mục trên → hỏi Sub-lead NGAY, đừng đoán.

## 5. Story Point Reference

| Point | Effort | Ví dụ |
|-------|--------|-------|
| **1** | < 2h, trivial | Fix typo, thêm field vào response |
| **2** | 2–4h, straightforward | CRUD endpoint đơn giản |
| **3** | 4–8h, some complexity | Endpoint với validation + permission |
| **5** | 1–2 ngày, significant | Feature mới với business logic |
| **8** | 2–3 ngày, complex | Feature chạm nhiều module |
| **13** | 3–5 ngày, very complex | Thiết kế hệ thống mới, cần tách task |

> Task **≥ 8 điểm** nên cân nhắc tách thành nhiều task nhỏ hơn.
