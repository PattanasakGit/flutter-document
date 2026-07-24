# Task Management Capstone

แอป Flutter ที่ทำงานได้จริงซึ่งต่อยอดจาก AI-First Flutter Boilerplate สำหรับ
ใช้ประกอบ [Flutter Field Guide](../../index.html) ตัวอย่างนี้คงกฎเดิมของ
Boilerplate และเพิ่ม Task Management เป็น vertical slice ครบ Domain,
Application, Data, Presentation, Riverpod, GoRouter และ tests

> [!IMPORTANT]
> โปรเจกต์นี้เป็น runnable learning/reference app ไม่ใช่ผลิตภัณฑ์พร้อมปล่อยจริง
> Authentication และ Tasks ใช้ deterministic fake/in-memory datasource
> ข้อมูล task จะ reset เมื่อ process เริ่มใหม่

## สิ่งที่ทำได้

- ล็อกอินด้วย demo authentication และ route guard
- เปิด Task board จาก Home หรือ deep link `/tasks`
- ดู summary และกรอง All / Open / Completed
- Create, edit, toggle และ delete พร้อม validation/confirmation
- แสดง loading, empty, fatal load error และ recoverable mutation error
- รองรับ narrow/wide layout, keyboard, semantics และ Material 3 light/dark theme
- ทดสอบแบบ offline ตั้งแต่ pure Domain ถึง Router integration

## Requirements

- Flutter 3.44.8 stable (ดู `.fvmrc`)
- Dart 3.12.2 ที่มาพร้อม Flutter
- VS Code + Flutter/Dart extensions
- Android SDK, Xcode/CocoaPods หรือ browser ตาม target ที่ต้องการรัน

ตรวจ environment:

```bash
flutter --version
flutter doctor -v
flutter devices
```

## Setup จาก clean checkout

```bash
flutter pub get
dart run build_runner build
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

generated Riverpod/Freezed/JSON files ถูก commit แล้ว แต่ต้องรัน build runner
ใหม่เมื่อแก้ annotation และ review generated diff ห้ามแก้ไฟล์ `.g.dart` หรือ
`.freezed.dart` ด้วยมือ

## Run

Development:

```bash
flutter run -t lib/main_development.dart
```

เลือก device:

```bash
flutter devices
flutter run -d <device-id> -t lib/main_development.dart
```

Demo credentials:

```text
Email:    demo@example.com
Password: password123
```

หลังล็อกอินเลือก **Open task manager** ข้อมูล seed 3 รายการมาจาก
`lib/features/tasks/data/task_seed.dart`

## Build

Web release compilation:

```bash
flutter build web --release -t lib/main_development.dart
flutter build web --release -t lib/main_production.dart
python3 -m http.server 8080 --directory build/web
```

บรรทัดแรกตรวจ offline development composition และบรรทัดที่สองตรวจ
production entrypoint compilation gate โดย production entrypoint ยังไม่เท่ากับ
production readiness

Android:

```bash
flutter build apk --debug -t lib/main_development.dart
flutter build appbundle --release -t lib/main_production.dart
```

iOS (macOS + Xcode + signing ที่ถูกต้อง):

```bash
flutter build ios --release -t lib/main_production.dart
flutter build ipa --release -t lib/main_production.dart
```

Release build ผ่านพิสูจน์เพียง source compile/package ในเงื่อนไขนั้น
ไม่พิสูจน์ real auth, persistence, signing, privacy หรือ production operations

## Architecture

```text
Presentation ──→ Application ──→ Domain
      │                │             ↑
      └────────────────┴─────────────┤
Data ────────────────────────────────┘

External input → Datasource → Repository → Result<T>
                                   ↓
Widget ← TaskListState ← Controller/Use case
```

- `domain/` เป็น pure Dart: Task invariant, TaskFilter และ repository contract
- `application/` เป็น use cases ที่พูดภาษาของ feature
- `data/` เป็น local/remote datasource, checked DTO, mapping และ typed failure
  boundary โดย runnable default ยังเป็น in-memory
- `presentation/` เป็น Riverpod controller, union state, pages, forms และ widgets
- `tasks_providers.dart` ประกอบ dependency graph โดยไม่มี business logic
- `tasks.dart` เป็น public feature surface ที่ Router import

อ่าน [Capstone development map](docs/task-management-capstone.md) และ
`AGENTS.md` ก่อนแก้ feature

## Feature flow

```text
TaskListPage
  → TaskListController
    → CreateTask / UpdateTask / ToggleTask / DeleteTask / GetTasks
      → TaskRepository
        → TaskRepositoryImpl
          → TaskLocalDatasource
            → InMemoryTaskDatasource
```

Remote path ที่ทดสอบแยก:

```text
RemoteTaskRepository
  → DioTaskRemoteDatasource
    → ApiClient
      → Dio
```

Presentation ไม่ import datasource, raw record, Dio หรือ JSON และ Domain
ไม่ import Flutter/Riverpod/Data

## Tests

Focused feedback:

```bash
flutter test test/features/tasks/domain
flutter test test/features/tasks/data
flutter test test/features/tasks/application
flutter test test/features/tasks/presentation
flutter test test/app/router/task_route_test.dart
```

Full quality gate:

```bash
dart run build_runner build
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
git diff --check
```

Test portfolio ครอบคลุม:

- invariant, normalization, update identity และ filters
- unmodifiable datasource snapshots และ CRUD
- DTO-like record ↔ entity mapping และ failure mapping
- checked HTTP schema, request serialization และ remote repository mapping
- controller load/filter/mutation/duplicate-action/race behavior
- loading/error UI, form validation, rendering, filter, create/edit/toggle/delete
- signed-in task route และ signed-out redirect
- regression suite ของ Boilerplate เดิม

## เพิ่ม behavior อย่างปลอดภัย

1. อ่าน `AGENTS.md`, feature ใกล้เคียง และ test ที่เกี่ยวข้อง
2. เขียน failing behavior test และรันให้เห็น failure ที่ถูกเหตุผล
3. เพิ่ม implementation เล็กที่สุดให้ test ผ่าน
4. รักษา dependency direction และ public surface
5. รัน focused tests ระหว่างทำ แล้วรัน full quality gate
6. อัปเดตคู่มือ/decision/production gap เมื่อ contract เปลี่ยน

ตัวอย่าง prompt สำหรับ AI:

```text
เพิ่ม TaskPriority ใน features/tasks
อ่าน AGENTS.md และ tests ปัจจุบันก่อน
รักษา Domain → Application ← Data/Presentation และใช้ Result/Failure เดิม
เริ่มจาก failing domain/data/controller/widget tests
ห้ามเพิ่ม dependency หรือแก้ authentication
รายงาน output ของ build_runner, format, analyze และ full tests ตามที่รันจริง
```

## Environment

| Environment | Entrypoint | สภาพตัวอย่าง |
| --- | --- | --- |
| Development | `lib/main_development.dart` | Fake auth + in-memory tasks |
| Staging | `lib/main_staging.dart` | ยังใช้ fake/local; ไม่ใช่ staging transport จริง |
| Production | `lib/main_production.dart` | ยังใช้ fake/local; ชื่อ entrypoint ไม่ทำให้ production-ready |

API base URLs ใน starter ใช้ `.invalid` เพื่อไม่เรียกบริการจริงโดยไม่ตั้งใจ

## Production gaps

ต้องปิดอย่างน้อยรายการต่อไปนี้ก่อน release ผลิตภัณฑ์:

- แทน fake authentication ด้วย real backend/OIDC
- เพิ่ม session restore, expiry, refresh, revoke และ intended-route restoration
- แทน in-memory tasks ด้วย local database/remote repository ตาม requirement
- ออกแบบ sync, conflict, retry, idempotency, migration และ data retention
- ทำ native flavors/schemes, identifiers, signing, icons และ store metadata
- เพิ่ม localization, locale/RTL tests และ accessibility QA บนอุปกรณ์จริง
- เพิ่ม privacy-safe crash/error/performance observability และ alerts
- เพิ่ม device integration smoke tests, target builds และ staged rollout/rollback
- ทบทวน secrets, network security, privacy disclosure และ dependency risks

ห้าม fallback staging/production ไป fake datasource แล้วแสดงว่าเป็นระบบจริง

## Git author

Repository เอกสารนี้ใช้:

```text
PattanasakGit <pattanasak.at@gmail.com>
```

ตรวจ commit ล่าสุดด้วย:

```bash
git log -1 --format=fuller
```
