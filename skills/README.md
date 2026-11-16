# Skills

แต่ละ skill เป็นโฟลเดอร์ที่มี `SKILL.md` — ใช้ได้ทั้ง **Cursor** และ **Claude Code**

## Bundled (Credit: by 9arm)

จาก [thananon/9arm-skills](https://github.com/thananon/9arm-skills)

### `debug-mantra-by-9arm` — ตอนเจอบั๊ก

ห้ามเดาสุ่มแก้ ให้ไล่เป็นขั้น: ทำให้พังซ้ำได้ไหม → ตามเส้นทางที่พัง → หักล้างสมมติฐาน → เก็บหลักฐานทุกรอบ แล้วค่อยแก้  
เปิดใช้เมื่อมี error / stack trace / ของพัง หรือพูดว่า debug / หาสาเหตุ

### `post-mortem-by-9arm` — ตอนแก้เสร็จแล้ว

เขียนบันทึกให้ทีมวิศวกร: พังเพราะอะไร กลไกเป็นยังไง แก้ยังไง ตรวจยังไง ทำไมถึงหลุดมาได้  
ใช้หลัง validate แล้ว ก่อนปิด ticket — ยังไม่รู้สาเหตุหรือยังไม่ชัวร์ว่าแก้แล้ว อย่าเขียน

### `scrutinize-by-9arm` — ก่อนเชื่อแผน / ก่อน merge

ให้มองแบบคนนอก: จำเป็นต้องทำแบบนี้ไหม มีทางง่ายกว่าไหม แล้วไล่ code path จริงว่าทำได้ตามที่อ้างไหม  
ใช้ตอนรีวิว PR, diff, design, หรือขอ second opinion

### `management-talk-by-9arm` — ตอนต้องคุยขึ้นหัวหน้า / PM

เอาข้อความภาษาวิศวะมาเขียนใหม่ให้อ่านรู้เรื่อง ตามช่องทางจริง เช่น Slack, อีเมล, JIRA, standup, ประเด็นในมีตติ้ง  
ใช้เมื่อขอสรุปสถานะ / executive summary / “ทำให้อ่านง่ายขึ้น”

## Bundled (Credit: by Cloudflare)

จาก [cloudflare/security-audit-skill](https://github.com/cloudflare/security-audit-skill) (MIT)

### `security-audit-by-cloudflare` — ตอนตรวจความปลอดภัยของโค้ด

Skill เดียว แต่มีไฟล์ช่วยครบ (โดเมนต่าง ๆ + schema + ตัว validate)  
- **ถาม/รีวิวเฉพาะจุด** → ใช้แบบ guidance ไม่ต้องรันครบทุกเฟส  
- **ขอ audit / pen-test / รายงานเต็ม** → รัน workflow 6 เฟส (สำรวจ → ไล่ล่า → หักล้าง → บันทึก → ตรวจซ้ำ → รายงาน)  
full audit หนัก: อยากได้ sub-agent + Node + sandbox ถ้ารันโค้ดเป้าหมาย

## Bundled (Kio) — team roles

BA เป็นต้นทาง ID: `BO-n` → `BR-n` → `US-n` / `US-n-ACk` พร้อม `RULE-n` และ `NFR-n` — SA/Dev/QA ใช้ ID เดิม ห้ามออกชุดใหม่; `TC-n` เป็นของ QA ที่ชี้กลับ AC  
ตอบเป็น template และ**เซฟเองเสมอ**ที่ **workspace root**:

`note/YYYY-MM-DD/{ba.brief.md|sa.spec.md|dev.impl.md|qa.status.md|manifest.json}`  
(วันเดียวหลายงาน → `note/YYYY-MM-DD-{suffix}/`)

BA ต้องประกาศ `Note folder` ใน brief; SA/Dev/QA ใช้โฟลเดอร์นั้น — ถ้ามีหลายโฟลเดอร์วันเดียวกันให้ถาม ห้ามเดา; ประกาศ path ก่อนเขียนไฟล์  
ทุกไฟล์มี YAML frontmatter; แต่ละโฟลเดอร์มี `manifest.json` สำหรับสแกน/สรุป (schema อยู่ `templates/note/` — ติดตั้งไปที่โปรเจกต์ด้วย)  
ตรวจสุขภาพ: `scripts/validate-notes.ps1` / `validate-notes.sh`

### `use-ba` — ตอนคิดแบบ Business Analyst

เก็บปัญหาธุรกิจ เป้าหมาย requirement กฎธุรกิจ และความต้องการด้านคุณภาพ แล้วส่งต่อ SA–Dev–QA ด้วย ID ชุดเดียวกัน  
เปิดใช้เมื่อพูดถึง BA, requirement, user story, acceptance criteria, business rule หรือให้คิดแบบ BA

### `use-sa` — ตอนคิดแบบ System Analyst

แปลง AC เป็น System Spec ที่ Dev ทำต่อได้: ขอบเขต, data, API, NFR (มี target หรือ TBD), failure พร้อม recovery, แล้วส่งต่อ Dev–QA  
สิ่งที่ BA ไม่ได้เขียน ต้องติดป้าย Decision หรือ Assumption — ห้ามปนกับ Requirement  
งาน CRUD ใช้แกนสเปก; architecture, security, distributed, deploy อ่านจาก `templates/` และ `references/` เฉพาะเมื่อเข้าเงื่อนไข  
เปิดใช้เมื่อพูดถึง SA, system design, architecture, data flow, API หรือให้คิดแบบ SA

### `use-dev` — ตอนลงมือทำ

ทำให้เล็กที่สุดเท่าที่ครอบคลุม Must AC ที่ไม่ถูกบล็อก และสัญญาจาก SA แล้วบันทึกไฟล์ที่แตะ, ผลตรวจแยกประเภท, และจุดที่ต่างจากสเปก  
รายละเอียดวิศวกรรมอยู่ใน `references/` — อ่านเฉพาะเมื่อเงื่อนไขใน skill ตรง ไม่โหลดทุกไฟล์  
เปิดใช้เมื่อพูดถึง Dev, implement, เขียนโค้ด, ทำให้ หรือให้คิดแบบนักพัฒนา — ไม่เขียน user story, ไม่ได้ออกแบบระบบ, ไม่ตัดสิน ship

### `use-qa` — ตอนคิดแบบ QA

ไล่ AC→test, รายงาน bug พร้อม severity/priority แล้วให้คำแนะนำ Ship / No-ship  
เปิดใช้เมื่อพูดถึง QA, test plan, test case, regression, bug report หรือให้คิดแบบ QA

### `summarize-notes` — ตอนสรุป / สแกน note

อ่าน `manifest.json` + frontmatter ก่อน แล้วค่อยเปิด markdown — ห้ามเดาไฟล์ที่ขาด  
เปิดใช้เมื่อขอสรุป note, week scan, lookback, หรือสถานะข้ามหลายเรื่อง

## เพิ่ม skill เอง

```text
skills/
  my-skill/
    SKILL.md
```

หลังติดตั้ง:

- Cursor → `.cursor/skills/`
- Claude Code → `.claude/skills/`
