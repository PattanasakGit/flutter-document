# Flutter Field Guide

คู่มือภาษาไทยสำหรับ React/Next.js developer ที่ต้องการเรียน Dart และ Flutter
ผ่าน AI-first Flutter boilerplate และโปรเจกต์ Task Management ที่ทำงานได้จริง

## เปิดคู่มือ

เปิด `index.html` ด้วย browser ได้โดยตรง เว็บไซต์ไม่ใช้ CDN และไม่ต้องรัน
local server

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

## แหล่งอ้างอิง

เนื้อหาอ้างอิงโครงสร้างและกฎจาก
[`PattanasakGit/flutter-boilerplate`](https://github.com/PattanasakGit/flutter-boilerplate)
โดยคู่มือระบุข้อจำกัดของ fake authentication และ production readiness
ตามสภาพ implementation จริง
