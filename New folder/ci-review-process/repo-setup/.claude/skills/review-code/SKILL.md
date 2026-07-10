---
name: review-code
description: AI review code local theo bộ rule của team, đối chiếu với solution doc — chạy TRƯỚC khi tạo PR. Dùng khi dev nói "review code", "check trước khi tạo PR", "/review-code".
---

# AI Review local (tầng 1)

Review diff hiện tại theo đúng quy trình team. Đây là bản chạy local của AI review trên PR — mục tiêu: dev sửa sạch `[must]` trước khi người khác phải nhìn vào.

## Các bước

1. **Đọc rule**: `docs/process/05-review-rules.md` — mọi finding phải trỏ về một rule trong file này hoặc là lỗi correctness rõ ràng.
2. **Xác định phạm vi diff**:
   ```bash
   git diff develop...HEAD --stat   # tổng quan
   git diff develop...HEAD          # nội dung
   ```
3. **Đọc solution doc**: tìm `docs/solutions/{PREFIX}-*.md` theo mã task trong tên branch. Doc phải **đã tồn tại trên `develop`** (PR doc được Approve + merge — kiểm bằng `git show origin/develop:<path>`); doc chỉ mới có trong diff hoặc không có → finding `[must]` đầu tiên luôn (rule 1.4), vẫn review tiếp phần còn lại.
4. **Đọc AC của task** (nếu có `PLANE_API_KEY`): kéo mô tả task từ Plane theo mã trong tên branch, liệt kê từng AC và tìm code + test tương ứng.
5. **Review theo từng nhóm rule** (1→5 trong rule file). Với mỗi finding: file:dòng, mã rule, mô tả, hướng sửa. Chỉ báo thứ có căn cứ — không suy diễn code ngoài diff trừ khi cần kiểm chứng (được phép đọc file liên quan để xác nhận, VD kiểm tra query soft-delete).
6. **Output** đúng format mục 7 của rule file (Kết quả AI Review — đối chiếu doc, đối chiếu AC n/tổng, danh sách [must]/[nit], kết luận sẵn sàng hay chưa).

Không tự sửa code trừ khi người dùng yêu cầu sau khi xem kết quả.
