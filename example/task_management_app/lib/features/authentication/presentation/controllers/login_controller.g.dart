// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginController)
final loginControllerProvider = LoginControllerProvider._();

final class LoginControllerProvider
    extends $NotifierProvider<LoginController, LoginState> {
  LoginControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginState>(value),
    );
  }
}

String _$loginControllerHash() => r'b50be6ca3a25706110a031e14bf16327f3a275b3';

abstract class _$LoginController extends $Notifier<LoginState> {
  LoginState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LoginState, LoginState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LoginState, LoginState>,
              LoginState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(authenticationSession)
final authenticationSessionProvider = AuthenticationSessionProvider._();

final class AuthenticationSessionProvider
    extends
        $FunctionalProvider<
          AuthenticatedUser?,
          AuthenticatedUser?,
          AuthenticatedUser?
        >
    with $Provider<AuthenticatedUser?> {
  AuthenticationSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticationSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticationSessionHash();

  @$internal
  @override
  $ProviderElement<AuthenticatedUser?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthenticatedUser? create(Ref ref) {
    return authenticationSession(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthenticatedUser? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthenticatedUser?>(value),
    );
  }
}

String _$authenticationSessionHash() =>
    r'5528d6d8560adff76452c3cbd15da0c5b73e3bfe';
