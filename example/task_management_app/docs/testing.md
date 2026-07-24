# Testing

## Test strategy

Tests mirror responsibilities, stay deterministic, and avoid the real network.
Prefer behavior confidence over implementation coupling.

## Unit tests

Use unit tests for validators, Result behavior, mappers, and use cases. Exercise
inputs and typed outputs without Flutter bindings when possible.

## Controller tests

Create a ProviderContainer with repository/provider overrides. Observe
transitions through the generated Notifier provider and assert:

- loading appears before completion;
- success carries the domain entity;
- failure carries safe presentation copy;
- logout/reset behavior is explicit.

Do not call private controller methods or mock Riverpod internals.

## Repository tests

Use a controllable datasource and in-memory storage/logger. Verify:

- request DTO construction;
- DTO → entity mapping;
- secure token write/delete;
- exception → Failure mapping;
- no exception leaks to the caller.

Repository tests must not instantiate the real Dio transport or platform secure
storage.

## Widget tests

Pump the real App with an UncontrolledProviderScope and deterministic provider
overrides. Interact through visible labels/keys and assert user-visible
behavior—validation, loading indicator, error copy, navigation, and content.

Use keys only for stable interaction points; prefer semantics/text when they are
part of the UI contract.

## Router tests

Test the pure guard separately for redirect decisions. App-level router tests
then prove Riverpod session changes refresh GoRouter, signed-out users reach
login, signed-in users reach home, and unknown routes render a recovery action.

## Test helpers

- `pump_app.dart`: composition-aware app pump.
- `test_data.dart`: canonical immutable examples.
- `test_doubles.dart`: deterministic shared fakes.
- `provider_overrides.dart`: test ProviderContainer factory.

Do not turn helpers into a test framework. Keep a double local to one test file
until multiple suites need the same behavior.

## Provider overrides

Override contracts at composition boundaries:

```dart
final container = ProviderContainer(
  overrides: [
    authenticationRepositoryProvider.overrideWithValue(fakeRepository),
  ],
);
```

Dispose containers with test teardown. Avoid overriding the controller under
test; inject its dependency so real state logic runs.

## Mock versus fake

Use a fake when behavior/state is small and clearer in code: in-memory storage,
fixed datasource response, controllable repository. Use mocktail when the
important assertion is an interaction with a complex contract and a fake would
reimplement that contract.

Never mock every layer in one test. At least one real behavior path should be
under observation.

## Commands

```bash
flutter test
flutter test test/features/authentication/login_page_test.dart
flutter test --coverage
```

Coverage is diagnostic, not a target that justifies low-value assertions.

## New feature checklist

- validation/business rule unit tests;
- mapping and malformed input tests;
- repository success/failure/storage tests;
- controller loading/success/failure tests;
- meaningful widget interactions;
- route redirect/error behavior when routes change;
- no network, time, random, or production credential dependency.
