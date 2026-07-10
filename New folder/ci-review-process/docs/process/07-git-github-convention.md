# 07 — Git & GitHub Convention

## 1. Branch Naming

```
feature/{PREFIX}-{SEQ}-{slug}     # Feature/task mới
bugfix/{PREFIX}-{SEQ}-{slug}      # Bug fix
hotfix/{PREFIX}-{SEQ}-{slug}      # Hotfix production
docs/{PREFIX}-{SEQ}-{slug}        # Documentation only
```

- `{PREFIX}`: prefix task trên Plane (VD: `STRIDE`)
- `{SEQ}`: số thứ tự task (VD: `38`)
- `{slug}`: 3–4 từ đầu tiên của tên task, lowercase, bỏ dấu tiếng Việt

Ví dụ: `feature/STRIDE-38-implement-jwt-refresh`

> Branch tạo tự động bằng `nhan-task.sh` hoặc skill `nhan-task`.

## 2. Commit Message

### Format

```
<type>(<module>): <mô tả ngắn>

<body — optional, giải thích WHY>
```

### Types

| Type | Khi nào |
|------|---------|
| `feat` | Feature mới |
| `fix` | Bug fix |
| `refactor` | Refactor không đổi behavior |
| `docs` | Chỉ thay đổi documentation |
| `test` | Thêm/sửa test |
| `chore` | Config, build, dependency |
| `perf` | Cải thiện performance |
| `ci` | Thay đổi CI/CD |

### Ví dụ

```
feat(auth): implement JWT refresh token rotation

Refresh token hết hạn sau 7 ngày. Mỗi lần dùng refresh token,
token cũ bị vô hiệu hóa và sinh token mới — chống replay attack.
```

```
fix(document): add is_deleted check to findByWorkspaceId query

Query trước đó thiếu WHERE is_deleted = false, trả về cả
documents đã soft-delete.
```

```
docs(solution): STRIDE-38 implement JWT refresh token
```

## 3. Quy trình PR (2 PR per task)

### PR 1 — Solution Doc

```bash
# Sau khi viết solution doc
git add docs/solutions/{PREFIX}-{SEQ}-*.md
git commit -m "docs(solution): {PREFIX}-{SEQ} {mô tả ngắn}"
git push -u origin feature/{PREFIX}-{SEQ}-{slug}

# Mở PR trên GitHub
gh pr create \
  --title "docs(solution): {PREFIX}-{SEQ} {mô tả ngắn}" \
  --body "Task: {PLANE_BASE_URL}/{WORKSPACE}/projects/{PROJECT_ID}/issues/{ISSUE_ID}" \
  --base develop
```

- AI review tầng 1 chạy tự động → sửa theo `[must]`
- Sub-lead review → Approve + **Merge (squash, KHÔNG delete branch)**
- Dev: `git pull --no-rebase origin develop`

### PR 2 — Code

```bash
# Tiếp tục code trên CÙNG branch
git push

# Mở PR [WIP]
gh pr create \
  --title "[WIP] feat({module}): {PREFIX}-{SEQ} {mô tả}" \
  --body "$(cat <<'EOF'
## Task
{PLANE_BASE_URL}/{WORKSPACE}/projects/{PROJECT_ID}/issues/{ISSUE_ID}

## Solution Doc
docs/solutions/{PREFIX}-{SEQ}-{slug}.md

## Changes
- ...

## Test Plan
- [ ] Unit test pass
- [ ] Integration test pass
EOF
)" \
  --base develop
```

- AI review chạy → sửa `[must]` → push → AI chạy lại
- Khi sạch `[must]` → bỏ `[WIP]` khỏi tiêu đề → title-check CI xanh
- Chuyển task sang **In Review** trên Plane
- Người review → Approve + Merge

## 4. Branch Protection

### Kịch bản 1 — Repo có Branch Protection (plan trả phí)

```
develop:
  ✅ Require pull request before merging
  ✅ Require status checks: ci, title-check
  ✅ Require 1 approval
  ❌ Allow force push
  ❌ Allow deletion
```

### Kịch bản 2 — GitHub Free (repo private)

Không có branch protection UI → team tuân thủ bằng discipline:

- **KHÔNG push trực tiếp vào develop/main** — luôn qua PR
- CI vẫn chạy → dấu ❌ nhắc người merge nếu tiêu đề còn `[WIP]`
- Sub-lead/Lead tự kiểm tra trước khi merge

## 5. Workflow tổng hợp cho Dev

```bash
# 1. Nhận task
./scripts/nhan-task.sh 38
# Hoặc trong Claude Code: /nhan-task 38

# 2. Viết solution doc (file đã được tạo sẵn)
code docs/solutions/{PREFIX}-38-*.md

# 3. Commit + push doc
git add docs/solutions/
git commit -m "docs(solution): {PREFIX}-38 implement feature X"
git push -u origin feature/{PREFIX}-38-slug

# 4. Mở PR doc
gh pr create --title "docs(solution): {PREFIX}-38 implement feature X" --base develop

# 5. Chờ AI review + Sub-lead approve + merge
# 6. Đồng bộ branch
git pull --no-rebase origin develop

# 7. Code
# ... implement feature ...

# 8. Commit + push code
git add -A && git commit -m "feat(module): {PREFIX}-38 implement feature X"
git push

# 9. Mở PR code [WIP]
gh pr create --title "[WIP] feat(module): {PREFIX}-38 implement feature X" --base develop

# 10. Sửa theo AI review → push → lặp lại
# 11. Bỏ [WIP] khi sẵn sàng
gh pr edit <PR_NUMBER> --title "feat(module): {PREFIX}-38 implement feature X"

# 12. Chờ người review → merge
```

## 6. GitHub CLI Cheat Sheet

```bash
# Xem PR hiện tại
gh pr view

# List PR của mình
gh pr list --author @me

# Xem status checks
gh pr checks

# Xem diff
gh pr diff

# Merge PR (cho Lead/Sub-lead)
gh pr merge --squash

# Tạo issue
gh issue create --title "Bug: ..." --body "..."

# Xem issue
gh issue view 42

# Comment trên PR
gh pr comment --body "Fixed, please re-review"
```
