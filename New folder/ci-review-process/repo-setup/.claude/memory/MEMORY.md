---
name: project-memory
description: Index of project knowledge — lazy-load topic files as needed
type: index
auto_load: true
---

# Project Memory

## Quick Reference

- **Tech stack**: Spring Boot 4.0.1 / Java 25 / PostgreSQL / Redis / Flyway
- **Architecture**: 3-layer (Controller → Service interface → Repository)
- **Entity design**: No JPA relationships, UUID foreign keys only
- **Review process**: Solution doc → PR doc → merge → code → PR code [WIP]
- **AI review**: 2-tier (AI tầng 1 auto, người tầng 2)

## Topic Files

- `conventions.md` — Coding conventions and style rules
- `common-issues.md` — Recurring problems and solutions
- `architecture.md` — Architecture decisions and patterns
