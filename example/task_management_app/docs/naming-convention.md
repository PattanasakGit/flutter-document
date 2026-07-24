# Naming convention

Names communicate ownership and architectural role. Avoid words that require a
reader to open the file before understanding its purpose.

| Concern | File example | Type/member example |
| --- | --- | --- |
| File/directory | `login_page.dart` | — |
| Class | — | `LoginPage` |
| Provider | owner file or `network_provider.dart` | `dioProvider` |
| Controller | `login_controller.dart` | `LoginController` |
| State | `login_state.dart` | `LoginState`, `LoginStatus` |
| Use case | `login_use_case.dart` | `LoginUseCase` |
| Repository contract | `authentication_repository.dart` | `AuthenticationRepository` |
| Repository implementation | `authentication_repository_impl.dart` | `AuthenticationRepositoryImpl` |
| Datasource | `authentication_remote_datasource.dart` | `AuthenticationRemoteDatasource` |
| DTO | `login_response_dto.dart` | `LoginResponseDto` |
| Entity | `authenticated_user.dart` | `AuthenticatedUser` |
| Mapper | `authentication_mapper.dart` | `LoginResponseMapper` or a precise extension |
| Route | `app_routes.dart`, `route_paths.dart` | `AppRoutes.login`, `RoutePaths.login` |
| Test | `login_controller_test.dart` | behavior-oriented test description |

## General rules

- Files/directories use `snake_case`.
- Types and enum values' owner types use `PascalCase`.
- Variables, methods, fields, enum values, and providers use `camelCase`.
- Private members start with `_`.
- Boolean names describe a true condition: `isLoading`, `enableLogging`,
  `hasSession`.
- Collections use meaningful plurals.
- Acronyms follow Dart casing: `ApiClient`, `LoginResponseDto`, not
  `APIClient`/`LoginResponseDTO`.

## Suffix rules

Use `Page`, `Widget`, `Controller`, `State`, `UseCase`, `Service`,
`Repository`, `RepositoryImpl`, `Datasource`, `Dto`, `Mapper`, `Entity`,
`Provider`, `Failure`, and `Exception` only when the type has that
responsibility.

Do not name a class `Service` merely because its role is unclear. Name the
operation or boundary, such as `LoginUseCase` or `SecureStorage`.

## Providers

Name a provider after the value it exposes:

```dart
final apiClientProvider = Provider<ApiClient>(...);
final authenticationRepositoryProvider =
    Provider<AuthenticationRepository>(...);
```

Generated Notifier providers keep the generator's predictable name. Do not add
`riverpod` or `global` to provider names.

## Tests

Test filenames mirror production files. Group by unit/behavior and phrase tests
as outcomes:

```text
maps a 401 response to UnauthorizedFailure
disables the action while logging in
redirects a signed-out user to login
```

Avoid vague names such as `works`, `test 1`, or `handles correctly`.

## Names to avoid

Do not introduce unscoped `helper.dart`, `common.dart`, `manager.dart`,
`service.dart`, `utils.dart`, `data.dart`, or `model.dart`. If a utility is
justified, name its operation and owner precisely.
