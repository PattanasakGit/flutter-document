import 'dart:convert';
import 'dart:io';

final class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.track,
    required this.description,
    required this.keywords,
    required this.minutes,
    required this.level,
    required this.practice,
    required this.quizQuestion,
    required this.quizOptions,
    this.reference = false,
  });

  final String id;
  final String title;
  final String track;
  final String description;
  final String keywords;
  final int minutes;
  final String level;
  final String practice;
  final String quizQuestion;
  final List<String> quizOptions;
  final bool reference;

  String get outputDirectory => reference ? 'reference' : 'chapters';
  String get outputPath => '$outputDirectory/$id.html';
  String get contentPath => 'content/$id.html';
}

const lessons = <Lesson>[
  Lesson(id: '01-orientation', title: 'เริ่มใช้คู่มือและตั้งเป้าหมายระบบ', track: 'A · Orientation & Setup', description: 'วางเส้นทางจาก Web developer ไปสู่ Flutter developer และรู้ว่าควรอ่านหรือทดลองอย่างไร', keywords: 'roadmap mental model hot reload capstone', minutes: 18, level: 'เริ่มต้น', practice: 'เขียนเป้าหมาย feature มือถือหนึ่งอย่าง แล้วระบุ Widget, state, data และ test ที่คาดว่าจะต้องมี', quizQuestion: 'สิ่งใดคือผลลัพธ์หลักของหลักสูตรนี้?', quizOptions: ['จำ Widget ให้ได้มากที่สุด', 'สร้าง mental model และระบบที่ทดสอบได้', 'แปลง JSX เป็น Dart แบบบรรทัดต่อบรรทัด']),
  Lesson(id: '02-react-to-flutter', title: 'แผนที่ความคิดจาก React และ Next.js สู่ Flutter', track: 'A · Orientation & Setup', description: 'ใช้ความรู้เดิมเป็นสะพาน แต่แยก DOM, Widget, runtime และ state ownership ให้ถูกต้อง', keywords: 'React Next.js JSX DOM Widget hooks provider', minutes: 28, level: 'เริ่มต้น', practice: 'เลือก React component เดิมหนึ่งตัวและเขียนรายการ responsibility ก่อนออกแบบเป็น Flutter โดยไม่เริ่มจาก JSX', quizQuestion: 'Widget ใกล้เคียงกับสิ่งใดมากที่สุด?', quizOptions: ['DOM node ที่แก้ property ได้', 'Immutable UI configuration', 'Browser process']),
  Lesson(id: '03-macos-toolchain', title: 'ติดตั้ง Flutter toolchain บน macOS และ VS Code', track: 'A · Orientation & Setup', description: 'เตรียม Flutter SDK, Android, iOS, Web, emulator, simulator และ VS Code ให้ตรวจสอบได้', keywords: 'macOS VS Code Xcode Android Studio CocoaPods flutter doctor', minutes: 40, level: 'เริ่มต้น', practice: 'รัน flutter doctor -v แล้วเขียนสรุปเฉพาะรายการที่กระทบ platform ที่ทีมจะรองรับ', quizQuestion: 'คำสั่งใดให้ภาพรวม toolchain ที่ตรวจสอบได้?', quizOptions: ['flutter clean', 'flutter doctor -v', 'dart format']),
  Lesson(id: '04-clone-and-run', title: 'Clone, Generate, Run และตรวจ Boilerplate', track: 'A · Orientation & Setup', description: 'นำ source ลงเครื่อง อ่าน config สร้าง generated code รัน environment และยืนยัน baseline ก่อนแก้ไข', keywords: 'git clone pub get build_runner environment demo login', minutes: 36, level: 'เริ่มต้น', practice: 'Clone ใหม่ในโฟลเดอร์ที่ไม่ sync cloud แล้วบันทึกผล generate, analyze และ test', quizQuestion: 'เหตุใดควรรัน baseline test ก่อนเริ่ม feature?', quizOptions: ['เพื่อให้ build ช้าลง', 'เพื่อแยกปัญหาเดิมออกจากสิ่งที่เราแก้', 'เพื่อสร้าง production token']),
  Lesson(id: '05-dart-types', title: 'Dart Types และโครงสร้างโปรแกรมสำหรับ TypeScript Developer', track: 'B · Dart for TypeScript', description: 'เรียน variable, inference, final, const, named parameter, enum, record และ switch expression', keywords: 'Dart TypeScript final const enum record switch', minutes: 45, level: 'พื้นฐาน', practice: 'สร้าง record สรุปจำนวน task เปิด/เสร็จ และใช้ switch expression แสดงสถานะ', quizQuestion: 'final และ const ต่างกันอย่างไร?', quizOptions: ['ไม่ต่างกัน', 'final กำหนดครั้งเดียวตอน runtime; const ต้องเป็น compile-time constant', 'const เปลี่ยนค่าได้']),
  Lesson(id: '06-null-collections-patterns', title: 'Null Safety, Collections และ Pattern Matching', track: 'B · Dart for TypeScript', description: 'จัดการ nullable type โดยไม่พึ่ง ! และเขียน collection transformation แบบอ่าน invariant ได้', keywords: 'null safety list map set pattern destructuring spread', minutes: 52, level: 'พื้นฐาน', practice: 'รับ List<Task?> แล้วคืนชื่อ task ที่ยังเปิดอยู่โดยไม่ใช้ ! และไม่แก้ list ต้นฉบับ', quizQuestion: 'ควรใช้ ! เมื่อใด?', quizOptions: ['เมื่อขี้เกียจเช็ก null', 'เมื่อมี invariant ที่พิสูจน์ได้ ณ จุดนั้น', 'ทุกครั้งหลังเรียก API']),
  Lesson(id: '07-functions-classes-generics', title: 'Functions, Classes, Immutability และ Generics', track: 'B · Dart for TypeScript', description: 'ออกแบบ API ด้วย named parameters, constructors, abstract interface, extension และ generic type', keywords: 'function class constructor interface extension generic immutable', minutes: 58, level: 'พื้นฐาน', practice: 'ออกแบบ immutable Task และ copyWith โดยห้าม expose mutable collection จาก repository', quizQuestion: 'ประโยชน์หลักของ named parameter คืออะไร?', quizOptions: ['ลด type safety', 'ทำให้ call site บอกความหมายและกำหนด required ได้', 'ทำให้ทุก parameter nullable']),
  Lesson(id: '08-async-errors-results', title: 'Future, Stream, Exception และ Typed Result', track: 'B · Dart for TypeScript', description: 'แยก asynchronous value, event stream, expected failure และ programming error ออกจากกัน', keywords: 'Future Stream async await exception sealed Result Failure', minutes: 62, level: 'พื้นฐาน', practice: 'เขียนฟังก์ชัน Future<Result<Task>> แล้วใช้ exhaustive switch จัดการ success/failure', quizQuestion: 'สิ่งใดควรเป็น Failure มากกว่า throw แบบไม่จำแนก?', quizOptions: ['Validation ที่ผู้ใช้แก้ได้', 'Null dereference จาก bug', 'Syntax error']),
  Lesson(id: '09-widget-runtime', title: 'Widget, Element, RenderObject และ BuildContext', track: 'C · Flutter Fundamentals', description: 'เข้าใจสาม tree, identity, rebuild, layout และ paint โดยไม่คิดว่า Widget คือ DOM node', keywords: 'Widget Element RenderObject BuildContext key rebuild repaint', minutes: 60, level: 'พื้นฐาน', practice: 'วาด tree ของหน้า Login และระบุส่วนที่ rebuild เมื่อ password visibility เปลี่ยน', quizQuestion: 'Widget object ทำหน้าที่อะไร?', quizOptions: ['เก็บ pixel บนจอถาวร', 'อธิบาย configuration ของ UI', 'เป็น network socket']),
  Lesson(id: '10-layout-theme-forms', title: 'Constraints, Responsive Layout, Theme และ Form', track: 'C · Flutter Fundamentals', description: 'ใช้ constraints-first layout สร้าง UI ที่รองรับมือถือ จอใหญ่ text scale และ keyboard', keywords: 'constraints Row Column Expanded LayoutBuilder theme form accessibility', minutes: 72, level: 'พื้นฐาน', practice: 'สร้าง form ที่เลื่อนเมื่อ keyboard เปิด รองรับ 200% text scale และปุ่มอย่างน้อย 48dp', quizQuestion: 'หลัก layout สำคัญของ Flutter คืออะไร?', quizOptions: ['Parent ส่ง constraints, child เลือก size, parent วาง position', 'Child กำหนด CSS width ให้ parent', 'ทุกอย่างใช้ absolute positioning']),
  Lesson(id: '11-state-lifecycle', title: 'State Ownership และ Lifecycle', track: 'C · Flutter Fundamentals', description: 'เลือก setState, controller หรือ Riverpod จาก owner, lifetime, sharing และ testability', keywords: 'StatefulWidget setState lifecycle controller Riverpod ownership', minutes: 54, level: 'พื้นฐาน', practice: 'จำแนก password visibility, login session และ task list ว่าควรอยู่ state ระดับใด พร้อมเหตุผล', quizQuestion: 'state ใดเหมาะกับ local widget state?', quizOptions: ['Access token ทั้งแอป', 'การเปิด/ปิด password field ในหน้าเดียว', 'รายการ task ที่หลาย route ใช้']),
  Lesson(id: '12-boilerplate-map', title: 'แผนที่ AI-first Flutter Boilerplate', track: 'D · Boilerplate Architecture', description: 'อ่าน app, core, features, shared, tests, docs และ entrypoints จาก responsibility ไม่ใช่ชื่อ folder', keywords: 'feature-first app core shared AGENTS layers imports', minutes: 55, level: 'กลาง', practice: 'เลือก feature ใหม่และวาด nearest-home path โดยยังไม่สร้าง shared abstraction', quizQuestion: 'ควรวาง utility ใหม่ใน shared เมื่อใด?', quizOptions: ['ทันทีที่สร้าง', 'เมื่อมีการใช้ข้าม feature ที่พิสูจน์แล้ว', 'เมื่อไฟล์มีเกิน 20 บรรทัด']),
  Lesson(id: '13-riverpod', title: 'Riverpod: State Graph และ Dependency Injection', track: 'D · Boilerplate Architecture', description: 'ใช้ provider เป็น dependency graph และ controller เป็นเจ้าของ application state ที่ทดสอบได้', keywords: 'Riverpod provider ref watch read listen override codegen', minutes: 70, level: 'กลาง', practice: 'สร้าง ProviderContainer override repository แล้วทดสอบ controller โดยไม่เรียก plugin หรือ network', quizQuestion: 'ref.watch เหมาะกับกรณีใด?', quizOptions: ['อ่านค่าที่ต้องทำให้ provider/widget rebuild เมื่อเปลี่ยน', 'event handler แบบครั้งเดียวเท่านั้น', 'เขียนไฟล์']),
  Lesson(id: '14-go-router', title: 'GoRouter, Redirect และ Authentication Guard', track: 'D · Boilerplate Architecture', description: 'ออกแบบ route table, named route, redirect policy, unknown route และ refresh จาก auth state', keywords: 'GoRouter redirect guard deep link route session', minutes: 56, level: 'กลาง', practice: 'เพิ่ม /tasks ลงบนกระดาษก่อน โดยเขียนผลลัพธ์เมื่อ signed-in และ signed-out', quizQuestion: 'guard ที่ปลอดภัยควรทำอย่างไรกับ route ที่ไม่รู้จักเมื่อ signed-out?', quizOptions: ['อนุญาตเสมอ', 'default deny ไป login', 'ปิดแอป']),
  Lesson(id: '15-network-storage-errors', title: 'Dio, DTO, Repository, Failure และ Secure Storage', track: 'D · Boilerplate Architecture', description: 'ติดตามข้อมูลจาก HTTP ผ่าน boundary ที่ typed จนเป็น state และแยก platform storage ออกจาก domain', keywords: 'Dio DTO repository AppException Failure secure storage', minutes: 78, level: 'กลาง', practice: 'เขียน mapping table จาก status 401, timeout และ invalid JSON ไป AppException/Failure', quizQuestion: 'DTO ควรออกไปถึง Presentation หรือไม่?', quizOptions: ['ควรทุกครั้ง', 'ไม่ควร ควร map เป็น domain entity ที่ data boundary', 'เฉพาะเมื่อเป็น JSON ใหญ่']),
  Lesson(id: '16-task-domain', title: 'Capstone: Model Task Domain ด้วย Test-first', track: 'E · Task Management', description: 'กำหนด entity, invariant, filter และ repository contract ก่อนเขียน UI', keywords: 'Task entity invariant repository contract TDD', minutes: 68, level: 'กลาง', practice: 'เพิ่ม invariant ว่า title หลัง trim ต้องยาว 3 ตัวขึ้นไป พร้อม failing test ก่อน implementation', quizQuestion: 'เหตุใดเริ่มจาก domain test?', quizOptions: ['เพราะ Widget test ใช้ไม่ได้', 'เพื่อกำหนด behavior โดยไม่ผูก UI หรือ I/O', 'เพื่อหลีกเลี่ยง type']),
  Lesson(id: '17-offline-repository', title: 'Capstone: Offline Datasource และ Repository', track: 'E · Task Management', description: 'สร้าง deterministic in-memory datasource และแปลง external record ผ่าน repository boundary', keywords: 'in-memory datasource repository mapping offline deterministic', minutes: 70, level: 'กลาง', practice: 'เพิ่ม failure สำหรับ task id ที่ไม่มีอยู่และยืนยันว่า repository คืน typed Result', quizQuestion: 'เหตุใด UI ไม่ควรเรียก datasource โดยตรง?', quizOptions: ['เพราะ Dart ห้าม import', 'เพราะจะผูก UI กับรูปแบบ I/O และทำให้เปลี่ยน/test ยาก', 'เพราะ datasource เร็วเกินไป']),
  Lesson(id: '18-task-riverpod', title: 'Capstone: Task State และ Filter ด้วย Riverpod', track: 'E · Task Management', description: 'ประกอบ use cases, controller, loading/success/failure state และ derived filtered tasks', keywords: 'Task controller Riverpod filter Async state provider', minutes: 78, level: 'กลาง', practice: 'เพิ่ม filter completed และทดสอบว่าการเปลี่ยน filter ไม่เรียก repository ซ้ำโดยไม่จำเป็น', quizQuestion: 'controller ควรเก็บสิ่งใด?', quizOptions: ['Dio Response โดยตรง', 'application state และ orchestration', 'BuildContext แบบถาวร']),
  Lesson(id: '19-task-form', title: 'Capstone: Create/Edit Form และ Validation', track: 'E · Task Management', description: 'สร้าง form ที่ accessible, scroll-safe, ป้องกัน duplicate submit และแสดง error ใกล้ field', keywords: 'Form validation TextEditingController focus accessibility submit', minutes: 82, level: 'กลาง', practice: 'เพิ่ม description limit และ widget test สำหรับ error, focus และ loading state', quizQuestion: 'ควรแสดง validation error เมื่อใด?', quizOptions: ['ตั้งแต่หน้าเปิดโดยผู้ใช้ยังไม่แตะ', 'หลัง interaction/submit พร้อมบอกวิธีแก้', 'เฉพาะใน console']),
  Lesson(id: '20-task-mutations', title: 'Capstone: Toggle, Update, Delete และ Feedback', track: 'E · Task Management', description: 'จัดการ mutation, confirmation, concurrency, rollback decision และ user feedback', keywords: 'CRUD mutation optimistic confirmation delete feedback concurrency', minutes: 72, level: 'กลาง', practice: 'ออกแบบ delete flow ที่ยืนยันก่อนลบและเขียน test ว่ายกเลิกแล้ว repository ไม่ถูกเรียก', quizQuestion: 'destructive action ควรมีอะไร?', quizOptions: ['ซ่อนปุ่ม', 'confirmation และ feedback/recovery ที่ชัด', 'ทำทันทีโดยไม่แจ้ง']),
  Lesson(id: '21-dio-datasource', title: 'Capstone: Real-API-ready Dio Datasource', track: 'E · Task Management', description: 'เพิ่ม request/response DTO, endpoint, checked decoding และ contract tests โดย default app ยัง offline', keywords: 'Dio remote datasource JSON DTO schema contract mock adapter', minutes: 88, level: 'กลาง', practice: 'เขียน malformed payload test ให้ยืนยันว่า schema error ไม่ถูกปล่อยเป็น raw object', quizQuestion: 'ทำไม runnable default ยังใช้ offline datasource?', quizOptions: ['เพื่อไม่ต้องมี test', 'เพื่อ deterministic onboarding และไม่ผูก public API', 'เพราะ Dio ใช้กับ Flutter ไม่ได้']),
  Lesson(id: '22-capstone-integration', title: 'Capstone: Route, Shell และ End-to-end Flow', track: 'E · Task Management', description: 'เชื่อม Tasks เข้ากับ GoRouter และ Home โดยรักษา auth guard และ public feature surface', keywords: 'integration route public API home auth guard smoke', minutes: 64, level: 'กลาง', practice: 'เขียน route test สำหรับ /tasks ทั้ง signed-in และ signed-out แล้วทดสอบ navigation จาก Home', quizQuestion: 'cross-feature import ที่เหมาะสมคืออะไร?', quizOptions: ['import ไฟล์ internal ทุกตัว', 'import public feature surface ที่ตั้งใจเปิด', 'copy class ไปอีก feature']),
  Lesson(id: '23-testing', title: 'Test Strategy: Unit ถึง Integration', track: 'F · Quality & Delivery', description: 'เลือก test level ตาม risk และ boundary พร้อมเขียน test ที่วัด behavior ไม่ใช่ mock call ที่ไม่สำคัญ', keywords: 'unit repository controller widget router integration golden test', minutes: 82, level: 'กลาง', practice: 'จัด test pyramid ของ feature หนึ่งและระบุ boundary ที่ต้อง mock กับ behavior ที่ต้องใช้ของจริง', quizQuestion: 'ควรมี integration test จำนวนเท่าใด?', quizOptions: ['มากกว่า unit ทุกครั้ง', 'เพียงพอสำหรับ critical user flows', 'ไม่ต้องมีถ้า coverage สูง']),
  Lesson(id: '24-debug-performance', title: 'Debugging, DevTools และ Performance', track: 'F · Quality & Delivery', description: 'ใช้ breakpoint, Inspector, CPU, memory, network, rebuild diagnostics และ structured logs หา root cause', keywords: 'debug breakpoint DevTools Inspector CPU memory rebuild performance', minutes: 76, level: 'กลาง', practice: 'จำลอง rebuild ที่ไม่จำเป็นหนึ่งจุด วัดก่อนแก้ และบันทึกหลักฐานหลังแก้', quizQuestion: 'ควร optimize เมื่อใด?', quizOptions: ['ก่อนวัดเสมอ', 'หลังวัดและพบ bottleneck ที่กระทบผู้ใช้', 'ทุกครั้งที่เห็น build method']),
  Lesson(id: '25-production-concerns', title: 'Environment, Security, Accessibility และ Localization', track: 'F · Quality & Delivery', description: 'แยก Dart config จาก native flavors จัดการ secrets/session/storage และเตรียมแอปสำหรับผู้ใช้หลากหลาย', keywords: 'flavor secrets session secure storage accessibility i18n RTL', minutes: 90, level: 'กลาง', practice: 'ทำ production gap checklist ของแอปตัวอย่างโดยแยก compile-ready ออกจาก release-ready', quizQuestion: 'production entrypoint หมายความว่า production-ready แล้วหรือไม่?', quizOptions: ['ใช่เสมอ', 'ไม่ ต้องตรวจ datasource, signing, session, security และ operations', 'ใช่ถ้าไม่มี debug banner']),
  Lesson(id: '26-build-release', title: 'Build Android, iOS และ Web', track: 'F · Quality & Delivery', description: 'เข้าใจ build mode, signing, artifact, environment define, platform requirements และ release verification', keywords: 'build apk appbundle ipa web release signing artifact', minutes: 84, level: 'กลาง', practice: 'สร้าง Web release และ Android debug artifact แล้วบันทึก command, output path และ warning', quizQuestion: 'build ผ่านพิสูจน์อะไร?', quizOptions: ['พิสูจน์ production readiness ทั้งหมด', 'พิสูจน์ว่า source compile/package ในเงื่อนไขนั้น', 'พิสูจน์ backend ปลอดภัย']),
  Lesson(id: '27-production-checklist', title: 'Production Readiness และ Next-system Checklist', track: 'F · Quality & Delivery', description: 'ประเมิน auth, API, data, test, CI, release, privacy และ operations ก่อนส่งระบบจริง', keywords: 'production readiness checklist CI release privacy observability', minutes: 58, level: 'กลาง', practice: 'ให้คะแนนระบบตัวอย่างตาม checklist และเลือก P0 สามข้อพร้อม acceptance criteria', quizQuestion: 'P0 ควรหมายถึงอะไร?', quizOptions: ['สิ่งที่น่าสนใจทำทีหลัง', 'สิ่งที่ต้องปิดก่อนใช้งานจริงเพราะ risk สูง', 'สีของปุ่ม']),
  Lesson(id: '28-ai-workflow', title: 'ใช้ AI พัฒนา Flutter อย่างมีขอบเขตและหลักฐาน', track: 'F · Quality & Delivery', description: 'เขียน prompt ให้ AI สำรวจ pattern, วางแผน, TDD, review และรายงาน verification โดยไม่ขยาย scope', keywords: 'AI Codex prompt plan TDD review verification AGENTS', minutes: 54, level: 'กลาง', practice: 'เขียน prompt เพิ่ม task priority โดยกำหนดไฟล์, invariant, test และ verification ที่ต้องรายงาน', quizQuestion: 'prompt ที่ดีควรมีอะไร?', quizOptions: ['บอกเพียง “ทำให้ดี”', 'scope, pattern, behavior, constraints และหลักฐาน verification', 'ให้ AI ข้าม test เพื่อเร็วขึ้น']),
  Lesson(id: 'commands', title: 'Command Cookbook', track: 'Reference', description: 'รวมคำสั่ง Flutter, Dart, codegen, test, build และ Git พร้อมความหมายและแนวทางแก้เมื่อผิดพลาด', keywords: 'command flutter dart git build test analyze', minutes: 30, level: 'อ้างอิง', practice: 'เลือก command chain สำหรับก่อนเปิด PR และอธิบายว่าแต่ละคำสั่งป้องกันความเสี่ยงอะไร', quizQuestion: 'คำสั่งใดตรวจ static analysis?', quizOptions: ['flutter analyze', 'flutter clean', 'git status'], reference: true),
  Lesson(id: 'glossary', title: 'React/Next.js ↔ Flutter Glossary', track: 'Reference', description: 'ศัพท์เปรียบเทียบมากกว่า 60 รายการพร้อมข้อจำกัดของ analogy', keywords: 'glossary React Next Flutter Dart mapping', minutes: 35, level: 'อ้างอิง', practice: 'เลือก 5 คู่ที่ analogy อาจทำให้เข้าใจผิดและเขียนข้อแตกต่าง', quizQuestion: 'analogy มีไว้เพื่ออะไร?', quizOptions: ['แทนความจริงทั้งหมด', 'ช่วยเริ่ม mental model แล้วต้องเรียนข้อแตกต่าง', 'ทำให้ไม่ต้องอ่านโค้ด'], reference: true),
  Lesson(id: 'architecture-decisions', title: 'Architecture Decision Matrix', track: 'Reference', description: 'ตารางตัดสินใจเลือก layer, state owner, repository, storage, routing และ test level', keywords: 'decision matrix layer state repository storage routing', minutes: 30, level: 'อ้างอิง', practice: 'ใช้ matrix ตัดสินใจตำแหน่งของ notification settings feature', quizQuestion: 'decision ที่ดีควรเริ่มจากอะไร?', quizOptions: ['ชื่อ library', 'responsibility, lifetime, boundary และ risk', 'จำนวน folder'], reference: true),
  Lesson(id: 'troubleshooting', title: 'Troubleshooting Catalog', track: 'Reference', description: 'อาการ สาเหตุ วิธีตรวจ และวิธีแก้สำหรับ SDK, codegen, Gradle, CocoaPods, route, Riverpod และ test', keywords: 'troubleshooting error Gradle CocoaPods codegen route Riverpod', minutes: 45, level: 'อ้างอิง', practice: 'เลือก error หนึ่งรายการและทำตาม diagnose-first flow โดยไม่ล้าง cache แบบเดาสุ่ม', quizQuestion: 'ขั้นแรกของ debugging คืออะไร?', quizOptions: ['ลบทุก cache', 'ทำให้ปัญหาเกิดซ้ำและเก็บหลักฐาน', 'เปลี่ยน dependency ทั้งหมด'], reference: true),
];

void main() {
  final template = File('templates/page.html').readAsStringSync();
  for (var index = 0; index < lessons.length; index += 1) {
    final lesson = lessons[index];
    final contentFile = File(lesson.contentPath);
    if (!contentFile.existsSync()) {
      stderr.writeln('Missing lesson content: ${lesson.contentPath}');
      exitCode = 1;
      return;
    }

    final content = contentFile.readAsStringSync();
    final output = _renderPage(
      template: template,
      lesson: lesson,
      lessonIndex: index,
      content: content,
    );
    final outputFile = File(lesson.outputPath);
    outputFile.parent.createSync(recursive: true);
    outputFile.writeAsStringSync(output);
  }

  _writeCatalog();
  stdout.writeln('Built ${lessons.length} guide pages.');
}

String _renderPage({
  required String template,
  required Lesson lesson,
  required int lessonIndex,
  required String content,
}) {
  final number = lesson.reference
      ? 'REF'
      : (lessonIndex + 1).toString().padLeft(2, '0');
  final toc = _buildTableOfContents(content);
  final previous = lessonIndex == 0
      ? '<span></span>'
      : _paginationLink(lessons[lessonIndex - 1], 'ก่อนหน้า');
  final next = lessonIndex == lessons.length - 1
      ? '<a href="../index.html">กลับหน้าแรก →</a>'
      : _paginationLink(lessons[lessonIndex + 1], 'บทถัดไป');

  return template
      .replaceAll('{{DESCRIPTION}}', _escapeAttribute(lesson.description))
      .replaceAll('{{TITLE}}', lesson.title)
      .replaceAll('{{SHORT_TITLE}}', '$number · ${lesson.title}')
      .replaceAll('{{TRACK}}', lesson.track)
      .replaceAll('{{NUMBER}}', number)
      .replaceAll('{{MINUTES}}', '${lesson.minutes}')
      .replaceAll('{{LEVEL}}', lesson.level)
      .replaceAll('{{KEYWORDS}}', lesson.keywords)
      .replaceAll('{{NAVIGATION}}', _buildNavigation(lesson.id))
      .replaceAll('{{CONTENT}}', content)
      .replaceAll('{{LEARNING_FOOTER}}', _buildLearningFooter(lesson))
      .replaceAll('{{TABLE_OF_CONTENTS}}', toc)
      .replaceAll('{{PREVIOUS}}', previous)
      .replaceAll('{{NEXT}}', next)
      .replaceAll('{{ID}}', lesson.id);
}

String _buildNavigation(String currentId) {
  final buffer = StringBuffer();
  String? currentTrack;
  for (var index = 0; index < lessons.length; index += 1) {
    final lesson = lessons[index];
    if (lesson.track != currentTrack) {
      currentTrack = lesson.track;
      buffer.writeln('<p class="nav-heading">${lesson.track}</p>');
      buffer.writeln('<nav class="course-nav">');
    }
    final number =
        lesson.reference ? 'R' : (index + 1).toString().padLeft(2, '0');
    final current = lesson.id == currentId ? ' aria-current="page"' : '';
    buffer.writeln(
      '<a href="../${lesson.outputPath}"$current>'
      '<span class="nav-index">$number</span>${lesson.title}</a>',
    );
    final isLast = index == lessons.length - 1 ||
        lessons[index + 1].track != currentTrack;
    if (isLast) buffer.writeln('</nav>');
  }
  return buffer.toString();
}

String _buildTableOfContents(String content) {
  final headings = RegExp(
    r'<h2\s+id="([^"]+)">([^<]+)</h2>',
    caseSensitive: false,
  ).allMatches(content);
  final links = <String>[
    for (final heading in headings)
      '<a href="#${heading.group(1)}">${heading.group(2)}</a>',
    '<a href="#checkpoint">Checkpoint</a>',
    '<a href="#quiz">Quiz</a>',
    '<a href="#practice">Practice</a>',
  ];
  return links.join('\n');
}

String _buildLearningFooter(Lesson lesson) {
  final options = lesson.quizOptions.indexed.map((entry) {
    final isCorrect = entry.$1 == 1;
    return '<button class="quiz-option" type="button" '
        'data-correct="$isCorrect">${entry.$2}</button>';
  }).join();

  return '''
<section class="checkpoint" id="checkpoint">
  <h2>Checkpoint ก่อนเดินต่อ</h2>
  <ol>
    <li>อธิบายหัวข้อนี้ด้วยภาษาของตนเองโดยไม่เปิดคู่มือ</li>
    <li>ชี้ไฟล์หรือคำสั่งใน Boilerplate ที่สัมพันธ์กับบทนี้ได้</li>
    <li>รันตัวอย่างหรือ verification ที่บทกำหนดและอ่านผลลัพธ์ได้</li>
  </ol>
</section>
<section class="quiz" id="quiz">
  <h2>Quiz ตรวจ mental model</h2>
  <p><strong>${lesson.quizQuestion}</strong></p>
  <div class="quiz-options">$options</div>
  <p class="quiz-feedback" aria-live="polite"></p>
</section>
<section class="exercise" id="practice">
  <h2>Practice</h2>
  <p>${lesson.practice}</p>
  <p><strong>Definition of done:</strong> อธิบายเหตุผลของ design, แสดงผลลัพธ์ที่รันจริง และไม่มี warning ที่ถูกมองข้าม</p>
</section>
''';
}

String _paginationLink(Lesson lesson, String label) {
  return '<a href="../${lesson.outputPath}">$label<br>'
      '<strong>${lesson.title}</strong></a>';
}

String _escapeAttribute(String value) {
  return const HtmlEscape(HtmlEscapeMode.attribute).convert(value);
}

void _writeCatalog() {
  final records = lessons.map((lesson) {
    return <String, Object>{
      'id': lesson.id,
      'title': lesson.title,
      'track': lesson.track,
      'keywords': lesson.keywords,
      'url': lesson.outputPath,
      'kind': lesson.reference ? 'reference' : 'chapter',
    };
  }).toList();
  File('assets/js/catalog.js').writeAsStringSync(
    'window.FlutterGuideCatalog = '
    '${const JsonEncoder.withIndent('  ').convert(records)};\n',
  );
}
