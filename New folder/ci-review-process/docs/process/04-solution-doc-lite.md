# 04 — Solution Doc Lite

> Dùng cho task **≤ 3 điểm**, **không chạm DB** và **không thay đổi API contract chung**.
> Task ≥ 5 điểm hoặc chạm DB → dùng [03-solution-doc.md](03-solution-doc.md).

## Template

```markdown
# {PREFIX}-{SEQ} — {Tên task}

**Task:** {PLANE_BASE_URL}/{WORKSPACE}/projects/{PROJECT_ID}/issues/{ISSUE_ID}
**Người viết:** {Tên dev}

## Acceptance Criteria (copy nguyên khối ✅ AC từ task Plane)

<!-- Bot AI trên GitHub KHÔNG đọc được Plane — dán AC vào đây để bot đối chiếu.
     Mục này trống/thiếu → AI báo [must]. -->

- [ ] AC1: ...
- [ ] AC2: ...

## Cách làm (5–10 dòng)

<!-- Dev tự viết — phần quan trọng nhất.
     Bí ở đây = chưa hiểu task → hỏi Sub-lead NGAY. -->

## Input / Output

- **Input:** Mô tả request/params đầu vào
- **Output:** Mô tả response/kết quả mong đợi
- **Luồng lỗi:** Các case lỗi và response tương ứng

## Đụng vào đâu

- File/module sửa: liệt kê
- File/module mới: liệt kê
- Chạm DB/API contract chung? không
  <!-- Nếu CÓ → dùng template full docs/process/03-solution-doc.md -->

## Test

- Unit test: liệt kê test case chính
- Test tay: các bước verify thủ công
```

## Quy trình duyệt (giống bản full)

1. Dev viết doc → commit + push → mở **PR CHỈ chứa doc**
   - Tiêu đề: `docs(solution): {PREFIX}-{SEQ} {mô tả ngắn}`
2. AI review tầng 1 → dev sửa `[must]`
3. Sub-lead review → **Approve + Merge (squash)**
   - ⚠️ **KHÔNG bấm delete branch**
4. Dev: `git pull --no-rebase origin develop`
5. **Doc merged → mới được code**

## Khi nào chuyển sang template full?

Chuyển sang [03-solution-doc.md](03-solution-doc.md) khi:

- Task thêm/sửa bảng DB (cần section Database Changes + Migration)
- Task thêm/sửa API endpoint dùng chung (cần section API Contract)
- Task ≥ 5 story point
- Giải pháp có ≥ 2 phương án cần so sánh
- Sub-lead yêu cầu
