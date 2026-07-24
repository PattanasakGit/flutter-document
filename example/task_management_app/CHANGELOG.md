# Changelog

All notable changes to this starter are documented here.

## 1.0.0 - 2026-07-24

### Added

- Android, iOS, and Web Flutter project on Flutter 3.44.8 / Dart 3.12.2.
- Development, staging, and production entry points and typed app config.
- Feature-first, light-clean architecture with Riverpod composition.
- GoRouter authentication guard and unknown-route handling.
- Material 3 light/dark design system and responsive login/home reference UI.
- Typed Dio client, interceptors, errors, failures, results, logging, and secure
  storage abstraction.
- Complete authentication vertical slice with DTO/entity mapping, fake
  datasource, secure token write, login/logout state, and routing.
- Deterministic unit, repository, controller, widget, and router tests.
- Code generation, linting, portable scripts, pull-request CI, AI rules, and
  architecture/contribution documentation.

### Security

- Production diagnostics are disabled by environment configuration.
- Android application backup is disabled to avoid restoring encrypted values
  without their original platform key material.
- Placeholder API URLs use the reserved `.invalid` domain; no secrets are
  committed.
- Android release tasks fail closed until an external signing keystore is
  configured; debug signing is never reused for release.
