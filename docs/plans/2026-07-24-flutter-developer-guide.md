# Flutter Developer Guide Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use
> superpowers:subagent-driven-development (recommended) or
> superpowers:executing-plans to implement this plan task-by-task. Steps use
> checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Thai-language, offline multi-page Flutter learning portal and
a tested Task Management example based on the AI-first Flutter boilerplate.

**Architecture:** Static HTML pages share one CSS and one classic JavaScript
file so they work from `file://`. A copied boilerplate under
`example/task_management_app` adds a feature-first Tasks vertical slice backed
by an in-memory datasource, while a documented remote datasource demonstrates
Dio without making the runnable application depend on a server.

**Tech Stack:** HTML5, CSS, classic JavaScript, Dart 3.12.2, Flutter
3.44.8, Riverpod 3, GoRouter, Dio, Freezed, flutter_test, and mocktail.

## Global Constraints

- Explanations are Thai; code identifiers and technical terms remain English.
- The website must work directly from `file://` without CDN, fetch, Node.js, or
  a service worker.
- macOS and VS Code are the primary setup path; Windows/Linux differences are
  concise callouts.
- Every learning chapter contains objectives, React/Next bridge, explanation,
  code lab, mistakes, checkpoint, quiz, and practice.
- Diagrams are semantic HTML/CSS figures and explain real relationships or
  sequences without external assets.
- The example project runs offline by default.
- Source boilerplate architecture and `AGENTS.md` rules remain authoritative.
- No real credentials, tokens, backend URL, or production-authentication claim
  may appear.
- Site and example must be validated before delivery.

---

### Task 1: Repository and offline site foundation

**Files:**
- Create: `README.md`
- Create: `index.html`
- Create: `assets/css/site.css`
- Create: `assets/js/site.js`
- Create: `tools/validate_site.dart`
- Test: `tools/validate_site.dart`

**Interfaces:**
- Consumes: the curriculum and visual rules in the design spec.
- Produces: `.site-shell`, `.sidebar`, `.lesson`, `.callout`, `.code-block`,
  `.quiz`, `GuideProgress`, search metadata, theme controls, and the validation
  command used by every later task.

- [ ] **Step 1: Write the validator before site pages**

Create a Dart script using `dart:io` that:

```dart
final htmlFiles = Directory.current
    .listSync(recursive: true)
    .whereType<File>()
    .where((file) => file.path.endsWith('.html'));

if (htmlFiles.isEmpty) {
  stderr.writeln('No HTML files found.');
  exitCode = 1;
}
```

For each HTML file, require `<!doctype html>`, `<html lang="th">`, a non-empty
`<title>`, a skip link, one `<main>`, and no `http://` or `https://` resource
references. Resolve every local `href` and `src` after stripping fragments.

- [ ] **Step 2: Run the validator and verify the empty-site failure**

Run: `dart run tools/validate_site.dart`

Expected: exit 1 containing `No HTML files found.`

- [ ] **Step 3: Implement the site shell**

Create `index.html` with a skip link, responsive sidebar, header, learning-path
cards, progress summary, reference links, and a `<noscript>` notice. Create CSS
tokens for paper, ink, navy, emerald, amber, and coral themes. Create classic
JavaScript that exposes:

```javascript
window.FlutterGuide = {
  setTheme(theme) {},
  toggleNavigation() {},
  openSearch() {},
  markComplete(chapterId, complete) {},
  answerQuiz(button, correct) {},
};
```

Use guarded `localStorage` access and inject copy buttons without changing code
content.

- [ ] **Step 4: Validate the site foundation**

Run: `dart run tools/validate_site.dart`

Expected: `Validated 1 HTML file; 0 broken local links.`

- [ ] **Step 5: Commit**

```bash
git add README.md index.html assets tools
git commit -m "feat: add offline learning portal foundation"
```

### Task 2: Explanatory HTML/CSS diagram system

**Files:**
- Create: `components/diagram-patterns.html`
- Modify: `assets/css/site.css`
- Modify: `index.html`

**Interfaces:**
- Consumes: CSS color tokens and semantic figure patterns.
- Produces: `.flow-diagram`, `.concept-map`, `.tree-diagram`,
  `.pipeline-diagram`, `.test-pyramid`, and ten selectable, responsive figures
  with visible titles and adjacent text descriptions.

- [ ] **Step 1: Add diagram validation**

Extend `tools/validate_site.dart` so every element with
`class="diagram"` contains a `<figcaption>` and a neighboring prose
description.

- [ ] **Step 2: Verify missing diagram requirements fail**

Add one temporary incomplete `<figure class="diagram">`, run the validator,
confirm it fails with `Diagram requires figcaption and description`, then
remove the temporary figure.

- [ ] **Step 3: Draw all ten diagrams**

Use semantic lists, readable labels, CSS arrows with explicit direction, and
legend text. Keep labels at least 14 CSS pixels and preserve reading order
without CSS.

- [ ] **Step 4: Add the learning-map image to the landing page**

Embed with:

```html
<figure class="diagram concept-map" aria-labelledby="react-map-title">
  <div class="diagram-canvas"><!-- labeled concept nodes --></div>
  <figcaption>เริ่มจากสิ่งที่คุ้นเคย แล้วเปลี่ยน mental model</figcaption>
</figure>
<p class="diagram-description" id="react-map-title">
  แผนภาพจับคู่ React component กับ Flutter Widget และอธิบายจุดที่ไม่เท่ากัน
</p>
```

- [ ] **Step 5: Validate and commit**

Run: `dart run tools/validate_site.dart`

Expected: all diagram checks pass.

```bash
git add components assets/css/site.css index.html tools/validate_site.dart
git commit -m "feat: add explanatory Flutter diagrams"
```

### Task 3: Orientation and setup track

**Files:**
- Create: `chapters/01-orientation.html`
- Create: `chapters/02-react-to-flutter.html`
- Create: `chapters/03-macos-toolchain.html`
- Create: `chapters/04-clone-and-run.html`
- Modify: `assets/js/site.js`
- Modify: `index.html`

**Interfaces:**
- Produces chapter IDs `01-orientation` through `04-clone-and-run`, previous and
  next links, and search records `{id,title,track,keywords,url}`.

- [ ] **Step 1: Create the four chapter pages**

Include exact macOS commands:

```bash
git clone git@github.com:PattanasakGit/flutter-boilerplate.git
cd flutter-boilerplate
flutter doctor -v
flutter pub get
dart run build_runner build
flutter run -t lib/main_development.dart
```

Explain VS Code extensions, device selection, `.fvmrc`, `pubspec.yaml`,
generated code, fake demo credentials, and why the production entrypoint is not
production authentication.

- [ ] **Step 2: Add React/Next translation tables**

Cover `package.json` ↔ `pubspec.yaml`, npm scripts ↔ Flutter commands, browser
runtime ↔ Flutter engine, fast refresh ↔ hot reload, and route trees ↔ GoRouter.

- [ ] **Step 3: Add labs, quizzes, and checkpoints**

Every chapter must have one command lab, three common mistakes, a deterministic
checkpoint, a three-question quiz, and one practice exercise.

- [ ] **Step 4: Register navigation and search**

Add all four records to `site.js` and learning-path cards to `index.html`.

- [ ] **Step 5: Validate and commit**

```bash
dart run tools/validate_site.dart
git add chapters assets/js/site.js index.html
git commit -m "docs: add orientation and setup curriculum"
```

### Task 4: Dart for TypeScript developers track

**Files:**
- Create: `chapters/05-dart-types.html`
- Create: `chapters/06-null-collections-patterns.html`
- Create: `chapters/07-functions-classes-generics.html`
- Create: `chapters/08-async-errors-results.html`
- Modify: `assets/js/site.js`
- Modify: `index.html`

**Interfaces:**
- Produces runnable Dart examples and the mental model required by every later
  Flutter chapter.

- [ ] **Step 1: Teach types and program structure**

Include actual examples for `final`, `const`, inference, named parameters,
enums, records, and exhaustive switch expressions. Compare each with
TypeScript without claiming structural typing equivalence.

- [ ] **Step 2: Teach null safety and collections**

Demonstrate `?`, `!`, `??`, `late`, collection-if, collection-for, spread,
destructuring, and pattern matching. Include a table explaining when `!` is
evidence-backed and when it hides a design error.

- [ ] **Step 3: Teach object and generic design**

Use immutable `Task`, named constructors, factory constructors, abstract
interfaces, extensions, generics, equality, and copy semantics.

- [ ] **Step 4: Teach asynchronous and typed error logic**

Show `Future`, `async/await`, `Stream`, cancellation limitations, exception
boundaries, sealed `Result<T>`, and exhaustive pattern matching:

```dart
switch (result) {
  case Success(:final data):
    return data;
  case Error(:final failure):
    throw StateError(failure.message);
}
```

- [ ] **Step 5: Add labs, quizzes, search, validate, and commit**

```bash
dart run tools/validate_site.dart
git add chapters assets/js/site.js index.html
git commit -m "docs: teach Dart through TypeScript comparisons"
```

### Task 5: Flutter fundamentals track

**Files:**
- Create: `chapters/09-widget-runtime.html`
- Create: `chapters/10-layout-theme-forms.html`
- Create: `chapters/11-state-lifecycle.html`
- Modify: `assets/js/site.js`
- Modify: `index.html`

**Interfaces:**
- Produces the widget and state mental models consumed by Riverpod and capstone
  UI chapters.

- [ ] **Step 1: Explain the three-tree runtime**

Explain Widget, Element, RenderObject, `BuildContext`, keys, rebuild versus
repaint, and why calling `build` is not DOM mutation. Use
`flutter-trees.svg`.

- [ ] **Step 2: Teach constraints-first layout**

Cover `Row`, `Column`, `Expanded`, `Flexible`, `Stack`, scrolling,
`LayoutBuilder`, `MediaQuery`, SafeArea, themes, Material 3, text scale, and
48×48 touch targets.

- [ ] **Step 3: Teach local and application state**

Compare `StatefulWidget`/`setState`, controllers, `ValueNotifier`, and Riverpod.
Define a decision table based on ownership, lifetime, sharing, persistence, and
testability.

- [ ] **Step 4: Add interactive exercises and validate**

Each exercise must predict a layout or rebuild before revealing the answer.

- [ ] **Step 5: Commit**

```bash
git add chapters assets/js/site.js index.html
git commit -m "docs: add Flutter runtime and UI fundamentals"
```

### Task 6: Boilerplate architecture track

**Files:**
- Create: `chapters/12-boilerplate-map.html`
- Create: `chapters/13-riverpod.html`
- Create: `chapters/14-go-router.html`
- Create: `chapters/15-network-storage-errors.html`
- Modify: `assets/js/site.js`
- Modify: `index.html`

**Interfaces:**
- Consumes current boilerplate paths and public types.
- Produces exact source maps and rules used to implement the example.

- [ ] **Step 1: Map every repository responsibility**

Explain `app`, `core`, `features`, `shared`, `test`, `docs`, entrypoints, and
scripts. Include the feature-first import matrix and nearest-home rule.

- [ ] **Step 2: Explain Riverpod composition**

Trace provider creation, overrides, `ref.watch`, `ref.read`, `ref.listen`,
controller lifecycle, dependency injection, and generated provider files.

- [ ] **Step 3: Explain routing and guards**

Trace signed-out, signed-in, unknown-route, and logout flows through
`app_router.dart`. Explain redirect loops and refresh notifications.

- [ ] **Step 4: Explain the external-data pipeline**

Trace Dio request → DTO → Entity → Repository → Result → Controller. Explain
secure-storage boundaries and current production gaps without implying they are
already solved.

- [ ] **Step 5: Validate source paths and commit**

Add source-path checks to `tools/validate_site.dart` for all referenced example
files, then:

```bash
dart run tools/validate_site.dart
git add chapters assets/js/site.js index.html tools/validate_site.dart
git commit -m "docs: explain the boilerplate architecture"
```

### Task 7: Task domain and offline data with TDD

**Files:**
- Create: `example/task_management_app/` from a clean boilerplate archive
- Create: `lib/features/tasks/domain/entities/task.dart`
- Create: `lib/features/tasks/domain/repositories/task_repository.dart`
- Create: `lib/features/tasks/application/task_use_cases.dart`
- Create: `lib/features/tasks/data/datasources/task_local_datasource.dart`
- Create: `lib/features/tasks/data/repositories/task_repository_impl.dart`
- Create: `lib/features/tasks/tasks_providers.dart`
- Test: matching files under `test/features/tasks/`

**Interfaces:**
- Produces `Task`, `TaskFilter`, `TaskRepository`, `GetTasks`, `CreateTask`,
  `UpdateTask`, `ToggleTask`, `DeleteTask`, `InMemoryTaskDatasource`, and
  `TaskRepositoryImpl`.

- [ ] **Step 1: Copy the clean boilerplate**

Use `git archive HEAD` from the source repository so `.git`, `.dart_tool`,
`build`, and iCloud conflict copies are excluded.

- [ ] **Step 2: Write failing entity and use-case tests**

Test trimmed titles, empty-title validation, immutable updates, filter behavior,
missing IDs, create/update/toggle/delete order, and typed failures.

- [ ] **Step 3: Implement domain and application code**

Use pure Dart, immutable objects, deterministic injected IDs, and the existing
`Result<T>`/`Failure` types.

- [ ] **Step 4: Write failing repository tests**

Test mapping from datasource records, stable insertion order, independent
instances, and failure conversion.

- [ ] **Step 5: Implement datasource, repository, and providers**

Seed three tasks and keep all mutation inside the datasource. Compose the
repository in Riverpod without exposing the datasource to presentation.

- [ ] **Step 6: Run focused tests and commit**

```bash
flutter test test/features/tasks/domain test/features/tasks/application \
  test/features/tasks/data
git add example/task_management_app
git commit -m "feat: add task domain and offline data"
```

### Task 8: Task controller and UI with TDD

**Files:**
- Create: `lib/features/tasks/presentation/controllers/task_list_controller.dart`
- Create: generated provider output
- Create: `lib/features/tasks/presentation/pages/task_list_page.dart`
- Create: `lib/features/tasks/presentation/widgets/task_form_sheet.dart`
- Create: `lib/features/tasks/presentation/widgets/task_card.dart`
- Create: `lib/features/tasks/tasks.dart`
- Test: controller and widget tests under `test/features/tasks/`

**Interfaces:**
- Produces `TaskListState`, `TaskListController`, responsive task UI, form
  validation, filters, and accessible actions.

- [ ] **Step 1: Write failing controller tests**

Test initial load, filter selection, create, edit, toggle, delete, duplicate
submission blocking, and failure messages.

- [ ] **Step 2: Implement controller state**

Use a sealed or invariant-preserving state shape so loading, success, and
failure cannot contain contradictory payloads.

- [ ] **Step 3: Write failing widget tests**

Test loading, seeded tasks, empty filtering, form validation, successful
creation, completion semantics, and delete confirmation.

- [ ] **Step 4: Implement responsive accessible widgets**

Use labeled fields, visible focus, minimum touch targets, live-region errors,
keyboard submission, safe scrolling, and wide/narrow layout branches.

- [ ] **Step 5: Generate, run focused tests, and commit**

```bash
dart run build_runner build
flutter test test/features/tasks
git add example/task_management_app
git commit -m "feat: add task management interface"
```

### Task 9: Route and shell integration

**Files:**
- Modify: `lib/app/router/app_routes.dart`
- Modify: `lib/app/router/app_router.dart`
- Modify: `lib/features/home/presentation/pages/home_page.dart`
- Test: `test/app/router/app_router_test.dart`
- Test: `test/features/home/home_page_test.dart`

**Interfaces:**
- Produces authenticated `/tasks` navigation and a visible Home entry point.

- [ ] **Step 1: Write failing route tests**

Assert signed-out `/tasks` redirects to login, signed-in `/tasks` renders the
task page, and unknown routes retain the existing fallback.

- [ ] **Step 2: Add the route and Home action**

Define a named tasks route, import only the `tasks.dart` public surface, and add
an accessible `Open task manager` action to Home.

- [ ] **Step 3: Verify existing authentication behavior**

Run:

```bash
flutter test test/app/router test/features/home
```

Expected: new and existing route/logout tests pass.

- [ ] **Step 4: Commit**

```bash
git add example/task_management_app
git commit -m "feat: integrate task management routing"
```

### Task 10: Capstone curriculum

**Files:**
- Create: `chapters/16-task-domain.html`
- Create: `chapters/17-offline-repository.html`
- Create: `chapters/18-task-riverpod.html`
- Create: `chapters/19-task-form.html`
- Create: `chapters/20-task-mutations.html`
- Create: `chapters/21-dio-datasource.html`
- Create: `chapters/22-capstone-integration.html`
- Modify: `assets/js/site.js`
- Modify: `index.html`

**Interfaces:**
- Consumes exact example paths and verified APIs from Tasks 7–9.
- Produces the complete guided build sequence.

- [ ] **Step 1: Teach domain-first modeling and red-green-refactor**

Use the exact `Task` and repository tests, explain why business rules precede
widgets, and map TypeScript interfaces to nominal Dart interfaces.

- [ ] **Step 2: Teach repository and Riverpod flows**

Trace each call through datasource, repository, use case, controller, and UI.
Use the task CRUD and error diagrams.

- [ ] **Step 3: Teach forms and mutations**

Cover controllers, validation, focus, optimistic versus confirmed updates,
confirmation dialogs, concurrency, and accessible feedback.

- [ ] **Step 4: Teach real-API readiness**

Provide complete Dio request/DTO/schema-mapping code and contract tests while
keeping the runnable composition offline.

- [ ] **Step 5: Register, validate, and commit**

```bash
dart run tools/validate_site.dart
git add chapters assets/js/site.js index.html
git commit -m "docs: add the task management capstone"
```

### Task 11: Quality, delivery, production, and AI track

**Files:**
- Create: `chapters/23-testing.html`
- Create: `chapters/24-debug-performance.html`
- Create: `chapters/25-production-concerns.html`
- Create: `chapters/26-build-release.html`
- Create: `chapters/27-production-checklist.html`
- Create: `chapters/28-ai-workflow.html`
- Modify: `assets/js/site.js`
- Modify: `index.html`

**Interfaces:**
- Produces exact verification/build workflows and explicitly scoped production
  guidance.

- [ ] **Step 1: Teach the test strategy**

Explain unit, repository, controller, widget, router, integration, and golden
tests; mock boundaries rather than internal implementation.

- [ ] **Step 2: Teach debugging and performance**

Cover breakpoints, Flutter Inspector, CPU/memory/network views, rebuild
diagnostics, logs, async stack traces, and release/profile differences.

- [ ] **Step 3: Teach production concerns**

Cover native flavors, secrets, secure storage, auth lifecycle, localization,
RTL, accessibility, privacy, observability, and dependency maintenance.

- [ ] **Step 4: Teach exact build commands**

Include:

```bash
flutter build apk -t lib/main_production.dart --release
flutter build appbundle -t lib/main_production.dart --release
flutter build ios -t lib/main_production.dart --release
flutter build ipa -t lib/main_production.dart --release
flutter build web -t lib/main_production.dart --release
```

Explain signing, output paths, environment definitions, and why successful
compilation does not equal production readiness.

- [ ] **Step 5: Teach scoped AI collaboration**

Provide prompt templates for exploration, implementation, debugging, review,
and verification that require agents to cite repository patterns and evidence.

- [ ] **Step 6: Validate and commit**

```bash
dart run tools/validate_site.dart
git add chapters assets/js/site.js index.html
git commit -m "docs: add quality delivery and AI curriculum"
```

### Task 12: Reference center and final verification

**Files:**
- Create: `reference/commands.html`
- Create: `reference/glossary.html`
- Create: `reference/architecture-decisions.html`
- Create: `reference/troubleshooting.html`
- Modify: `README.md`
- Modify: `index.html`
- Modify: `assets/js/site.js`

**Interfaces:**
- Produces a searchable reference layer and final delivered repository.

- [ ] **Step 1: Write the four reference pages**

Include command purposes and failure recovery, at least 60 glossary mappings,
layer/state/storage/routing decision tables, and troubleshooting for SDK,
codegen, Gradle, CocoaPods, simulator, Web, iCloud conflict copies, routing,
Riverpod, tests, and signing.

- [ ] **Step 2: Run site structural validation**

Run: `dart run tools/validate_site.dart`

Expected: all 33 HTML pages and ten explanatory figures pass with zero broken
links.

- [ ] **Step 3: Verify the example project**

Run from `example/task_management_app`:

```bash
dart format --output=none --set-exit-if-changed .
dart run build_runner build
git diff --exit-code
flutter analyze
flutter test
flutter build web -t lib/main_production.dart --release
```

Expected: formatting unchanged, generation unchanged, no analyzer issues, all
tests pass, and Web release output is produced.

- [ ] **Step 4: Browser QA**

Open `index.html` from `file://` and verify desktop 1440×900 and mobile 390×844.
Test sidebar, search, theme, progress, copy, quiz, chapter links, keyboard focus,
reduced motion, and browser console logs. Inspect at least one explanatory
figure and one deep chapter directly.

- [ ] **Step 5: Final content audit**

Search for unresolved work markers, placeholder copy, external resources, fake
production claims, and stale paths. Confirm every search record resolves.

- [ ] **Step 6: Commit and deliver**

```bash
git add .
git commit -m "docs: complete the Flutter developer learning portal"
```

Copy the verified repository to the requested `flutter-document` directory
without overwriting unrelated content.
