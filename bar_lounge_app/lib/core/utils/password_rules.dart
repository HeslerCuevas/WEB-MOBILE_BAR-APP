class PasswordRules {
  static String? validate(String value) {
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must include at least one uppercase letter.';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must include at least one lowercase letter.';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must include at least one number.';
    }
    return null;
  }
}
