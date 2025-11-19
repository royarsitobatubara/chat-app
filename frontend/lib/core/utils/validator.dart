String? validateEmail(String value) {
  if (value.trim().isEmpty) {
    return 'Email cannot be empty';
  }
  final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
  if (!regex.hasMatch(value.trim())) {
    return 'Invalid format';
  }
  return null;
}

String? validatePassword(String value) {
  if (value.trim().isEmpty) {
    return 'Password cannot be empty';
  }
  if (value.length < 6) {
    return 'Minimum 6 characters';
  }
  return null;
}

String? validateUsername(String value) {
  if (value.trim().isEmpty) {
    return 'Password cannot be empty';
  }
  if (value.length < 3) {
    return 'Minimum 3 characters';
  } else if (value.length > 20) {
    return 'Maximum 20 characters';
  }

  return null;
}
