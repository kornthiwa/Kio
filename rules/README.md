# Rules

แหล่งเดียวของกฎ agent คือไฟล์ **`.mdc` แบบ Cursor** ในโฟลเดอร์นี้  
สคริปต์ติดตั้งจะ copy ไป `.cursor/rules/` และแปลงเป็น `.md` ใต้ `.claude/rules/` สำหรับ Claude Code

Rules = คำสั่งถาวรที่ agent ต้องทำตามทุกครั้ง (หรือเมื่อไฟล์ที่ match)  
ต่างจาก skills ที่เรียกเมื่องานเข้าเงื่อนไข และต่างจาก `AGENTS.md` / `CLAUDE.md` ที่เป็นคำแนะนำระดับโปรเจกต์ (แก้ placeholder ได้)

## Bundled

| Rule | เมื่อไหร่ | คุมอะไร |
|------|-----------|---------|
| `project-defaults.mdc` | `alwaysApply` | ขอบเขตงาน, code hygiene, git/secrets, DB/prod safety, อ่านก่อนเดา |
| `kio-source-of-truth.mdc` | `alwaysApply` | แก้ที่ `Kio/` เป็นหลัก — สำเนา `.cursor` / `.claude` ไม่ใช่แหล่งความจริง |
| `note-lookback.mdc` | `alwaysApply` | path `note/`, frontmatter, `manifest.json`, schema, ห้ามเดาโฟลเดอร์วันเดียวกัน |

### `project-defaults.mdc`

Baseline สำหรับทุก repo ที่ติดตั้ง Kio:

- อย่าขยาย scope / drive-by refactor; ตาม pattern ใน repo
- อย่าเพิ่ม dependency โดยไม่จำเป็น; เปลี่ยน public API/schema ต้องบอกผลกระทบ
- ห้าม hardcode/log secrets·PII; ห้าม empty catch
- ห้าม commit/push/deploy/infra/DB ทำลายข้อมูล หรือใช้ credential ชี้ prod โดยไม่ถูกขอชัด
- อ่านไฟล์จริงก่อนสรุป; ข้อมูลไม่พอ → ถามหนึ่งข้อ

อย่าทำให้ไฟล์นี้เป็น style guide ราย stack — รายละเอียด TypeScript/React/ฯลฯ ใส่ rule แบบ `globs` ในโปรเจกต์นั้น หรือใน `AGENTS.md`

### `kio-source-of-truth.mdc`

ใช้เมื่อ workspace มีโฟลเดอร์ `Kio/`:

- แก้ skills/rules/templates/scripts ที่ `Kio/`
- หลังแก้แล้ว รัน install ใหม่เมื่อต้องการรีเฟรชสำเนาใน target
- เทมเพลตต้นฉบับอยู่ `Kio/templates/`; `AGENTS.md` / `CLAUDE.md` ที่ root เป็นของ workspace

### `note-lookback.mdc`

ใช้กับ BA/SA/QA lookback:

- เซฟที่ **workspace root** `note/YYYY-MM-DD/` (หลายหัวข้อวันเดียว → `note/YYYY-MM-DD-{suffix}/`)
- ประกาศ Note folder ก่อนเขียน; มีหลายโฟลเดอร์วันนี้ → ถาม อย่าเดา
- ทุกไฟล์ role ต้องมี YAML frontmatter; โฟลเดอร์ต้องมี `manifest.json` (merge — ห้าม wipe `recommendation`)

## เขียน rule ใหม่

ใส่ไฟล์ `.mdc` ในโฟลเดอร์นี้ แล้วรัน install

**ทุกไฟล์ต้องมี frontmatter:**

| ฟิลด์ | ความหมาย |
|------|----------|
| `description` | สรุปสั้น ๆ (ช่วยให้ tool/UI รู้ว่า rule นี้เกี่ยวกับอะไร) |
| `alwaysApply` | `true` = โหลดทุกครั้ง; `false` = โหลดเมื่อไฟล์ตรง `globs` |
| `globs` | รูปแบบไฟล์ เช่น `"**/*.ts"` (ใช้เมื่อไม่ใช่ alwaysApply) |

ทั้ง workspace (always):

```markdown
---
description: มาตรฐานสั้น ๆ ของโปรเจกต์
alwaysApply: true
---

# Project defaults

- เขียนโค้ดกระชับ
```

เฉพาะไฟล์ที่ match:

```markdown
---
description: TypeScript conventions
globs: "**/*.ts"
alwaysApply: false
---

# TypeScript
```

คำแนะนำสั้น ๆ:

- เขียนเป็นข้อ ๆ ที่ทำตามได้ — อย่ายืดเป็นคู่มือยาว
- `alwaysApply` เก็บเฉพาะสิ่งที่ใช้ได้ทุก repo / ทุกงาน
- ราย stack หรือราย path → ใช้ `globs`
- อย่า commit secrets ในตัวอย่าง rule

## หลังติดตั้ง

| App | ผลลัพธ์ |
|-----|---------|
| Cursor | `.cursor/rules/*.mdc` ตามต้นฉบับ |
| Claude | `.claude/rules/*.md` — frontmatter แปลง `globs` → `paths` (เมื่อไม่ใช่ `alwaysApply: true`); บน Mac/Linux ต้องมี `python3` |

`README.md` ในโฟลเดอร์นี้ **ไม่** ถูก copy เป็น rule

## แก้แล้วทำอะไรต่อ

1. แก้ที่ `Kio/rules/*.mdc` (ไม่ใช่แค่สำเนาใน `.cursor` / `.claude`)
2. รัน `scripts/install.*` เข้าโปรเจกต์เป้าหมายเมื่อต้องการให้สำเนาตาม
3. อัปเดตตาราง Bundled ใน README นี้ถ้าเพิ่ม/ลบ/เปลี่ยนบทบาท rule
