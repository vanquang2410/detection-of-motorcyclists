---
name: nhan-task
description: Nhận task từ Plane, tạo branch, sinh solution doc, chuyển state. Dùng khi dev nói "nhận task", "lấy task", "/nhan-task 38".
---

# Nhận task từ Plane

Tương đương `./scripts/nhan-task.sh` nhưng chạy trong Claude Code với khả năng đọc/viết file và gọi API.

## Config

- `PLANE_BASE_URL`: đọc từ env hoặc mặc định `https://plane.olhub.org`
- `WORKSPACE`: đọc từ env hoặc mặc định `olhub`
- `PREFIX`: đọc từ env hoặc mặc định `STRIDE`
- `PROJECT_ID`: đọc từ `.plane-project` ở repo root
- `PLANE_API_KEY`: đọc từ env `PLANE_API_KEY` hoặc file `.plane-token` ở repo root

## Các bước

1. **Parse input**: lấy số task từ argument (VD: `38` hoặc `{PREFIX}-38`).

2. **Fetch task từ Plane**: gọi API với cursor-based pagination:
   ```bash
   curl -sf -H "X-API-Key: $PLANE_API_KEY" \
     "$PLANE_BASE_URL/api/v1/workspaces/$WORKSPACE/projects/$PROJECT_ID/issues/?per_page=100"
   ```
   Lặp qua các trang cho đến khi tìm thấy `sequence_id == SEQ`.

3. **Kiểm tra readiness**:
   - Có AC trong description? Không → cảnh báo
   - Có assignee? Không → cảnh báo

4. **Tạo branch**:
   ```bash
   git switch develop && git pull --ff-only
   git switch -c feature/{PREFIX}-{SEQ}-{slug}
   ```
   Slug: 4 từ đầu tên task, bỏ dấu tiếng Việt, lowercase.

5. **Sinh solution doc**: tạo `docs/solutions/{PREFIX}-{SEQ}-{slug}.md` từ template lite (04). Nếu task chạm DB → nhắc dev đổi sang template full (03).

6. **Chuyển state**: tìm state có `name == "In Progress"` (KHÔNG dùng group `started`), PATCH issue.

7. **Tóm tắt**: hiển thị tên task, branch, đường dẫn doc, hướng dẫn bước tiếp theo.
