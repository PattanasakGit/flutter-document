# Feature guideline

## Start with the behavior

Before creating directories, write down:

1. the user-visible outcome;
2. the state transitions;
3. business rules independent of UI;
4. external boundaries such as API or storage;
5. failure states and user-safe messages.

Search for the nearest existing feature. Use Home for a local UI flow and
Authentication for an API/storage flow.

## Layer decision

| Question | Add |
| --- | --- |
| Does the feature render UI? | `presentation` |
| Does state coordinate events or async work? | presentation controller/state |
| Is there an application operation worth naming/test-driving? | `application/use_cases` |
| Are there business entities/rules independent of Flutter? | `domain` |
| Must code cross an API, storage, database, or SDK boundary? | `data` and a domain contract |

Do not add a layer for anticipated future work.

## Add a page

1. Create `<action>_page.dart` under `presentation/pages`.
2. Keep layout, accessibility, and event wiring in the page.
3. Extract feature widgets when the page becomes hard to scan.
4. Render state with `ref.watch`; trigger actions with `ref.read`.
5. Add a route name and path centrally if it is navigable.
6. Add a widget test for important states and actions.

Pages must not parse JSON, call a datasource, or construct Dio.

## Add a controller

1. Define its observable state and transitions first.
2. Use a generated Riverpod Notifier or AsyncNotifier.
3. Inject a use case or repository through a nearby provider.
4. Translate domain results into explicit loading/data/error presentation
   state.
5. Keep navigation redirects in the router; controllers own state, not route
   tables.
6. Test loading, success, failure, and retry/reset behavior.

## Add an API operation

1. Define the domain outcome and repository method.
2. Define request/response DTOs in `data/dtos`.
3. Use Freezed/json_serializable for immutable payloads.
4. Add an explicit DTO → entity mapper.
5. Add the endpoint constant in the narrowest appropriate endpoint owner.
6. Implement HTTP and decoding in the datasource via `ApiClient`.
7. Map exceptions and return `Result<T>` in the repository implementation.
8. Wire cross-layer dependencies with Riverpod in
   `<feature_name>_providers.dart` at the feature root.

Never return Dio `Response`, a JSON map, or a DTO to presentation.

## Add a repository

Create a repository contract only when it separates business-facing operations
from external implementation. Contracts live in domain; implementations live in
data. Repositories:

- call one or more datasources;
- coordinate cache/storage when required;
- map DTOs to entities;
- map exceptions to failures;
- return typed results.

Do not create repository interfaces for classes that have no boundary to
protect.

## Add DTOs and mappers

- A DTO mirrors an external schema, including external key names.
- An entity models what the app needs and remains transport-independent.
- A mapper is explicit and testable; do not hide mapping in UI constructors.
- Use `Object?` at untyped external boundaries, validate shape, then enter the
  typed application.

After annotation changes, run `dart run build_runner build`.

## Add tests

Mirror the responsibility:

- domain/application rule → unit test;
- repository composition/mapping → repository test with fakes;
- controller transition → ProviderContainer test;
- page interaction/state → widget test;
- redirect/unknown route → router test.

Keep tests offline and deterministic. Reuse helpers from `test/helpers` only
when the helper is truly shared.

## Before merge

- [ ] The feature has only justified layers.
- [ ] Dependency direction matches `docs/architecture.md`.
- [ ] No DTO, Dio, raw JSON, or datasource reaches presentation.
- [ ] Providers live near the owner.
- [ ] User input and failure states are covered.
- [ ] Generated files are current and reviewed.
- [ ] Public names and routes follow project conventions.
- [ ] Documentation changed if a pattern or boundary changed.
- [ ] `dart format .` passes.
- [ ] `dart run build_runner build` produces no unexpected diff.
- [ ] `flutter analyze` has no findings.
- [ ] `flutter test` passes.
