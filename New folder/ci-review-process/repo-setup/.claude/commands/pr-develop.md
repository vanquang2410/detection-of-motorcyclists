---
name: pr-develop
description: Tạo PR vào develop — tự điền template, link task, link solution doc.
---

# Tạo PR vào develop

1. Xác định task từ tên branch: `feature/{PREFIX}-{SEQ}-...`
2. Tìm solution doc: `docs/solutions/{PREFIX}-{SEQ}-*.md`
3. Đọc diff: `git diff develop...HEAD --stat`
4. Tạo PR:

```bash
gh pr create \
  --title "{type}({module}): {PREFIX}-{SEQ} {mô tả}" \
  --base develop \
  --body "$(cat <<'EOF'
## Task
{PLANE_BASE_URL}/{WORKSPACE}/projects/{PROJECT_ID}/issues/{ISSUE_ID}

## Solution Doc
docs/solutions/{PREFIX}-{SEQ}-{slug}.md

## Changes
{danh sách thay đổi từ diff}

## Test Plan
- [ ] Unit test pass
- [ ] Integration test pass
- [ ] Test tay

## Checklist
- [ ] Solution doc đã merge vào develop
- [ ] Mỗi AC có code + test
- [ ] AI review không còn [must]
EOF
)"
```

Nếu PR là code (không phải doc), thêm `[WIP]` vào tiêu đề.
