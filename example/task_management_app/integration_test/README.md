# Integration tests

Add cross-layer device tests here only when a feature has a real integration
boundary worth exercising. The V1 authentication flow is intentionally backed
by a deterministic fake, so its behavior is covered by the faster unit, widget,
and router suites under `test/`.

Integration tests must use isolated test accounts/services, never production
credentials, and must document any required environment values.
