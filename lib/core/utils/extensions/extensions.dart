extension PasswordStrengthChecker on String {
  bool get isCotainUpperCase {
    final RegExp passwordRegex = RegExp(
      r'^(?=.*?[A-Z])',
    );
    return passwordRegex.hasMatch(this);
  }

  bool get isContainLowerCase {
    final RegExp passwordRegex = RegExp(
      r'^(?=.*?[a-z])',
    );
    return passwordRegex.hasMatch(this);
  }

  bool get isContainNumber {
    final RegExp passwordRegex = RegExp(
      r'^(?=.*?[0-9])',
    );
    return passwordRegex.hasMatch(this);
  }

  bool get isContainSymbol {
    final RegExp passwordRegex = RegExp(
      r'^(?=.*?[!@#\$&*~])',
    );
    return passwordRegex.hasMatch(this);
  }
}
