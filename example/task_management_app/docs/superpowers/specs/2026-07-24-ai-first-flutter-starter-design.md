# AI-First Flutter Starter Design

## Status

Approved for implementation by the explicit execution instruction in the source
brief. The brief also instructs the implementer to continue without an additional
confirmation gate.

## Context

The repository initially contains only a README and has no Flutter project,
platform folders, package manifest, lint configuration, or application code.
Flutter 3.44.8 and Dart 3.12.2 are installed. The starter must support Android,
iOS, and Web while avoiding desktop platforms and optional product modules.

## Considered Approaches

### Full layers for every feature

Create presentation, application, domain, and data folders for authentication
and home regardless of behavior.

This is predictable, but it creates empty layers and teaches future contributors
to add architecture for appearance rather than responsibility.

### Lean layers by responsibility — selected

Create the full vertical slice only for authentication, because it has business
rules, external-data simulation, repository boundaries, DTO mapping, and secure
storage. Keep home presentation-only because it has no external data.

This gives one complete reference without making the core or feature template
artificially heavy.

### Minimal demonstration

Build only pages, providers, and a fake login response.

This is small, but it does not demonstrate the required network, storage, error,
repository, DTO, mapper, routing, and testing boundaries.

## Architecture

The application uses feature-first organization with a light clean dependency
direction:

```text
presentation -> application -> domain
data -----------------------> domain
data -> core
app -> features, shared, core
core/shared -X-> features
```

Authentication is the reference full slice. Its presentation calls a generated
Riverpod controller, the controller calls `LoginUseCase`, the use case calls the
domain repository, and the repository implementation coordinates a remote data
source, mapping, error conversion, and token storage. No Dio type, DTO, or raw
JSON crosses into presentation.

Home is intentionally presentation-only. It observes authentication state and
environment configuration, demonstrates theme tokens and shared widgets, and
triggers logout through the authentication controller.

## Runtime Composition

Each entry point creates an immutable `AppConfig` for development, staging, or
production and passes it to a shared bootstrap function. Bootstrap initializes
Flutter, creates the root `ProviderScope` overrides, runs application
initialization, and starts `App`.

Riverpod is the only state-management and dependency-injection mechanism.
Providers stay near their owning concern. Environment, Dio, storage, and router
providers are global because multiple features consume them.

GoRouter owns named routes and centralized paths. Its redirect reads a small
authentication session provider and sends unauthenticated users to login and
authenticated users away from login to home. A refresh notifier bridges
Riverpod state changes into GoRouter without putting navigation side effects in
widgets.

## Authentication Reference Flow

The bundled remote data source is deterministic and does not call a live
backend. It accepts one documented demo credential pair, delays briefly to make
loading observable, and returns a JSON-shaped response that is deserialized by
generated DTO code. Invalid credentials produce an external unauthorized
exception.

Production projects replace the data source provider with a real Dio-backed
implementation while preserving the repository contract. `ApiClient` remains a
real, tested Dio wrapper to demonstrate the approved network boundary without
making the sample login depend on an external service.

On successful login, the repository stores the token through `SecureStorage`.
Logout deletes it. Authentication session state contains the domain user only;
the token never reaches UI state.

## Errors

Core defines infrastructure `AppException` variants, domain-facing `Failure`
variants, a typed `Result<T>`, and an `ErrorMapper`. Data sources may throw
`AppException`; repository implementations catch known infrastructure errors,
log diagnostic context, and return `FailureResult`. Unknown errors are logged
and become `UnknownFailure`; errors are never silently swallowed.

Controllers map failures to immutable UI state with a user-safe message.
Diagnostic messages stay in logs and are not rendered directly.

## Design System

Material 3 `ThemeData` and `ColorScheme` are the base. Color, typography,
spacing, and radius tokens are centralized. The login and home screens use a
focused, neutral visual language suitable for a starter: strong hierarchy,
responsive centered content, accessible form labels, clear loading/error
feedback, and no product-specific branding.

Light theme is complete. The token structure and `darkTheme` entry are prepared
without adding a second unvalidated visual system.

## Testing

Tests are deterministic and never use a network or platform secure-storage
channel. Fakes and targeted mocktail mocks replace boundary dependencies.

Coverage includes:

- DTO serialization and DTO-to-entity mapping
- login use-case validation and delegation
- repository success, secure-token write, and exception mapping
- controller initial/loading/success/failure behavior
- login form validation and successful interaction
- router redirects for signed-out and signed-in sessions
- core error mapping and API client behavior where valuable

Test helpers own app pumping, test data, doubles, and provider overrides.

## Repository and Developer Experience

The implementation creates only Android, iOS, and Web platform folders. Assets
folders are retained with `.gitkeep` files so Git preserves the intended topology.
Scripts wrap format, code generation, analysis, and tests. Pull-request CI runs
dependency resolution, generated-code verification, formatting checks,
analysis, and tests.

`AGENTS.md`, the README, and focused documents define one architecture,
dependency direction, naming scheme, test strategy, and completion checklist.
Optional modules are documented but not installed.

## Package Policy

Only the dependencies listed in the brief are direct dependencies. Stable
stable versions compatible with Flutter 3.44.8 and Dart 3.12.2 are selected and
then validated by Pub's solver. Riverpod lint 3.1.4 uses Dart's
`analysis_server_plugin` integration, so the obsolete `custom_lint` bridge is
not installed. Generated package source and official documentation are the
authority for current APIs.

## Out of Scope

Firebase, Supabase, local databases, monitoring, analytics, push notifications,
localization implementation, deep-link product behavior, release automation,
Melos, Patrol, and golden tests are excluded from V1.

## Definition of Done

The implementation is complete only after dependency resolution and code
generation succeed, all three entry points compile, formatting is clean,
`flutter analyze` reports no errors, `flutter test` passes, generated files are
present, documentation is complete, and no unfinished work marker remains.
