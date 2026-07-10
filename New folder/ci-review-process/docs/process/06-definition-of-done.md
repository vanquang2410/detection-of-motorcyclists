# 06 — Definition of Done (DoD)

## Phần A — Checklist trước khi bỏ `[WIP]` (Dev tự kiểm)

Dev hoàn thành **TẤT CẢ** mục dưới đây trước khi bỏ `[WIP]` khỏi tiêu đề PR:

### Solution Doc
- [ ] Solution doc đã được Approve + merge vào `develop`
- [ ] Code khớp với giải pháp trong solution doc

### Acceptance Criteria
- [ ] Mỗi AC trong solution doc đã có code implement
- [ ] Mỗi AC có ít nhất 1 test case

### Code Quality
- [ ] Code theo 3-layer: Controller → Service (interface) → Repository
- [ ] Service inject qua interface, không inject impl
- [ ] Entity không dùng JPA relationship annotations
- [ ] Không có N+1 query (đã dùng batch query)
- [ ] `@Transactional` trên Service (không phải Controller)
- [ ] Input validation với `@Valid` + Bean Validation
- [ ] Error handling với custom exception
- [ ] Google Java Style: `final` params, `this.` instance access

### Testing
- [ ] Unit test pass
- [ ] Integration test pass (nếu có)
- [ ] Test cover tất cả AC

### CI
- [ ] CI xanh (build + test pass)
- [ ] Lint/format check pass (Spotless/Checkstyle nếu có)

### AI Review
- [ ] AI review tầng 1 không còn `[must]`
- [ ] Đã sửa hoặc giải thích tất cả `[must]` findings

### PR Hygiene
- [ ] Tiêu đề PR đúng format: `feat(module): mô tả`
- [ ] PR description có link task Plane + link solution doc
- [ ] Không commit file không liên quan (IDE config, .DS_Store)
- [ ] Không commit code bị comment out

---

## Phần B — Điều kiện để chuyển Done (Lead/Sub-lead)

Task chỉ được chuyển **Done** trên Plane khi:

- [ ] PR đã được người review **Approve**
- [ ] PR đã **merge vào develop**
- [ ] CI xanh trên develop sau merge
- [ ] Không có regression (feature cũ vẫn hoạt động)

---

## Workflow tổng hợp

```
Dev hoàn thành code
    │
    ▼
Chạy checklist Phần A
    │
    ├── Còn thiếu mục → sửa → lặp lại
    │
    ▼
Bỏ [WIP] khỏi tiêu đề PR
    │
    ▼
Chuyển task sang In Review trên Plane
    │
    ▼
Người review (Sub-lead/Lead)
    │
    ├── Request changes → dev sửa → lặp lại
    │
    ▼
Approve + Merge
    │
    ▼
Kiểm tra Phần B → chuyển Done
```

## Dùng skill `check-done` để tự kiểm

```bash
# Trong Claude Code tại repo:
/check-done
# Hoặc trên PR: @claude check DoD theo docs/process/06-definition-of-done.md
```
