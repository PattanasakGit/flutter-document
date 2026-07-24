# AI-First Flutter Boilerplate

A modern, feature-first Flutter foundation designed for human developers and
AI coding agents. It provides explicit architectural boundaries, typed failure
handling, deterministic tests, environment-aware composition, and one complete
reference feature without turning small changes into framework work.

> [!IMPORTANT]
> This repository is a production-minded reference starter, not a deploy-ready
> product. The included authentication flow intentionally uses a deterministic
> fake datasource in every environment. Replace it and complete the
> [production checklist](#production-checklist) before shipping a real app.

## Why use this starter?

- **Current Flutter foundation:** Flutter 3.44.8, Dart 3.12.2, Material 3,
  Riverpod 3, GoRouter, Dio, Freezed, and `flutter_secure_storage`.
- **Feature-first structure:** code stays close to the product capability it
  implements instead of being distributed across global technical folders.
- **Light clean architecture:** add application, domain, and data layers only
  when a feature has business rules or external I/O.
- **Typed boundaries:** transport errors, application failures, results, DTOs,
  and domain entities have distinct responsibilities.
- **AI-ready conventions:** [`AGENTS.md`](AGENTS.md) and the documentation define
  where code belongs, what each layer may import, and what verification is
  required.
- **Reproducible quality checks:** generated code is committed, tests are
  deterministic, and pull requests run generation, formatting, analysis, and
  tests.

This is a clone-and-own boilerplate. It is intentionally not a runtime
framework or a package that application code must depend on forever.

## Included reference implementation

| Area | Included |
| --- | --- |
| Application shell | Material 3 themes, responsive layouts, and environment labels |
| Navigation | Centralized GoRouter configuration with an authentication guard |
| State and DI | Annotation-based Riverpod providers and controllers |
| Networking | Configured Dio client, interceptors, endpoints, and error mapping |
| Persistence | Secure token-storage abstraction |
| Error flow | `AppException` → `Failure` → `Result<T>` |
| Authentication | DTO, entity, repository, use case, controller, login UI, and tests |
| Home | A deliberately presentation-only feature showing the minimum viable structure |
| Quality | Formatting, generation, analysis, unit/widget/router tests, and PR CI |

The authentication feature is an executable architecture example. It uses:

```text
demo@example.com
password123
```

These credentials and the returned token are fake and must never be treated as
a real authentication mechanism.

## Quick start

### Prerequisites

- Flutter 3.44.8 stable, also recorded in [`.fvmrc`](.fvmrc)
- Dart 3.12.2 or the Dart SDK bundled with that Flutter release
- Android Studio/Android SDK, Xcode/CocoaPods, or a supported Web browser for
  the platform being developed

### Run the app

```bash
flutter pub get
dart run build_runner build
flutter run -t lib/main_development.dart
```

Run the complete local quality suite before opening a pull request:

```bash
./scripts/format.sh
./scripts/generate.sh
./scripts/analyze.sh
./scripts/test.sh
```

## Environments

| Environment | Entry point | App logging | Debug banner |
| --- | --- | --- | --- |
| Development | `lib/main_development.dart` | On | On |
| Staging | `lib/main_staging.dart` | Off | Off |
| Production | `lib/main_production.dart` | Off | Off |

```bash
flutter run -t lib/main_development.dart
flutter run -t lib/main_staging.dart
flutter run -t lib/main_production.dart
```

The entrypoints select Dart-level configuration and composition. They are not
native Android product flavors or iOS schemes, and they currently compose the
same fake authentication datasource.

The committed API URLs use the reserved `.invalid` domain so the starter cannot
contact an unintended service. When a real datasource is implemented, supply a
non-secret base URL at build time:

```bash
flutter run -t lib/main_staging.dart \
  --dart-define=API_BASE_URL=https://api.staging.example.com
```

Never store API secrets, signing credentials, access tokens, or passwords in
source-controlled Dart values or `--dart-define` examples.

## Architecture

Business code lives under `lib/features/<feature>/`. A feature begins with only
the folders it needs:

```text
presentation → application → domain
data ──────────────────────→ domain
```

- **Presentation** owns pages, widgets, controllers, and user interaction.
- **Application** coordinates use cases and application workflows.
- **Domain** owns pure-Dart entities, repository contracts, and business rules.
- **Data** implements external boundaries such as HTTP APIs and persistence.
- **Core** contains business-neutral infrastructure shared by the application.
- **Shared** contains proven cross-feature UI or utilities, not speculative
  abstractions.

Core rules:

1. Keep new code in the nearest feature until another feature genuinely needs
   it.
2. Keep Flutter, Dio, storage plugins, and DTOs outside the domain layer.
3. Do not expose `DioException` or raw transport responses outside data
   boundaries.
4. Convert expected external errors into typed application failures.
5. Use Riverpod for application state and dependency composition.
6. Access another feature through its intentional public API.
7. Test behavior at the lowest useful level and add widget/router coverage for
   user-visible flows.

See [`docs/architecture.md`](docs/architecture.md) for the full import matrix and
request flow.

## Project structure

```text
.
├── AGENTS.md
├── lib/
│   ├── app/                    # Bootstrap, environments, router, and theme
│   ├── core/                   # Network, errors, storage, logging, and results
│   ├── features/
│   │   ├── authentication/     # Complete reference vertical slice
│   │   └── home/               # Intentionally presentation-only
│   ├── shared/                 # Proven cross-feature code
│   └── main_*.dart             # Development, staging, and production
├── test/                       # Mirrors production responsibilities
├── integration_test/           # Reserved for device-level critical flows
├── docs/                       # Architecture and contribution guidance
└── scripts/                    # Portable quality commands
```

Empty architecture folders are not kept for symmetry. Add a layer only when it
has a concrete responsibility.

## Implementing a feature

1. Create `lib/features/<feature_name>/presentation`.
2. Add the smallest page/widget/controller needed for the user flow.
3. Add `domain` when the feature has entities, business rules, or repository
   contracts.
4. Add `application` when orchestration belongs outside the controller.
5. Add `data` when the feature crosses an API, database, plugin, or storage
   boundary.
6. Keep providers near the feature and expose only its intentional public API.
7. Mirror important behavior under `test/features/<feature_name>/`.
8. Regenerate code and run the complete quality suite.

Use [`docs/feature-guideline.md`](docs/feature-guideline.md) for the decision tree
and merge checklist.

## Code generation

Riverpod, Freezed, and JSON generated files are committed so a fresh clone can
analyze without first mutating the working tree.

After changing annotated declarations:

```bash
./scripts/generate.sh
git diff --check
git diff
```

Review generated changes before committing them. Do not edit generated files
manually.

## Testing and continuous integration

Tests avoid real network access and cover:

- Result and error mapping
- Network and storage infrastructure
- Authentication repository and use case
- Riverpod controller state transitions
- Login widgets and validation
- Router authentication behavior

The pull-request workflow in
[`.github/workflows/pull_request.yaml`](.github/workflows/pull_request.yaml)
verifies generated output, formatting, analysis, and tests.

Device integration tests, platform builds, coverage enforcement, localization,
and accessibility guideline tests are deliberate next steps rather than
claimed capabilities.

## Working with AI coding agents

Before changing code, every agent should:

1. Read [`AGENTS.md`](AGENTS.md).
2. Read the nearest feature and its tests.
3. State which existing pattern the change follows.
4. Keep the edit scoped to the requested capability.
5. Report actual generation, formatting, analysis, and test results.

A useful task prompt is:

```text
Implement <capability> in <feature>.
Follow AGENTS.md and the nearest existing feature pattern.
Preserve layer boundaries, add behavior-focused tests, and report the exact
verification commands and results.
```

Explicit architecture and verification rules help Codex, Claude, Cursor,
ChatGPT, and other coding agents converge on the same repository conventions.

## Supported targets

The repository currently enables:

- Android
- iOS
- Web

Desktop targets are intentionally not generated. Add a platform only when the
product requires it and verify every plugin at that platform boundary.

## Production checklist

Complete these items before releasing a real product:

- [ ] Replace `FakeAuthenticationRemoteDatasource` in staging and production
      with environment-specific implementations that fail closed.
- [ ] Implement the real Dio-backed authentication flow and map malformed
      response/schema errors into typed failures.
- [ ] Add authentication initialization, session restoration, expiration,
      refresh/401 handling, and intended-route restoration.
- [ ] Configure and test secure storage for every target platform, including
      iOS Keychain entitlements and secure Web hosting requirements.
- [ ] Add Android product flavors and iOS schemes when environments need
      distinct identifiers, names, icons, services, or signing.
- [ ] Add localization resources and locale/RTL tests for every supported
      language.
- [ ] Add device-level integration smoke tests for critical flows.
- [ ] Extend CI with target builds, coverage policy, dependency maintenance,
      and security checks appropriate to the product.
- [ ] Replace starter application identifiers, names, icons, URLs, and signing
      configuration.
- [ ] Choose and configure privacy-safe crash reporting and observability.

## Android release signing

Debug builds work without signing configuration. Android release tasks fail
closed until `android/key.properties` exists with credentials stored outside
source control:

```properties
storeFile=/absolute/path/to/release-keystore.jks
storePassword=<secret>
keyAlias=<release-alias>
keyPassword=<secret>
```

The starter identity is `dev.aifirst.flutterstarter` on Android and iOS. Replace
it with the owning organization's reverse-domain identifier before publishing.
Keep keystores and `key.properties` out of Git.

## Documentation

| Document | Purpose |
| --- | --- |
| [`AGENTS.md`](AGENTS.md) | Mandatory repository rules for humans and AI agents |
| [`docs/architecture.md`](docs/architecture.md) | Layer responsibilities, imports, and request flow |
| [`docs/feature-guideline.md`](docs/feature-guideline.md) | Feature creation and merge checklist |
| [`docs/coding-standard.md`](docs/coding-standard.md) | Dart and Flutter implementation standards |
| [`docs/naming-convention.md`](docs/naming-convention.md) | Naming rules by responsibility |
| [`docs/error-handling.md`](docs/error-handling.md) | Exception, failure, and result flow |
| [`docs/testing.md`](docs/testing.md) | Test strategy and commands |
| [`docs/adding-a-module.md`](docs/adding-a-module.md) | Process for adding optional infrastructure |

## Optional modules

Firebase, databases, analytics, notifications, localization, crash reporting,
and advanced integration or golden testing are intentionally not core
dependencies. Add a module only after a product requirement exists, then follow
[`docs/adding-a-module.md`](docs/adding-a-module.md).
