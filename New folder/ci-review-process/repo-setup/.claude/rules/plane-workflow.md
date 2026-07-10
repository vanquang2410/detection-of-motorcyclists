# Plane Workflow (Auto-loaded)

## States

Backlog → Todo → In Progress → In Review → Done

- In Progress & In Review cùng group "started"
- Chọn state theo TÊN CHÍNH XÁC, không theo group

## Task nhận bằng

- Script: `./scripts/nhan-task.sh {SEQ}`
- Skill: `/nhan-task {SEQ}`

## Chuyển state

- In Progress: tự động khi nhận task
- In Review: dev chuyển khi bỏ [WIP]
- Done: Lead/Sub-lead chuyển khi merge

## Config files

- `.plane-project` — UUID project (commit được)
- `.plane-token` — API key cá nhân (KHÔNG commit)
