# 01 — Quy trình tổng thể

## 1. Vòng đời một task

```
PLANE (quản lý task)                         REPO (code & review)
─────────────────────                        ────────────────────
Backlog
  │
  ▼
Todo ── Sprint Planning ──►
  │
  ▼            nhan-task.sh / skill
In Progress ─────────────────────►  feature/{PREFIX}-{SEQ}-slug
  │                                     │
  │         ┌───────────────────────────┘
  │         │  1. Viết solution doc
  │         │  2. PR doc → AI review → sửa → Approve & Merge
  │         │  3. git pull --no-rebase origin develop
  │         │  4. Code trên CÙNG branch
  │         │  5. PR code [WIP] → AI review → sửa → bỏ [WIP]
  │         │  6. Người review → Approve & Merge
  │         ▼
In Review ◄─────────────────────  PR ready (bỏ [WIP])
  │                                     │
  ▼                                     ▼
Done ◄──────────────────────────  Merged vào develop
```

## 2. Trạng thái task trên Plane

| State | Group | Ý nghĩa | Ai chuyển |
|-------|-------|---------|-----------|
| **Backlog** | backlog | Ý tưởng, chưa refine | Lead |
| **Todo** | unstarted | Đã refine, sẵn sàng làm | Lead (Sprint Planning) |
| **In Progress** | started | Dev đang làm | Dev (qua script/skill) |
| **In Review** | started | PR sẵn sàng review | Dev (bỏ [WIP]) |
| **Done** | completed | Merged vào develop | Lead/Sub-lead |
| **Cancelled** | cancelled | Hủy bỏ | Lead |

> **Lưu ý**: State **In Review** cùng group `started` với **In Progress**.
> Script `nhan-task.sh` chọn state theo **tên chính xác** `"In Progress"`,
> không phải state đầu tiên của group `started` — tránh nhầm sang "In Review".

## 3. Ma trận RACI

| Hoạt động | Lead | Sub-lead | Dev |
|-----------|------|----------|-----|
| Tạo & refine task | **R/A** | C | I |
| Assign task vào sprint | **R/A** | C | I |
| Viết solution doc | I | **A** (review) | **R** |
| Review solution doc | I | **R/A** | I |
| Code | I | C | **R** |
| AI review (tầng 1) | I | I | **R** (sửa) |
| Người review (tầng 2) | A | **R** | I |
| Merge PR | **R/A** | R | I |
| Chuyển Done | **R** | R | I |

> **R** = Responsible (thực hiện), **A** = Accountable (chịu trách nhiệm),
> **C** = Consulted, **I** = Informed.

## 4. Review 2 tầng

### Tầng 1 — AI Review (tự động)

- Chạy trên **MỌI PR** (kể cả `[WIP]`), workflow `ai-review.yml`.
- PR doc: AI đối chiếu doc với template.
- PR code: AI đối chiếu code với solution doc + bộ rule `05-review-rules.md`.
- Dev sửa theo finding `[must]` → push → AI chạy lại.
- Mục tiêu: dev sửa sạch `[must]` **trước** khi nhờ người.

### Tầng 2 — Người review

- Sub-lead (hoặc Lead) review **sau khi** AI review sạch.
- Kiểm tra: logic nghiệp vụ, thiết kế, edge case AI không bắt được.
- Approve → merge vào `develop`.

### Dev không có Claude Code local

Dùng `@claude` trên PR/issue:
```
@claude review lại theo docs/process/05-review-rules.md
@claude check DoD theo docs/process/06-definition-of-done.md
```

## 5. Escalation

| Tình huống | Dev làm gì | Thời hạn |
|-----------|------------|----------|
| Không hiểu task/AC | Hỏi Sub-lead trên Plane comment | Ngay lập tức |
| Bí solution doc | Hỏi Sub-lead, attach draft doc | Trong ngày |
| Bug CI đỏ không rõ nguyên nhân | Tag Sub-lead trên PR | Trong ngày |
| PR review > 2 ngày không phản hồi | Nhắc Sub-lead, CC Lead | Sau 2 ngày |
| Conflict giữa 2 task | Báo Lead | Ngay khi phát hiện |

## 6. Nhịp làm việc

| Hoạt động | Tần suất | Ai tham gia |
|-----------|----------|-------------|
| Daily async update | Hằng ngày | Dev → Sub-lead |
| Sprint Planning | Đầu sprint (1–2 tuần) | Lead + Sub-lead + Dev |
| Sprint Review | Cuối sprint | Lead + Sub-lead + Dev |
| Retrospective | 2 tuần/lần | Cả team |

### Daily async update

Dev gửi 3 dòng trên channel team (Slack/Discord/Zalo):
1. Hôm qua làm gì (link PR nếu có)
2. Hôm nay làm gì
3. Blocker (nếu có)
