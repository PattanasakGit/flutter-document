# AGENTS.md

This file is the operating contract for every human or AI contributor. Read it
before editing and prefer the nearest existing feature over inventing a new
pattern.

## Project Goal

Maintain a lean, production-minded Flutter starter that new teams and coding
agents can understand quickly. The repository favors explicit typed flows,
feature ownership, one implementation pattern per concern, and optional modules
only when a real product requirement exists.

## Architecture

Use feature-first organization with light clean architecture:

```text
presentation → application → domain
data ──────────────────────→ domain
```

Layers are responsibilities, not a required directory template. Small UI-only
features may contain presentation only. Full layers are justified when business
rules or external I/O exist.

## Folder Rules

- Put business-specific code in `lib/features/<feature_name>/`.
- Put application composition, environment, router, and theme in `lib/app/`.
- Put business-neutral infrastructure in `lib/core/`.
- Put proven cross-feature UI and validation in `lib/shared/`.
- Keep tests near the same responsibility under `test/`.
- Keep providers next to the feature or infrastructure they construct.
- Do not create empty layers, catch-all folders, or speculative base classes.
- Do not move files across architecture boundaries without documenting the reason.

## Dependency Direction

- Presentation may import its application and domain layers.
- Application may import domain.
- Data may import domain and core.
- A feature-root `<feature>_providers.dart` may compose application, domain,
  data, and core providers; it must not contain business logic.
- Domain must not import Flutter UI, Dio, data, application, or presentation.
- Core and shared must not import features.
- Presentation must not import Dio, datasources, DTOs, or raw JSON.
- Follow the nearest existing feature as the reference.

## State Management Rules

- Use Riverpod for state management and dependency injection.
- Use Notifier or AsyncNotifier when state has business behavior.
- Use `ref.watch` for rendering, `ref.read` for actions, and `ref.listen` for
  side effects.
- Keep global providers limited to app/core composition. Cross-layer feature
  wiring belongs in the feature-root provider composition file.
- Do not add manual singletons or global mutable state.
- Do not introduce a second state-management or DI library.

## Routing Rules

- Use GoRouter and route constants from `lib/app/router/`.
- Keep authentication redirects in a dedicated router guard.
- Use route names or `RoutePaths`; do not scatter path strings.
- Do not use `Navigator.push` unless a documented local-overlay use case cannot
  be represented by GoRouter.
- Preserve unknown-route handling and browser/deep-link-safe paths.

## Network Rules

- Use the central Dio instance and `ApiClient`.
- Base URL and diagnostic logging come from `AppConfig`.
- Datasources own HTTP, external payloads, DTO serialization, and transport
  exceptions.
- Repositories map DTOs to entities and exceptions to typed failures/results.
- Do not call APIs from widgets.
- Do not bypass repository abstractions.
- Do not expose DTOs outside the data layer.
- Do not expose DioException outside the data layer.
- Do not log tokens, passwords, full request bodies, or secrets.

## Error Handling Rules

- External failures become `AppException` at the boundary.
- Repositories map exceptions through `ErrorMapper` and return `Result<T>`.
- UI consumes presentation state and user-safe mapped messages.
- Do not return `null` as a failure signal or silently swallow exceptions.
- Keep diagnostic errors separate from user-facing copy.
- Do not use dynamic unless required by an external API boundary.

## Testing Rules

- Write a failing behavior test before feature or bug-fix implementation.
- Keep tests deterministic and offline.
- Prefer small fakes for stateful behavior; use mocktail at interaction
  boundaries where a fake would obscure intent.
- Cover validation, loading, success, failure, mapping, and route redirects.
- Override providers at the composition boundary.
- Every test must assert meaningful externally visible behavior.

## Naming Rules

- Files and directories: `snake_case`.
- Types: `PascalCase`.
- Members and providers: `camelCase`.
- Use precise suffixes such as `Page`, `Controller`, `State`, `UseCase`,
  `Repository`, `RepositoryImpl`, `Datasource`, `Dto`, `Mapper`, `Entity`,
  `Provider`, `Failure`, and `Exception`.
- Avoid generic names such as `helper.dart`, `common.dart`, `manager.dart`,
  `service.dart`, `data.dart`, or `model.dart`.

## Forbidden Patterns

- Do not introduce new libraries without a clear requirement.
- Do not create a second pattern for an existing concern.
- Keep changes scoped to the requested feature.
- Do not use direct API, DTO, raw JSON, or Dio response objects in widgets.
- Do not centralize all feature models, providers, services, or widgets.
- Do not use multiple state managers, network clients, or manual singletons.
- Do not store API keys, tokens, or credentials in source control.
- Do not create generic abstractions without at least one real use case.
- Do not suppress analyzer warnings without justification.
- Do not leave TODO placeholders in completed code.

## Definition of Done

A change is done only when its behavior is implemented with real code, generated
files are current, imports resolve, architecture boundaries remain intact,
documentation reflects material decisions, and format/analyze/tests all pass.
Entry-point or platform changes must also compile for the affected target.

## Required Commands

Run from the repository root before completion:

```bash
dart format .
dart run build_runner build
flutter analyze
flutter test
```

Current build_runner versions removed the need for
`--delete-conflicting-outputs`. Do not reintroduce obsolete flags. Report the
actual command output; never claim a check passed without running it.
