class Validator {
  static String? validateEmail(String? value) {
    return (value != null && value.contains('@')) ? null : 'Enter valid email';
  }
}