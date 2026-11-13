# CLAUDE.md

คำแนะนำโปรเจกต์สำหรับ Claude Code  
แก้ส่วนใน `[...]` ให้ตรงโปรเจกต์ แล้วลบวงเล็บเหลี่ยมออก

## Overview

`[ชื่อโปรเจกต์]` — `[หนึ่งประโยคว่าทำอะไร]`

Stack: `[เช่น Next.js + Postgres]`

## Commands

```bash
[install command]
[dev command]
[test command]
[lint command]
```

## Layout

- `[path]` — `[บทบาท]`
- `[path]` — `[บทบาท]`

## Working rules

- แก้เฉพาะที่เกี่ยวกับงาน อย่าแตะไฟล์นอกขอบเขตโดยไม่จำเป็น
- อย่า commit / push / แก้ git config จนกว่าจะถูกขอ
- อ่านโค้ดใน repo ก่อนสรุปหรือเสนอแพตช์
- ถ้าข้อมูลไม่พอสำหรับตัดสินใจ ให้ถามหนึ่งคำถามที่สั้นที่สุด

## Do not

- commit secrets (`.env`, tokens, private keys)
- ขยาย scope เกินที่ถูกขอ
- ติดตั้งแพ็กเกจใหม่โดยไม่จำเป็น

## Project notes

- `[ข้อตกลงทีม / edge cases ที่สำคัญ]`
