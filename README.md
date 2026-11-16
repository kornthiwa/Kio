# Kio

Toolkit สำหรับขึ้นโปรเจกต์ใหม่บน **Cursor** และ **Claude Code**  
รองรับ **Windows** และ **macOS** — เก็บ skills, rules, templates และสคริปต์ติดตั้งไว้ใช้ซ้ำ

## โครง

```text
Kio/
  skills/            # Agent Skills (โฟลเดอร์ละ SKILL.md)
  rules/             # แหล่งเดียว: Cursor .mdc (แปลงเป็น Claude .md ตอนติดตั้ง)
  templates/         # AGENTS.md + CLAUDE.md + note/ (schemas)
  scripts/
    install.ps1      # Windows (PowerShell)
    install.sh       # macOS / Linux (bash)
    validate-notes.ps1
    validate-notes.sh

# ในโปรเจกต์ที่ติดตั้งแล้ว (workspace root — ไม่ใช่ในโฟลเดอร์ Kio เอง)
note/YYYY-MM-DD/
  ba.brief.md      # + YAML frontmatter
  sa.spec.md
  dev.impl.md
  qa.status.md
  manifest.json    # machine index for future summary/search
```

`use-ba` / `use-sa` / `use-dev` / `use-qa` เซฟ note เองเสมอที่ workspace root; หลายงานวันเดียวใช้ `note/YYYY-MM-DD-{suffix}/`  
สัญญา note: `templates/note/` (ติดตั้งไปที่โปรเจกต์ด้วย) — ตรวจด้วย `scripts/validate-notes.*`

## ปลายทางตอนติดตั้ง

| App | Skills | Rules | Template |
|-----|--------|-------|----------|
| Cursor | `.cursor/skills/` | `.cursor/rules/*.mdc` | `AGENTS.md` |
| Claude Code | `.claude/skills/` | `.claude/rules/*.md` | `CLAUDE.md` |
| ทั้งคู่ | | | `templates/note/` (schema + README) |

ค่าเริ่มต้นติดตั้ง **ทั้งสอง** (`both`)  
`AGENTS.md` / `CLAUDE.md` ที่มีอยู่แล้วจะไม่ถูกทับ เว้นใส่ `-ForceTemplates` / `force`  
`templates/note/` จะถูกอัปเดตทุกครั้งที่ติดตั้ง

## ติดตั้ง

### Windows

```powershell
& path\to\Kio\scripts\install.ps1
& path\to\Kio\scripts\install.ps1 -Target "C:\path\to\project"
& path\to\Kio\scripts\install.ps1 -Target "C:\path\to\project" -App cursor
& path\to\Kio\scripts\install.ps1 -Target "C:\path\to\project" -App claude
& path\to\Kio\scripts\install.ps1 -Target "C:\path\to\project" -ForceTemplates
```

### macOS / Linux

```bash
chmod +x path/to/Kio/scripts/install.sh
path/to/Kio/scripts/install.sh
path/to/Kio/scripts/install.sh /path/to/project
path/to/Kio/scripts/install.sh /path/to/project cursor
path/to/Kio/scripts/install.sh /path/to/project claude
path/to/Kio/scripts/install.sh /path/to/project both force
```

> บน Mac/Linux การแปลง rule เป็น Claude ใช้ `python3`

## Skills ที่มีอยู่

Credit: by 9arm — จาก [thananon/9arm-skills](https://github.com/thananon/9arm-skills)

- `debug-mantra-by-9arm` · `post-mortem-by-9arm` · `scrutinize-by-9arm` · `management-talk-by-9arm`

Credit: by Cloudflare — จาก [cloudflare/security-audit-skill](https://github.com/cloudflare/security-audit-skill)

- `security-audit-by-cloudflare`

Kio

- `use-ba` · `use-sa` · `use-dev` · `use-qa` · `summarize-notes`

รายละเอียดใน [`skills/README.md`](./skills/README.md)

## เพิ่มของใหม่

| ประเภท | วางที่ | รูปแบบ |
|--------|--------|--------|
| Skill | `skills/<ชื่อ>/SKILL.md` | YAML + คำสั่ง (ใช้ร่วม Cursor/Claude ได้) |
| Rule | `rules/<ชื่อ>.mdc` | Cursor frontmatter; สคริปต์แปลง `globs` → `paths` ให้ Claude |
| Template | `templates/AGENTS.md` หรือ `templates/CLAUDE.md` | แก้ `[...]` ให้ตรงโปรเจกต์หลังติดตั้ง |

จากนั้นรัน install อีกครั้งในโปรเจกต์เป้าหมาย
