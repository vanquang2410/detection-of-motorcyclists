---
name: check-done
description: Kiểm tra Definition of Done trước khi bỏ [WIP] hoặc request review. Dùng khi dev nói "check done", "kiểm tra DoD", "/check-done".
---

# Kiểm tra Definition of Done

Đối chiếu trạng thái hiện tại của branch với checklist DoD (docs/process/06-definition-of-done.md).

## Các bước

1. **Đọc DoD**: `docs/process/06-definition-of-done.md` — lấy checklist Phần A (dev tự kiểm).
2. **Xác định task**: parse tên branch lấy mã task (`feature/{PREFIX}-{SEQ}-...`).
3. **Kiểm tra từng mục**:

   ### Solution Doc
   - Tìm `docs/solutions/{PREFIX}-{SEQ}-*.md`
   - Kiểm tra đã merge vào develop: `git show origin/develop:<path>`
   - Đọc AC trong doc

   ### Code & Test
   - Chạy `git diff develop...HEAD --stat` để xem phạm vi
   - Đối chiếu AC với code + test trong diff
   - Kiểm tra có unit test, integration test

   ### CI & AI Review
   - Kiểm tra CI status (nếu có PR): `gh pr checks` hoặc nhắc dev chạy `mvn verify`
   - Kiểm tra AI review findings (nếu có PR)

   ### PR Hygiene
   - Tiêu đề PR đúng format
   - Không có file IDE config, .DS_Store trong diff
   - Không có code bị comment out

4. **Output**: checklist với ✅/❌ cho từng mục, tổng kết sẵn sàng bỏ [WIP] hay chưa.

```markdown
## Checklist DoD — {PREFIX}-{SEQ}

### Solution Doc
- ✅/❌ Doc tồn tại: `docs/solutions/{PREFIX}-{SEQ}-*.md`
- ✅/❌ Doc đã merge vào develop

### Acceptance Criteria
- ✅/❌ AC1: ... → code ở `file.java:line` + test ở `test.java:line`
- ✅/❌ AC2: ...

### Code Quality
- ✅/❌ 3-layer architecture
- ✅/❌ Interface injection
- ✅/❌ No N+1 queries
- ...

### CI & Review
- ✅/❌ Build pass
- ✅/❌ AI review: 0 [must]

### PR Hygiene
- ✅/❌ Tiêu đề đúng format
- ✅/❌ Không file thừa

**Kết luận:** Sẵn sàng bỏ [WIP] / Còn {n} mục cần sửa
```
