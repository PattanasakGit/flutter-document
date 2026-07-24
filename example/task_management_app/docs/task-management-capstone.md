# Task Management Capstone Development Map

เอกสารนี้ชี้ code path ของ feature ที่คู่มือบท 16–22 อ้างถึง

## File map

| Responsibility | Path |
| --- | --- |
| Entity + invariant | `lib/features/tasks/domain/entities/task.dart` |
| Filter vocabulary | `lib/features/tasks/domain/entities/task_filter.dart` |
| Repository contract | `lib/features/tasks/domain/repositories/task_repository.dart` |
| Use cases | `lib/features/tasks/application/task_use_cases.dart` |
| Record + datasource contract | `lib/features/tasks/data/datasources/task_local_datasource.dart` |
| Offline implementation | `lib/features/tasks/data/datasources/in_memory_task_datasource.dart` |
| Repository implementation | `lib/features/tasks/data/repositories/task_repository_impl.dart` |
| Checked response/request DTOs | `lib/features/tasks/data/dtos/` |
| Dio transport implementation | `lib/features/tasks/data/datasources/task_remote_datasource.dart` |
| Remote repository | `lib/features/tasks/data/repositories/remote_task_repository.dart` |
| Deterministic demo seed | `lib/features/tasks/data/task_seed.dart` |
| Provider composition | `lib/features/tasks/tasks_providers.dart` |
| Union state | `lib/features/tasks/presentation/states/task_list_state.dart` |
| Riverpod controller | `lib/features/tasks/presentation/controllers/task_list_controller.dart` |
| Page | `lib/features/tasks/presentation/pages/task_list_page.dart` |
| Form | `lib/features/tasks/presentation/widgets/task_form_sheet.dart` |
| Task row | `lib/features/tasks/presentation/widgets/task_card.dart` |
| Public feature surface | `lib/features/tasks/tasks.dart` |
| Router integration | `lib/app/router/app_router.dart` |
| Home entry | `lib/features/home/presentation/pages/home_page.dart` |

## Test map

| Risk | Test |
| --- | --- |
| Domain invariant/filter | `test/features/tasks/domain/task_test.dart` |
| Datasource mutation/snapshot | `test/features/tasks/data/in_memory_task_datasource_test.dart` |
| Mapping/failure policy | `test/features/tasks/data/task_repository_impl_test.dart` |
| HTTP verb/schema contract | `test/features/tasks/data/task_remote_datasource_test.dart` |
| Remote DTO/domain mapping | `test/features/tasks/data/remote_task_repository_test.dart` |
| Riverpod state transitions | `test/features/tasks/application/task_list_controller_test.dart` |
| User-visible behavior | `test/features/tasks/presentation/task_list_page_test.dart` |
| Route + authentication guard | `test/app/router/task_route_test.dart` |

## State policy

- Initial load ใช้ `loading → ready | failed`
- Filter เป็น derived state และไม่โหลด repository ซ้ำ
- Mutation ทำได้ครั้งเดียวบน ready state
- Filter/reload ถูก disable ระหว่าง mutation เพื่อไม่คืน stale snapshot
- Overlapping load ใช้ generation token และยอมรับผลล่าสุดเท่านั้น
- Mutation failure รักษา tasks เดิมและแสดง `actionError`
- Fatal load failure ใช้ full-page error พร้อม retry
- UI ไม่ทำ optimistic update จนกว่าจะมี latency requirement และ rollback policy

## Replace the offline adapter

ตัวอย่างมี remote path ที่ compile และทดสอบแล้ว แต่ไม่ได้เปิดเป็น default เพื่อให้
onboarding ทำงาน offline เมื่อเชื่อม backend จริง:

1. คง `TaskRepository` และ Domain types
2. ยืนยัน API contract ด้วย `task_remote_datasource_test.dart`
3. map transport/schema errors เป็น `AppException` ที่ boundary
4. map `AppException` เป็น `Failure` ใน `RemoteTaskRepository`
5. override `taskRepositoryProvider` ด้วย `remoteTaskRepositoryProvider`
6. staging/production ต้อง fail closed ถ้า URL/auth/backend ไม่พร้อม
7. รัน controller/widget/router suite เดิมเพื่อพิสูจน์ว่า UI contract ไม่เปลี่ยน
