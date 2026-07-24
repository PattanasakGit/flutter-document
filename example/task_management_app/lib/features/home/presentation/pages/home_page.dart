import 'package:ai_first_flutter_starter/app/config/environment_provider.dart';
import 'package:ai_first_flutter_starter/app/theme/app_spacing.dart';
import 'package:ai_first_flutter_starter/features/authentication/authentication.dart';
import 'package:ai_first_flutter_starter/features/home/presentation/widgets/environment_badge.dart';
import 'package:ai_first_flutter_starter/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final authenticationState = ref.watch(loginControllerProvider);
    final user = authenticationState.user;
    final isLoading = authenticationState.status == LoginStatus.loading;

    return Scaffold(
      key: const Key('home-page'),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 840;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.code_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              config.appName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          EnvironmentBadge(label: config.environmentLabel),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Text(
                        'Runtime ready.',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        user == null
                            ? 'Authenticated session unavailable.'
                            : user.displayName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: _RuntimeCard()),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(child: _SessionCard(email: user?.email)),
                          ],
                        )
                      else ...[
                        const _RuntimeCard(),
                        const SizedBox(height: AppSpacing.lg),
                        _SessionCard(email: user?.email),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      if (authenticationState.errorMessage
                          case final errorMessage?) ...[
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            errorMessage,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppButton(
                          label: 'Sign out',
                          expand: false,
                          isLoading: isLoading,
                          onPressed: () async {
                            await ref
                                .read(loginControllerProvider.notifier)
                                .logout();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final class _RuntimeCard extends StatelessWidget {
  const _RuntimeCard();

  @override
  Widget build(BuildContext context) {
    return const _StatusCard(
      eyebrow: 'COMPOSITION',
      title: 'Infrastructure online',
      message:
          'Router, typed results, secure storage, Dio, and Riverpod are wired.',
      icon: Icons.hub_outlined,
    );
  }
}

final class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    return _StatusCard(
      eyebrow: 'SESSION',
      title: 'Identity active',
      message: email ?? 'No email available',
      icon: Icons.verified_user_outlined,
    );
  }
}

final class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.eyebrow,
    required this.title,
    required this.message,
    required this.icon,
  });

  final String eyebrow;
  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: AppSpacing.xl),
            Text(eyebrow, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
