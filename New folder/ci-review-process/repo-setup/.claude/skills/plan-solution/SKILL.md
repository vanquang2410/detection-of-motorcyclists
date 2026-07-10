---
name: plan-solution
description: Lập kế hoạch giải pháp cho task — sinh solution doc đầy đủ với approach, sequence diagram, DB changes, input/output. Dùng khi dev nói "lập kế hoạch", "viết solution", "plan task", "/plan-solution 38".
---

# Lập kế hoạch giải pháp (Solution Planning)

Hỗ trợ dev viết solution doc chất lượng bằng cách phân tích task, codebase hiện tại, và sinh nội dung cho từng section.

## Khi nào dùng

- Dev vừa nhận task (sau `/nhan-task`) và cần viết solution doc
- Dev bí phần "Cách làm" hoặc sequence diagram
- Task phức tạp cần so sánh phương án

## Các bước

1. **Xác định task**: parse mã task từ tên branch hoặc argument.

2. **Đọc thông tin task**:
   - Đọc AC từ Plane (nếu có `PLANE_API_KEY`)
   - Đọc solution doc đã tạo sẵn (nếu có): `docs/solutions/{PREFIX}-{SEQ}-*.md`

3. **Phân tích codebase**:
   - Tìm entities, services, controllers liên quan
   - Xác định file cần sửa / tạo mới
   - Kiểm tra có chạm DB không (cần migration?)
   - Kiểm tra có ảnh hưởng API contract không

4. **Chọn template phù hợp**:
   - Không chạm DB + ≤ 3pt → template lite (`docs/process/04-solution-doc-lite.md`)
   - Chạm DB hoặc ≥ 5pt → template full (`docs/process/03-solution-doc.md`)

5. **Sinh nội dung cho từng section**:

   ### Acceptance Criteria
   - Copy AC từ Plane task description
   - Nếu AC chưa có → liệt kê gợi ý dựa trên task description

   ### Giải pháp (Approach)
   - Mô tả giải pháp chọn (5–15 dòng)
   - Nếu có ≥ 2 cách → tạo bảng so sánh phương án

   ### Sequence Diagram
   - Sinh Mermaid sequence diagram cho happy path
   - Sinh diagram cho ít nhất 1 luồng lỗi chính
   - Participants: Client → Controller → Service → Repository → DB
   - Thêm Redis nếu task liên quan cache

   ### Database Changes
   - Sinh Flyway migration SQL (`V{version}__{description}.sql`)
   - Liệt kê impact lên data/queries hiện có
   - Đánh giá backward-compatibility

   ### Input / Output
   - Request body/params với validation rules
   - Response body cho success + error cases
   - Bảng validation rules

   ### Đụng vào đâu
   - Liệt kê file sửa + file mới dựa trên phân tích codebase
   - Flag chạm DB/API contract chung

   ### Test Plan
   - Sinh test cases dựa trên AC
   - Unit test: service layer
   - Integration test: API endpoint
   - Test tay: bước thực hiện thủ công

6. **Viết vào solution doc**: cập nhật file `docs/solutions/{PREFIX}-{SEQ}-*.md` với nội dung sinh được.

7. **Tóm tắt**: hiển thị overview doc đã viết, nhắc dev:
   - Review + chỉnh sửa nội dung
   - Commit + push → mở PR doc
   - Chờ AI review + Sub-lead approve

## Lưu ý

- Không thay dev viết 100% — dev PHẢI review và chỉnh sửa
- Ưu tiên đúng hơn đẹp — nội dung chính xác quan trọng hơn format
- Nếu không chắc → ghi rõ "CẦN XÁC NHẬN" để dev hỏi Sub-lead
- Luôn tuân thủ convention trong CLAUDE.md:
  - Interface injection (`UserService` + `UserServiceImpl`)
  - No JPA relationships (UUID only)
  - Google Java Style (`final` params, `this.` access)
  - Flyway migration naming
