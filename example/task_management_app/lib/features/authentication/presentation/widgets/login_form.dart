import 'package:ai_first_flutter_starter/app/theme/app_spacing.dart';
import 'package:ai_first_flutter_starter/features/authentication/presentation/controllers/login_controller.dart';
import 'package:ai_first_flutter_starter/features/authentication/presentation/states/login_state.dart';
import 'package:ai_first_flutter_starter/shared/validators/credential_validators.dart';
import 'package:ai_first_flutter_starter/shared/widgets/app_button.dart';
import 'package:ai_first_flutter_starter/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

final class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    await ref
        .read(loginControllerProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final isLoading = state.status == LoginStatus.loading;

    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              fieldKey: const Key('email-field'),
              controller: _emailController,
              label: 'Email address',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
              validator: (value) => CredentialValidators.email(value ?? ''),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              fieldKey: const Key('password-field'),
              controller: _passwordController,
              label: 'Password',
              obscureText: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              validator: (value) => CredentialValidators.password(value ?? ''),
              onSubmitted: isLoading ? null : (_) => _submit(),
            ),
            if (state.errorMessage case final errorMessage?) ...[
              const SizedBox(height: AppSpacing.md),
              Semantics(
                liveRegion: true,
                child: Text(
                  errorMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Sign in',
              isLoading: isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
