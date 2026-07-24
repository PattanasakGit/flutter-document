abstract final class CredentialValidators {
  static final RegExp _emailPattern = RegExp(
    r'^[A-Za-z0-9.!#$%&*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)+$',
  );

  static String? email(String value) {
    final email = value.trim();
    if (email.isEmpty) {
      return 'Enter your email address.';
    }
    if (!_emailPattern.hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) {
      return 'Enter your password.';
    }
    if (value.length < 8) {
      return 'Password must have at least 8 characters.';
    }
    return null;
  }
}
