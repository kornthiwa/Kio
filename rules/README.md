# Rules

แหล่งเดียว: ไฟล์ **`.mdc` แบบ Cursor**  
ตอนติดตั้ง Claude จะถูกแปลงเป็น `.md` ใต้ `.claude/rules/`

## Bundled

| Rule | Scope |
|------|--------|
| `project-defaults.mdc` | `alwaysApply: true` — ขอบเขตงาน, ความปลอดภัย git/secrets, อ่านก่อนเดา |
| `kio-source-of-truth.mdc` | `alwaysApply: true` — แก้ที่ `Kio/` ไม่ใช่แค่สำเนา `.cursor`/`.claude` |
| `note-lookback.mdc` | `alwaysApply: true` — path `note/`, frontmatter, `manifest.json`, schema, ห้ามเดาโฟลเดอร์ |

## Cursor (ต้นฉบับ)

```markdown
---
description: มาตรฐานสั้น ๆ ของโปรเจกต์
alwaysApply: true
---

# Project defaults

- เขียนโค้ดกระชับ
```

เฉพาะไฟล์:

```markdown
---
description: TypeScript conventions
globs: "**/*.ts"
alwaysApply: false
---

# TypeScript
```

## หลังติดตั้ง

| App | ผลลัพธ์ |
|-----|---------|
| Cursor | `.cursor/rules/*.mdc` ตามต้นฉบับ |
| Claude | `.claude/rules/*.md` — `globs` → `paths` (ถ้าไม่ใช่ `alwaysApply: true`) |
