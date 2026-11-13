# Rules

แหล่งเดียว: ไฟล์ **`.mdc` แบบ Cursor**  
ตอนติดตั้ง Claude จะถูกแปลงเป็น `.md` ใต้ `.claude/rules/`

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
