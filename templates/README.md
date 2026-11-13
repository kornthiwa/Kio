# Templates

เทมเพลตวางที่ **root โปรเจกต์เป้าหมาย**

| ไฟล์ | ใช้กับ |
|------|--------|
| `AGENTS.md` | Cursor และ agent ที่อ่าน AGENTS.md |
| `CLAUDE.md` | Claude Code |

ตอนรัน `install.ps1` / `install.sh`:

- `-App cursor` → คัดลอก `AGENTS.md`
- `-App claude` → คัดลอก `CLAUDE.md`
- `-App both` → ทั้งคู่

ถ้าไฟล์นั้นมีอยู่แล้ว จะ **ข้าม** ไม่ทับ (ใส่ `-ForceTemplates` / `force` เพื่อทับ)
