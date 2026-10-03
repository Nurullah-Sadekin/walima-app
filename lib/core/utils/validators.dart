class Validators{
  static String? validateMobileOrEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number or email ID';
    }

    // Regular expression for validating email
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    // Regular expression for validating mobile number (10 digits)
    final mobileRegex = RegExp(r'^\d{11}$');

    if (!emailRegex.hasMatch(value) && !mobileRegex.hasMatch(value)) {
      return 'Please enter a valid mobile number or email ID';
    }

    return null; // Return null if the input is valid
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    final pattern = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).+$');
    if (!pattern.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character';
    }
    return null; // Return null if the input is valid
  }
  // email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email ID';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email ID';
    }
    return null; // Return null if the input is valid
  }
}