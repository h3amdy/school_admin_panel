class KValidator {
  /// Empty Text Validation
  static String? validateEmptyText({required String fieldName, String? value}) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة.';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'يجب أن تكون كلمة المرور مكونة من 6 أحرف على الأقل.';
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل.';
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل.';
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return 'يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل.';
    }

    return null;
  }

  // check phoneNumber
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب.';
    }

    // Regular expression for phone number validation (9 or 10 digits)
    final phoneRegExp = RegExp(r'^\d{9,10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'تنسيق رقم الهاتف غير صالح (يجب أن يكون مكوناً من 9 أو 10 أرقام).';
    }

    return null;
  }
}
