# Review Process (Auto-loaded)

## Solution Doc trước Code

- Viết solution doc → PR doc → AI review → Sub-lead approve → merge
- git pull --no-rebase origin develop
- CHỈ SAU KHI doc merge → mới code

## 2-tier Review

1. AI review (tầng 1): tự động trên PR, dev sửa [must]
2. Người review (tầng 2): Sub-lead/Lead, sau khi AI sạch

## [WIP] Convention

- Tiêu đề `[WIP] ...` → CI title-check đỏ → không merge
- Bỏ [WIP] khi sạch [must] và sẵn sàng review người

## Rule file

Source-of-truth: `docs/process/05-review-rules.md`
- Nhóm 1: Đối chiếu giải pháp (1.1-1.4)
- Nhóm 2: Correctness & Safety (2.1-2.8)
- Nhóm 3: Convention BE Spring Boot (3.1-3.11)
- Nhóm 4: Testing (5.1-5.4)
- Nhóm 5: PR Hygiene (6.1-6.4)
