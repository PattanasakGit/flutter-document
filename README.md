# Flutter Field Guide

คู่มือภาษาไทยสำหรับ React/Next.js developer ที่ต้องการเรียน Dart และ Flutter
ผ่าน AI-first Flutter boilerplate และโปรเจกต์ Task Management ที่ทำงานได้จริง

## เปิดคู่มือ

อ่านฉบับออนไลน์ได้ที่
[`https://pattanasakgit.github.io/flutter-document/`](https://pattanasakgit.github.io/flutter-document/)
โดย GitHub Pages จะ deploy ใหม่อัตโนมัติทุกครั้งที่ push ไปยัง branch `main`

เปิด `index.html` ด้วย browser ได้โดยตรง เว็บไซต์ไม่ใช้ CDN และไม่ต้องรัน
local server หรือใช้คำสั่งต่อไปนี้เมื่อ browser จำกัด `file://`:

```bash
python3 -m http.server 8080
```

จากนั้นเปิด `http://localhost:8080/` คู่มือมี 28 บท, ภาคอ้างอิง 4 ชุด,
search, progress, dark mode, quiz, exercises และแผนภาพ HTML/CSS ที่อ่านได้
แม้ปิด JavaScript

## ตรวจสอบเว็บไซต์

```bash
dart run tools/validate_site.dart
```

## ตัวอย่าง Flutter

completed project อยู่ที่ `example/task_management_app` เมื่อสร้างครบแล้วให้รัน:

```bash
cd example/task_management_app
flutter pub get
dart run build_runner build
flutter test
flutter run -t lib/main_development.dart
```

ล็อกอินด้วย `demo@example.com` / `password123` แล้วเลือก
**Open task manager** แอปตัวอย่างใช้ in-memory datasource จึงทำงานและทดสอบได้
โดยไม่พึ่ง network ข้อมูลจะ reset เมื่อ restart process

ตรวจ release compilation สำหรับ Web:

```bash
cd example/task_management_app
flutter build web --release -t lib/main_development.dart
flutter build web --release -t lib/main_production.dart
```

คำสั่งแรกตรวจ dev composition ที่ใช้สอน ส่วนคำสั่งที่สองเป็น production
entrypoint compilation gate; ทั้งสองคำสั่งไม่ได้ยืนยันว่า backend, real auth,
signing, privacy หรือ production operations พร้อมแล้ว

อ่าน [README ของ Capstone](example/task_management_app/README.md) สำหรับ
โครงสร้างไฟล์, test map, การเพิ่ม feature และ production gaps

## แก้ไขคู่มือ

source ของบทอยู่ใน `content/` และหน้าเต็มถูกสร้างจาก `templates/page.html`:

```bash
dart run tools/build_site.dart
dart run tools/validate_site.dart
```

อย่าแก้ `chapters/*.html` หรือ `reference/*.html` โดยตรง เพราะ build ครั้งถัดไป
จะสร้างทับจาก content source

## แหล่งอ้างอิง

เนื้อหาอ้างอิงโครงสร้างและกฎจาก
[`PattanasakGit/flutter-boilerplate`](https://github.com/PattanasakGit/flutter-boilerplate)
โดยคู่มือระบุข้อจำกัดของ fake authentication และ production readiness
ตามสภาพ implementation จริง
