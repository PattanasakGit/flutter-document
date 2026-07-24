# Adding an optional module

Optional infrastructure does not belong in the core starter until a product
requirement selects it. This includes Firebase, databases, analytics,
notifications, localization, crash reporting, and specialized testing tools.

## Decision checklist

Before adding a package:

1. Write the feature requirement and data/event lifecycle.
2. Confirm Flutter/Dart/platform compatibility from official documentation.
3. Check maintenance, license, security posture, and latest compatible release.
4. Identify the narrow boundary the module implements.
5. Decide ownership: app composition, core infrastructure, or one feature.
6. Define offline/failure/privacy behavior.
7. Add tests and platform configuration.
8. Document setup, secrets, migration, and removal.

Do not install competing solutions "for flexibility."

## Integration pattern

Expose an application-owned interface only when it provides testability or
prevents vendor types leaking into features. Construct the vendor adapter with a
nearby Riverpod provider. Keep SDK models/errors behind the adapter and map them
to domain/application types.

Never make a global `services` folder that lets every feature call a vendor SDK
directly.

## Firebase

Choose only the required products. Generate platform configuration through the
official workflow and keep environment projects separate. Do not commit service
account credentials. Place initialization in app bootstrap and feature-specific
adapters in their owning feature/core boundary. Define emulator-based tests
before relying on remote test projects.

## Database

First document entities, query requirements, migration strategy, encryption,
backup, and data deletion. Choose one database. Keep database records in data,
map them to domain entities, and expose feature repository operations—not a
global database handle. Add migration and repository tests.

## Analytics

Create a typed event vocabulary and privacy review before adding an SDK.
Centralize consent, redaction, environment enablement, and user deletion.
Features may emit application-owned event types; vendor event objects must not
leak into presentation/domain. Test event mapping without sending remote events.

## Notifications

Document permission timing, token lifecycle, foreground/background behavior,
deep-link routing, and backend ownership. Keep platform messaging SDK details
behind an adapter. Use GoRouter route contracts for notification navigation and
test invalid/expired payloads.

## Localization

Define supported locales, fallback behavior, translation ownership, and
generation workflow. Prefer Flutter's official localization tooling unless a
clear requirement demands another package. Move user-facing strings into
generated localizations as a scoped migration; do not add an empty localization
layer.

## Completion requirements

- package/version rationale recorded;
- no source-controlled secret;
- all affected platforms configured;
- vendor types contained at the boundary;
- local/test environment available;
- failure and privacy behavior documented;
- format, generation, analyze, tests, and affected platform builds pass;
- README and changelog updated.
