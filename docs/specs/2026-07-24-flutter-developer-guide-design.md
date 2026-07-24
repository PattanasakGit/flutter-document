# Flutter Developer Guide Design

Date: 2026-07-24
Status: Approved by delegated user direction
Audience: React and Next.js developers learning Dart and Flutter
Source project: `PattanasakGit/flutter-boilerplate`

## 1. Goal

Create an extensive Thai-language, offline-first learning portal that takes a
web developer from cloning the AI-first Flutter boilerplate through designing,
implementing, testing, debugging, and building a production-minded Flutter
application.

The guide must teach concepts rather than only list commands. Every major
Flutter or Dart idea must connect to a familiar React, Next.js, TypeScript, or
browser-development concept and then show the correct Flutter mental model.

Completion means a reader can:

1. Prepare a macOS Flutter development environment.
2. Read and write idiomatic null-safe Dart.
3. Explain Flutter's declarative widget, element, and render-object model.
4. Navigate the boilerplate and follow its architectural rules.
5. Build a complete Task Management vertical slice.
6. Use Riverpod, GoRouter, Dio, typed results, and secure storage correctly.
7. Write unit, controller, widget, and router tests.
8. Debug and profile the application.
9. Build Android, iOS, and Web artifacts.
10. Identify the work still required before a real production release.

## 2. Selected Approach

### Chosen: offline learning portal plus completed example project

The deliverable is a multi-page static website with a complete Flutter example
project stored beside it. It opens directly from `index.html` without a server,
CDN, package manager, or network connection.

This approach was selected over:

- A linear ebook, which is easy to read but weak for navigation and reference.
- A reference encyclopedia, which is searchable but does not create a guided
  learning path.

The selected portal combines a guided curriculum with reference-style search,
progress tracking, exercises, diagrams, and an executable end state.

## 3. Language and Teaching Style

- Explanations are written in Thai.
- Dart, Flutter, API, class, file, command, and architecture names remain in
  English.
- New terminology appears as `English term — Thai explanation`.
- Code comments are concise English so examples resemble production code.
- Each chapter uses the same pedagogical sequence:
  1. Learning objectives
  2. React/Next.js bridge
  3. Mental model
  4. Boilerplate source map
  5. Guided code lab
  6. Data/state/error flow
  7. Common mistakes
  8. Checkpoint
  9. Quiz
  10. Practice exercise

The guide explicitly distinguishes conceptual analogies from implementation
equivalence. For example, a Flutter widget is compared with a React component
to establish familiarity, then the guide explains why widgets are immutable
configuration rather than DOM nodes.

## 4. Information Architecture

### Track A — Orientation and Setup

1. How to use the guide
2. React/Next.js to Flutter mental map
3. macOS toolchain, VS Code, Flutter Doctor, simulators, and devices
4. Clone, inspect, generate, run, and verify the boilerplate

### Track B — Dart for TypeScript Developers

5. Dart program structure, variables, types, and inference
6. Null safety, control flow, collections, records, and patterns
7. Functions, classes, constructors, immutability, extensions, and generics
8. Futures, streams, exceptions, sealed classes, and typed results

### Track C — Flutter Fundamentals

9. Widget, Element, RenderObject, BuildContext, and rebuilds
10. Layout constraints, responsive UI, themes, forms, and accessibility
11. State lifecycle and choosing local versus application state

### Track D — Boilerplate Architecture

12. Repository map, feature-first rules, and layer boundaries
13. Riverpod state management and dependency injection
14. GoRouter navigation, redirects, and authentication guards
15. Dio, DTO mapping, repositories, failures, and secure storage

### Track E — Task Management Capstone

16. Model the Task domain and write the first tests
17. Implement an offline datasource and repository
18. Build task list state and filtering with Riverpod
19. Build create/edit forms and validation
20. Implement update, toggle, and delete flows
21. Add a real-API-ready Dio datasource and contract tests
22. Integrate the feature with navigation and the application shell

### Track F — Quality, Delivery, and Production

23. Unit, controller, widget, router, and integration testing
24. Debugging, DevTools, logging, performance, and common failures
25. Environments, secrets, accessibility, localization, and security
26. Build Android, iOS, and Web artifacts
27. Production readiness and the next-system checklist
28. AI-assisted development workflow

### References

- Command cookbook
- React/Next.js ↔ Flutter glossary
- Architecture decision matrix
- Troubleshooting catalog
- Final capstone checklist

## 5. Site Structure

```text
flutter-document/
├── index.html
├── README.md
├── assets/
│   ├── css/site.css
│   ├── js/site.js
│   └── images/*.svg
├── chapters/
│   ├── 01-orientation.html
│   ├── ...
│   └── 28-ai-workflow.html
├── reference/
│   ├── commands.html
│   ├── glossary.html
│   ├── architecture-decisions.html
│   └── troubleshooting.html
├── example/
│   └── task_management_app/
└── docs/
    ├── specs/
    └── plans/
```

Every page contains a functional content fallback when JavaScript is disabled.
JavaScript enhances search, navigation, theme selection, progress tracking,
copy buttons, and quiz feedback.

## 6. Visual Design

The visual direction is a technical field guide rather than a generic
documentation template.

- Warm paper-like content surface with a deep navy navigation rail.
- Emerald indicates successful flow and completed learning.
- Amber indicates web-to-Flutter translation notes.
- Coral indicates production or security warnings.
- Strong typographic hierarchy using offline system font stacks.
- Monospace treatment for code, paths, types, and commands.
- Dense reference tables remain readable on desktop and become stacked cards
  on narrow screens.
- Motion is optional and respects `prefers-reduced-motion`.
- Light and dark themes both meet practical contrast requirements.

Illustrations are semantic HTML/CSS diagrams embedded in their relevant pages:

1. React-to-Flutter concept map
2. Flutter widget/element/render tree
3. Feature-first architecture graph
4. Riverpod dependency and state flow
5. GoRouter authentication redirect flow
6. Task CRUD data flow
7. Typed error pipeline
8. Test pyramid
9. Multi-environment composition
10. Android/iOS/Web build pipeline

No decorative raster images, model-authored SVGs, or external fonts are
required. The diagrams directly explain a relationship or execution sequence,
remain selectable, reflow at narrow widths, and include adjacent text
descriptions.

## 7. Offline Behavior

The site must work from a `file://` URL:

- No fetch calls
- No JavaScript modules requiring HTTP
- No CDN resources
- No external fonts
- No remote analytics
- No service worker requirement

Search metadata is embedded in `assets/js/site.js`. Links between pages are
relative. Diagrams use the shared local stylesheet and no external assets.

Progress, theme, and completed exercises use `localStorage` when available and
degrade without blocking content if browser privacy settings disable storage.

## 8. Completed Example Project

The example is created from the current boilerplate source and adds a complete
`tasks` feature while retaining the authentication reference feature.

### Functional scope

- List tasks
- Filter all, open, and completed tasks
- Create a task with validation
- Edit title and description
- Toggle completion
- Delete with confirmation
- Show loading, empty, success, and failure states
- Navigate from Home to Tasks
- Run without a backend through an in-memory datasource

### Architecture

```text
TaskPage / TaskForm
        ↓
TaskListController
        ↓
Task use cases
        ↓
TaskRepository contract
        ↓
TaskRepositoryImpl
        ↓
InMemoryTaskDatasource
```

A separate remote datasource example demonstrates Dio, DTO decoding, endpoint
composition, and malformed-response mapping. The runnable default remains
offline and deterministic.

### Quality

- Domain entity tests
- Use-case tests
- Repository tests
- Controller state tests
- Widget tests for list, validation, create, toggle, and delete
- Router test for the Tasks route
- `dart format`, code generation, `flutter analyze`, and `flutter test`
- Android or Web build verification where the host environment permits

## 9. Error Handling

The guide uses the boilerplate's typed pipeline:

```text
External exception
    → AppException
    → Failure
    → Result<T>
    → Controller state
    → User-facing presentation
```

Exercises distinguish:

- Expected validation failures
- Network and timeout failures
- Unauthorized responses
- Invalid server schemas
- Programming errors that should not be hidden

The documentation site itself displays a readable fallback if JavaScript or
local storage is unavailable. No lesson content depends on script execution.

## 10. Validation

### Documentation validation

- Every relative link resolves.
- Every chapter appears in navigation and search.
- Every chapter follows the teaching sequence or intentionally marks a
  reference-only exception.
- No placeholder text, broken examples, or unexplained commands remain.
- HTML has valid document structure and language metadata.
- Pages are visually inspected at desktop and mobile widths.
- Keyboard navigation, focus visibility, reduced motion, and contrast are
  checked.
- The site opens and navigates from `file://`.

### Example validation

- Generated code is current.
- Formatting changes zero files.
- Static analysis reports no issues.
- All tests pass.
- The documented run and build commands match the repository.

## 11. Non-Goals

- Teaching general programming from zero
- Replacing the official Dart or Flutter API reference
- Providing a real production backend
- Shipping production authentication
- Covering desktop Flutter platforms in depth
- Requiring Node.js, a documentation generator, or an online hosting service

## 12. Delivery

The final project is copied to:

`/Users/pattanasak/Library/Mobile Documents/com~apple~CloudDocs/Project/flutter-document`

It includes source files, the completed example, design and implementation
documents, and a Git history authored as:

`PattanasakGit <pattanasak.at@gmail.com>`
