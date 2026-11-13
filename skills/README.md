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

## เพิ่ม skill เอง

```text
skills/
  my-skill/
    SKILL.md
```

หลังติดตั้ง:

- Cursor → `.cursor/skills/`
- Claude Code → `.claude/skills/`
