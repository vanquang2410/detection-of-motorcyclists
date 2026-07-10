# Quy trình CI & Code Review — Hướng dẫn tổng quan

> Bộ tài liệu này là **source-of-truth** cho quy trình phát triển phần mềm
> của team, áp dụng cho dự án **Spring Boot (Java 25 / Spring Boot 4.0.1)**.

## Danh sách tài liệu

| # | File | Nội dung |
|---|------|----------|
| 00 | `00-README.md` *(file này)* | Hướng dẫn setup & mục lục |
| 01 | `01-quy-trinh-tong-the.md` | Vòng đời task, Plane states, RACI |
| 02 | `02-task-convention.md` | Chuẩn viết task, AC, Definition of Ready |
| 03 | `03-solution-doc.md` | Template solution doc đầy đủ (≥ 5pt, chạm DB/API) |
| 04 | `04-solution-doc-lite.md` | Template solution doc lite (≤ 3pt) |
| 05 | `05-review-rules.md` | Bộ rule review code (BE Spring Boot) |
| 06 | `06-definition-of-done.md` | DoD — checklist A (dev) + B (Lead) |
| 07 | `07-git-github-convention.md` | Branch, commit, PR, branch protection |
| 08 | `08-release-staging-bug.md` | Release flow, hotfix, bug reporting |

## Setup cho dự án mới

### 1. Copy `repo-setup/` vào repo

```bash
# Từ thư mục ci-review-process
cp -r repo-setup/.claude/   <your-repo>/
cp -r repo-setup/.github/   <your-repo>/
cp -r repo-setup/scripts/   <your-repo>/
```

### 2. Copy docs quy trình

```bash
cp -r docs/process/ <your-repo>/docs/process/
```

### 3. Tạo file `.plane-project`

```bash
# UUID lấy từ URL project trên Plane:
# https://{PLANE_BASE_URL}/{WORKSPACE}/projects/<UUID>/...
echo "YOUR-PROJECT-UUID" > <your-repo>/.plane-project
```

> **Commit được** — file này không chứa secret, chỉ là UUID project.

### 4. Tạo file `.plane-token` (CÁ NHÂN, KHÔNG commit)

```bash
# Mỗi dev tự tạo API key: Plane → Settings → API tokens
echo "YOUR-PERSONAL-API-KEY" > <your-repo>/.plane-token
```

> **KHÔNG commit** — file này phải có trong `.gitignore`.

### 5. Cập nhật `.gitignore`

```gitignore
# Plane personal token
.plane-token
```

### 6. Cài đặt GitHub App (nếu dùng AI review trên PR)

```bash
# Trong Claude Code tại repo, chạy:
/install-github-app
# Hoặc thủ công: claude setup-token → lưu CLAUDE_CODE_OAUTH_TOKEN vào repo secrets
```

### 7. Thay placeholder

Tìm và thay các placeholder trong tài liệu & scripts:

| Placeholder | Ý nghĩa | Ví dụ |
|-------------|----------|-------|
| `{PROJECT}` | Tên project viết hoa | `STRIDE` |
| `{PREFIX}` | Prefix task trên Plane | `STRIDE` |
| `{WORKSPACE}` | Workspace slug trên Plane | `olhub` |
| `{PLANE_BASE_URL}` | URL gốc Plane | `https://plane.olhub.org` |

## Yêu cầu phần mềm

| Tool | Mục đích | Cài đặt |
|------|----------|---------|
| `jq` | Parse JSON trong script | `sudo apt install jq` / `brew install jq` |
| `gh` | GitHub CLI | [cli.github.com](https://cli.github.com/) |
| `git` ≥ 2.23 | `git switch` support | Mặc định trên Ubuntu 22+ |
| Java 25 | Build & test | `sdk install java 25-tem` (SDKMAN) |
| Maven | Build system | Có sẵn qua `./mvnw` |

## Giới hạn GitHub Free (repo private)

- **Không có** Draft PR → dùng prefix `[WIP]` trong tiêu đề thay thế.
- **Không có** CODEOWNERS enforce → Sub-lead tự review theo RACI.
- **Không có** Required status checks UI → CI vẫn chạy, dấu ❌ nhắc người merge.
- **Không có** Branch protection rules → team tự discipline theo quy trình.
