# CI Review Process

Bộ tài liệu quy trình CI & Code Review chuẩn cho team phát triển **Spring Boot (Java 25 / Spring Boot 4.0.1)**.

## Tổng quan

```
ci-review-process/
├── docs/process/                    # 9 file tài liệu quy trình (00-08)
│   ├── 00-README.md                 # Hướng dẫn setup & mục lục
│   ├── 01-quy-trinh-tong-the.md     # Vòng đời task, Plane states, RACI
│   ├── 02-task-convention.md        # Chuẩn viết task, AC, Definition of Ready
│   ├── 03-solution-doc.md           # Template solution doc đầy đủ
│   ├── 04-solution-doc-lite.md      # Template solution doc lite
│   ├── 05-review-rules.md           # Bộ rule review code (BE Spring Boot)
│   ├── 06-definition-of-done.md     # DoD — checklist A (dev) + B (Lead)
│   ├── 07-git-github-convention.md  # Branch, commit, PR, branch protection
│   └── 08-release-staging-bug.md    # Release flow, hotfix, bug reporting
│
└── repo-setup/                      # Copy vào repo dự án
    ├── .claude/
    │   ├── settings.json            # Hook config (SessionStart, Pre/PostToolUse)
    │   ├── hooks/                   # 3 hook scripts (memory, PR inventory, lesson)
    │   ├── memory/MEMORY.md         # Project memory index
    │   ├── rules/                   # 3 auto-loaded rule files
    │   ├── commands/pr-develop.md   # PR creation command
    │   └── skills/                  # 4 AI skills
    │       ├── review-code/         # Local AI review (tầng 1)
    │       ├── check-done/          # DoD verification
    │       ├── nhan-task/           # Task acceptance from Plane
    │       └── plan-solution/       # Solution doc planning
    ├── .github/
    │   ├── workflows/
    │   │   ├── ci.yml               # Build + test + title-check
    │   │   ├── ai-review.yml        # AI review trên PR
    │   │   └── claude-mention.yml   # @claude mention handler
    │   ├── CODEOWNERS               # Code ownership (plan trả phí)
    │   └── PULL_REQUEST_TEMPLATE.md # PR template
    └── scripts/
        └── nhan-task.sh             # Task acceptance script (bash 3.2+)
```

## Quick Start

1. Đọc [docs/process/00-README.md](docs/process/00-README.md) để setup
2. Copy `repo-setup/` vào repo dự án
3. Thay placeholder (`{PROJECT}`, `{PREFIX}`, `{WORKSPACE}`, `{PLANE_BASE_URL}`)
4. Commit & push

## 13 fixes đã áp dụng

| # | Vấn đề | Fix |
|---|--------|-----|
| 1 | Script chọn state theo group "started" → nhầm "In Review" | Chọn theo `name=="In Progress"` |
| 2 | Script dùng `${var,,}` + `iconv //TRANSLIT` → crash macOS | `tr` + `strip_vn()` thuần bash |
| 3 | Script chỉ đọc 100 issue đầu | Cursor-based pagination loop |
| 4 | Doc không tách kịch bản branch protection GitHub Free vs trả phí | 2 kịch bản rõ ràng |
| 5 | Nhầm "không push trực tiếp" thành "không tạo branch local" | Sửa lại đúng ý |
| 6 | DoD lẫn lộn checklist dev vs Lead | Tách Phần A (dev) + Phần B (Lead) |
| 7 | Quy trình tổng thể thiếu RACI | Thêm ma trận RACI đầy đủ |
| 8 | DoD thiếu mục lint check | Thêm Spotless/Checkstyle check |
| 9 | Script thiếu `.plane-project` file | Check + error message rõ ràng |
| 10 | Script dùng token chung thay vì cá nhân | `.plane-token` cá nhân, gitignore |
| 11 | AI review workflow thiếu concurrency group | `cancel-in-progress: true` |
| 12 | Claude-mention workflow thiếu guard bot loop | `user.type != 'Bot'` check |
| 13 | CI thiếu title-check job cho [WIP] | Job `title-check` riêng biệt |

## Tech Stack mục tiêu

- Java 25 + Spring Boot 4.0.1
- PostgreSQL + Redis
- Flyway migrations
- Maven build system

## Skills (Claude Code)

| Skill | Mô tả | Trigger |
|-------|--------|---------|
| `/review-code` | AI review local trước khi tạo PR | "review code" |
| `/check-done` | Kiểm tra DoD trước khi bỏ [WIP] | "check done" |
| `/nhan-task 38` | Nhận task từ Plane | "nhận task" |
| `/plan-solution 38` | Lập kế hoạch giải pháp | "plan task", "viết solution" |
