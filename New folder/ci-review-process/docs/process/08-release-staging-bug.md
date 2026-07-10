# 08 — Release, Staging & Bug Reporting

## 1. Release Flow

```
develop ──────────────────► main
    │                         │
    │  PR: release/v1.2.0     │
    │  ─────────────────────► │
    │                         │
    │  ✅ CI pass              │
    │  ✅ Lead approve         │
    │  ✅ Merge (merge commit) │
    │                         │
    │                    tag: v1.2.0
    │                         │
    │  ◄───── back-merge ──── │
    │                         │
```

### Quy trình

1. **Lead** tạo branch `release/vX.Y.Z` từ `develop`
2. **Lead** mở PR: `release/vX.Y.Z` → `main`
   - Title: `release: vX.Y.Z`
   - Body: changelog (list commit từ release trước)
3. CI chạy → phải pass
4. Lead review + **merge** (dùng merge commit, KHÔNG squash)
5. Tag `vX.Y.Z` trên `main`
6. **Back-merge** `main` → `develop` (giữ đồng bộ)

### Changelog tự động

```bash
# Sinh changelog từ commit messages
git log v1.1.0..HEAD --oneline --no-merges | grep -E "^[a-f0-9]+ (feat|fix|perf)"
```

## 2. Hotfix Flow

```
main ──► hotfix/{PREFIX}-{SEQ}-{slug} ──► main
                                            │
                              back-merge ──► develop
```

### Quy trình

1. Tạo branch `hotfix/{PREFIX}-{SEQ}-{slug}` từ `main` (KHÔNG từ develop)
2. Fix bug, commit, push
3. Mở PR → `main`
4. CI pass + Lead approve → merge
5. Tag version mới (VD: `v1.2.1`)
6. **Back-merge** `main` → `develop` ngay lập tức

> **Hotfix KHÔNG cần solution doc** nếu fix < 3pt và không chạm DB.
> Vẫn cần AI review + người review.

## 3. Bug Reporting

### Template báo bug trên Plane

```markdown
## Mô tả bug
Tóm tắt ngắn gọn bug gì đang xảy ra.

## Steps to Reproduce
1. Bước 1: ...
2. Bước 2: ...
3. Bước 3: ...

## Expected Behavior
Mô tả kết quả mong đợi.

## Actual Behavior
Mô tả kết quả thực tế (kèm error message, screenshot nếu có).

## Environment
- Branch/version: develop / v1.2.0
- OS: macOS 14 / Ubuntu 22.04
- Java version: 25
- Browser (nếu FE): Chrome 126

## Logs / Screenshots
<!-- Paste relevant logs hoặc attach screenshot -->

## Severity
- [ ] Critical — system down, data loss
- [ ] High — feature chính không dùng được
- [ ] Medium — feature phụ lỗi, có workaround
- [ ] Low — cosmetic, typo, minor UX
```

### Bug Classification

| Severity | Response Time | Fix Time | Quy trình |
|----------|--------------|----------|-----------|
| **Critical** | Ngay lập tức | < 4h | Hotfix → main |
| **High** | Trong ngày | < 1 ngày | Hotfix hoặc fix trên develop |
| **Medium** | Trong sprint | Sprint hiện tại | Fix trên develop, có solution doc lite |
| **Low** | Backlog | Khi có thời gian | Fix trên develop |

### Label bug trên Plane

- `Bug` — label bắt buộc
- `Critical` / `High` / `Medium` / `Low` — severity
- `Backend` / `Frontend` — area

## 4. Staging Environment (nếu có)

### Deploy to Staging

```bash
# Staging deploy từ develop (auto hoặc manual)
# Config trong CI/CD pipeline
```

### Staging Testing Checklist

- [ ] Smoke test: API health check pass
- [ ] Feature test: tính năng mới hoạt động đúng
- [ ] Regression test: tính năng cũ không bị ảnh hưởng
- [ ] Performance: response time chấp nhận được
- [ ] Database: migration chạy clean

## 5. Versioning

### Semantic Versioning

```
MAJOR.MINOR.PATCH
  │     │     │
  │     │     └── Bug fix, không đổi API
  │     └──────── Feature mới, backward-compatible
  └────────────── Breaking change
```

Ví dụ:
- `v1.0.0` → `v1.0.1`: bug fix
- `v1.0.1` → `v1.1.0`: feature mới
- `v1.1.0` → `v2.0.0`: breaking API change
