# Coding standard

## Dart style

Use the Dart formatter and the repository analyzer configuration. Prefer clear
typed code over compressed expressions. Organize imports by Dart, package, then
relative test helper sections as enforced by analysis.

## Null safety

- Model absence only when absence is a valid state.
- Do not use `null` as an error signal; use `Result<T>` or explicit UI state.
- Avoid force unwraps. Prove a value before use or model the invariant in a
  non-null type.
- Validate `Object?` values at external boundaries immediately.

## Immutability

Use final fields and immutable state. Freezed is appropriate for states, DTOs,
and entities with value semantics or copy operations. Do not use it for a class
that gains no value from generation.

Never mutate global state. Riverpod owns lifecycle and dependency scope.

## Functions and classes

- Give each unit one clear responsibility.
- Extract a use case when an operation has business meaning, branching rules, or
  orchestration worth testing.
- Prefer early returns over deep nesting.
- Split a function when naming a section improves the reader's model; do not
  split into tiny wrappers that hide a simple flow.
- Constructors should make required dependencies explicit.

## Widgets

- Keep business rules out of `build`.
- Use `LayoutBuilder`, constraints, and scrolling for responsive behavior.
- Use semantic labels/tooltips and maintain at least 48×48 logical-pixel touch
  targets.
- Put feature-specific widgets in their feature.
- Move a widget to shared only after a second feature needs the same semantics,
  not merely similar visuals.
- Use ThemeData, ColorScheme, typography, spacing, and radius tokens. Do not
  hard-code feature colors.

## Error handling

Catch errors at a boundary that can add meaning or convert the type. Never use
an empty catch. External exceptions become AppException; repositories turn
those into Failure/Result; UI renders a user-safe state. Preserve the original
error and stack trace in diagnostic logging without exposing it to users.

## Async code

- Await futures unless the operation is deliberately detached.
- Use `unawaited` only with a comment or surrounding design that explains error
  ownership.
- Disable duplicate actions while a request is running.
- Avoid arbitrary delays in production logic. The fake datasource delay exists
  only to make the reference loading state observable.
- Dispose controllers and resources through widget/Riverpod lifecycle hooks.

## Comments

Prefer names and small cohesive functions. Comments should explain constraints,
security choices, external quirks, or why a non-obvious design exists. Do not
narrate syntax or keep commented-out code.

Generated files are not manually edited.

## Logging

Use `AppLogger`; do not call `print`. Log operation context and captured stack
traces. Never log passwords, tokens, authorization headers, secrets, or complete
personal payloads. Production logging remains disabled unless an approved
observability module defines redaction and retention.

## Avoiding duplication

First tolerate small local similarity. Extract only when two real consumers
share the same responsibility and semantics. Never create a generic service,
base repository, or shared model merely to remove a few repeated lines.

One concern has one project pattern: Riverpod for state/DI, GoRouter for
routing, Dio for HTTP, and Result/Failure for expected operation failure.
