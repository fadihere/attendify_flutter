// import 'package:attendify_lite/core/utils/extensions/extensions.dart';
import 'package:attendify_lite/core/utils/extensions/utils.dart';

// final RegExp phoneNumberRegExp = RegExp('^([1-9])[0-9]{9}\$');
String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  }

  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  } /* 
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Password must contain at least one capital letter';
  }
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return 'Password must contain at least one lowercase letter';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Password must contain at least one digit';
  }
  if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
    return 'Password must contain at least one special character (!@#\$&*~)';
  } */

  return null;
}

String? newPasswordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  }

  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Password must contain at least one capital letter';
  }
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return 'Password must contain at least one lowercase letter';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Password must contain at least one digit';
  }
  if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
    return 'Password must contain at least one special character (!@#\$&*~)';
  }
  // if (!value.isCotainUpperCase) {
  //   return 'Must contain at least 1 uppercase';
  // }
  // if (!value.isContainLowerCase) {
  //   return 'Must contain at least 1 lowercase';
  // }
  // if (!value.isContainSymbol) {
  //   return 'Must contain at least 1 special symbol';
  // }

  return null;
}

String? emailValidator(String? value, [Map<String, dynamic>? response]) {
  if (response != null) {
    return response['email'];
  }
  if (value == null || value.isEmpty) {
    return 'Please enter your email address';
  }
  if (!value.isEmail) {
    return 'Please enter valid email address';
  }
  return null;
}

String? oldEmailValidator(String? value, String oldEmail) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email address';
  }
  if (!value.isEmail) {
    return 'Please enter valid email address';
  }
  if (value != oldEmail) {
    return 'Email not matched';
  }
  return null;
}

String? newEmailValidator(String? value, String oldEmail) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email address';
  }
  if (!value.isEmail) {
    return 'Please enter valid email address';
  }
  if (value == oldEmail) {
    return 'Email should not match with existing';
  }
  return null;
}

String? phoneValidator(String? value, [Map<String, dynamic>? response]) {
  if (response != null) {
    return response['phone'];
  }
  if (value == null || value.isEmpty) {
    return 'Please enter your phone number';
  }

  if (!value.isPhoneNumber) {
    return 'Please enter valid phone number';
  }
  return null;
}

String? conformPasswordValidator(String? pass, String? confirmPass) {
  final isValid = passwordValidator(pass);
  if (isValid != null) return isValid;

  if (pass != confirmPass) {
    return "New Password and Confirm Password should match";
  }
  return null;
}

String? matchCheckPasswordWithCurrentPasswordValidator(
    String? currentPass, String? newPassword) {
  final isValid = passwordValidator(newPassword);
  if (isValid != null) return isValid;

  if (currentPass == newPassword) {
    return "New and Current Password can't be same";
  }
  return null;
}

String? conformPasswordAndPasswordMatchCheckValidator(
    String? currentPass, String? newPassword, String? confirmPassword) {
  final isValid = passwordValidator(confirmPassword);
  if (isValid != null) return isValid;

  if (newPassword != confirmPassword) {
    return "New Password and Confirm Password should match";
  }
  if (currentPass == confirmPassword) {
    return "Confirm and Current Password can't be same";
  }
  return null;
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }
  if (!value.isName) {
    return 'Please enter valid name';
  }
  return null;
}

String? otpValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter code you have received';
  }
  if (value.length != 6) {
    return 'Please enter a valid code';
  }
  return null;
}

String? oldPhoneValidator(
    {required String? value, required String currentPhone}) {
  if (value == null || value.isEmpty) {
    return 'Please enter your phone number';
  }
  if (!value.isPhoneNumber) {
    return 'Please enter valid phone number';
  }
  if (value != currentPhone) {
    return 'Phone number not matched with the existing';
  }

  return null;
}

String? newPhoneValidator({required String? value, required String oldPhone}) {
  if (value == null || value.isEmpty) {
    return 'Please enter your phone number';
  }
  if (!value.isPhoneNumber) {
    return 'Please enter valid phone number';
  }
  if (value == oldPhone) {
    return 'Cannot add same phone number';
  }

  return null;
}
