#!/usr/bin/env bash
# Nhận task từ Plane — dùng được cho MỌI dev, không cần Claude Code.
# Cách dùng:  ./scripts/nhan-task.sh 38        (số task {PREFIX}-38)
# Yêu cầu:    - file .plane-token ở repo root: API key CÁ NHÂN của bạn
#               (tự tạo ở Plane → Settings → API tokens; đã gitignore — KHÔNG commit)
#             - file .plane-project ở repo root: UUID project (Lead tạo, commit được)
#             - jq  (Linux: sudo apt install jq · macOS: brew install jq)
# Tương thích bash 3.2 (macOS) — không dùng cú pháp bash 4+.
set -euo pipefail

PLANE_BASE_URL="${PLANE_BASE_URL:-https://plane.olhub.org}"
WORKSPACE="${WORKSPACE:-olhub}"
PREFIX="${PREFIX:-STRIDE}"
REPO_ROOT="$(git rev-parse --show-toplevel)"

[ -f "$REPO_ROOT/.plane-project" ] \
  || { echo "❌ Thiếu file .plane-project (chứa UUID project Plane) ở repo root — nhờ Lead tạo, xem docs/process/00-README.md"; exit 1; }
PROJECT_ID="$(tr -d '[:space:]' < "$REPO_ROOT/.plane-project")"

SEQ="${1:?Cách dùng: ./scripts/nhan-task.sh <số task, VD 38>}"
SEQ="${SEQ#${PREFIX}-}"
case "$SEQ" in
  ''|*[!0-9]*) echo "❌ '$1' không phải mã task hợp lệ — dùng số hoặc ${PREFIX}-<số>, VD: ./scripts/nhan-task.sh 38"; exit 1 ;;
esac

# Token: ưu tiên biến môi trường, không có thì đọc .plane-token (KHÔNG commit file này)
if [ -z "${PLANE_API_KEY:-}" ] && [ -f "$REPO_ROOT/.plane-token" ]; then
  PLANE_API_KEY="$(tr -d '[:space:]' < "$REPO_ROOT/.plane-token")"
fi
[ -n "${PLANE_API_KEY:-}" ] || { echo "❌ Thiếu token Plane — tạo API key cá nhân (Plane → Settings → API tokens) rồi lưu vào .plane-token ở repo root"; exit 1; }

api() { curl -sf -H "X-API-Key: $PLANE_API_KEY" "$PLANE_BASE_URL/api/v1/workspaces/$WORKSPACE/projects/$PROJECT_ID/$1"; }

# Hỏi y/N — tương thích bash 3.2 (không dùng ${var,,})
confirm() {
  read -rp "$1 (y/N) " _ok
  [ "$(printf '%s' "$_ok" | tr '[:upper:]' '[:lower:]')" = "y" ]
}

# Bỏ dấu tiếng Việt — thuần bash, chạy cả Linux lẫn macOS
# (BSD iconv không hỗ trợ //TRANSLIT nên không dùng iconv)
strip_vn() {
  local s=$1 c
  for c in à á ạ ả ã â ầ ấ ậ ẩ ẫ ă ằ ắ ặ ẳ ẵ À Á Ạ Ả Ã Â Ầ Ấ Ậ Ẩ Ẫ Ă Ằ Ắ Ặ Ẳ Ẵ; do s=${s//$c/a}; done
  for c in è é ẹ ẻ ẽ ê ề ế ệ ể ễ È É Ẹ Ẻ Ẽ Ê Ề Ế Ệ Ể Ễ; do s=${s//$c/e}; done
  for c in ì í ị ỉ ĩ Ì Í Ị Ỉ Ĩ; do s=${s//$c/i}; done
  for c in ò ó ọ ỏ õ ô ồ ố ộ ổ ỗ ơ ờ ớ ợ ở ỡ Ò Ó Ọ Ỏ Õ Ô Ồ Ố Ộ Ổ Ỗ Ơ Ờ Ớ Ợ Ở Ỡ; do s=${s//$c/o}; done
  for c in ù ú ụ ủ ũ ư ừ ứ ự ử ữ Ù Ú Ụ Ủ Ũ Ư Ừ Ứ Ự Ử Ữ; do s=${s//$c/u}; done
  for c in ỳ ý ỵ ỷ ỹ Ỳ Ý Ỵ Ỷ Ỹ; do s=${s//$c/y}; done
  s=${s//đ/d}; s=${s//Đ/d}
  printf '%s' "$s"
}

echo "🔎 Đang tìm task ${PREFIX}-$SEQ trên Plane..."
# Phân trang theo cursor — không dừng ở 100 issue đầu
ISSUE=""
CURSOR=""
while :; do
  PAGE=$(api "issues/?per_page=100${CURSOR:+&cursor=$CURSOR}")
  ISSUE=$(jq --argjson s "$SEQ" '[.results[] | select(.sequence_id == $s)][0] // empty' <<<"$PAGE")
  [ -n "$ISSUE" ] && break
  [ "$(jq -r '.next_page_results' <<<"$PAGE")" = "true" ] || break
  CURSOR=$(jq -r '.next_cursor' <<<"$PAGE")
done
[ -n "$ISSUE" ] || { echo "❌ Không tìm thấy ${PREFIX}-$SEQ"; exit 1; }

NAME=$(jq -r '.name' <<<"$ISSUE")
ISSUE_ID=$(jq -r '.id' <<<"$ISSUE")
DESC=$(jq -r '.description_html // ""' <<<"$ISSUE" | sed -e 's/<[^>]*>/ /g' -e 's/  */ /g')

echo "📋 $NAME"
echo

# Cảnh báo nếu thiếu Acceptance Criteria
if ! grep -qi "acceptance\|✅" <<<"$DESC"; then
  echo "⚠️  Task CHƯA có Acceptance Criteria trong mô tả — hỏi Sub-lead trước khi làm!"
  confirm "Vẫn tiếp tục?" || exit 1
fi

# Cảnh báo nếu task chưa được gán cho ai (Lead/Sub-lead gán từ lúc planning)
if [ "$(jq -r '(.assignees // []) | length' <<<"$ISSUE")" = "0" ]; then
  echo "⚠️  Task chưa có assignee trên Plane — xác nhận với Lead/Sub-lead đây đúng là task của bạn."
  confirm "Vẫn tiếp tục?" || exit 1
fi

# Tạo branch: feature/{PREFIX}-38-<slug 4 từ đầu, bỏ dấu>
SLUG=$(strip_vn "$(sed -e 's/^\[[^]]*\]//' <<<"$NAME")" \
  | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' \
  | sed -e 's/^-*//' -e 's/-*$//' | cut -d- -f1-4)
[ -n "$SLUG" ] || SLUG="task"
BRANCH="feature/${PREFIX}-$SEQ-$SLUG"
git switch develop && git pull --ff-only && git switch -c "$BRANCH"
echo "🌿 Branch: $BRANCH"

# Sinh solution doc lite (task lớn/chạm DB → dev tự đổi sang template full ở docs/process/03)
DOC="docs/solutions/${PREFIX}-$SEQ-$SLUG.md"
mkdir -p docs/solutions
if [ ! -f "$DOC" ]; then
cat > "$DOC" <<EOF
# ${PREFIX}-$SEQ — $NAME

**Task:** $PLANE_BASE_URL/$WORKSPACE/projects/$PROJECT_ID/issues/$ISSUE_ID
**Người viết:** $(git config user.name)

## Acceptance Criteria (copy nguyên khối ✅ AC từ task Plane)
<!-- Bot AI trên GitHub KHÔNG đọc được Plane — dán AC vào đây để bot đối chiếu. Bỏ trống = [must]. -->
- [ ] ...

## Cách làm (5–10 dòng)
<!-- Dev tự viết — phần quan trọng nhất. Bí ở đây = chưa hiểu task → hỏi Sub-lead NGAY. -->

## Input / Output
- **Input:**
- **Output:**
- **Luồng lỗi:**

## Đụng vào đâu
- File/module sửa:
- File/module mới:
- Chạm DB/API contract chung? không <!-- nếu CÓ → dùng template full docs/process/03 -->

## Test
- Unit test:
- Test tay:
EOF
echo "📝 Solution doc: $DOC"
fi

# Chuyển task sang In Progress trên Plane.
# Chọn state theo TÊN chính xác — không lấy state đầu tiên của group "started",
# vì team thêm state "In Review" vào cùng group đó (xem docs/process/01 §2).
STATE_ID=$(api "states/?per_page=100" | jq -r '[.results[] | select(.name=="In Progress")][0].id // empty')
if [ -n "$STATE_ID" ]; then
  curl -sf -X PATCH -H "X-API-Key: $PLANE_API_KEY" -H "Content-Type: application/json" \
    -d "{\"state\": \"$STATE_ID\"}" \
    "$PLANE_BASE_URL/api/v1/workspaces/$WORKSPACE/projects/$PROJECT_ID/issues/$ISSUE_ID/" >/dev/null \
    && echo "🔵 Đã chuyển task sang In Progress trên Plane" \
    || echo "⚠️  Không cập nhật được Plane — vào web chuyển In Progress giúp nhé"
else
  echo "⚠️  Không tìm thấy state tên đúng 'In Progress' trên Plane — vào web chuyển tay giúp nhé"
fi

echo
echo "✅ Xong. Tiếp theo:"
echo "   1. Viết solution doc ($DOC) → commit + push → mở PR CHỈ chứa doc"
echo "      (tiêu đề: docs(solution): ${PREFIX}-$SEQ ...) — bot AI review doc, sửa theo bot"
echo "   2. Nhờ Sub-lead duyệt: Approve + MERGE (squash, KHÔNG bấm delete branch)"
echo "   3. git pull --no-rebase origin develop   ← bắt buộc, đồng bộ branch sau squash"
echo "   4. Code trên CÙNG branch → mở PR code [WIP]. Doc chưa merge → chưa code"
