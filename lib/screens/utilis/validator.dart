class Validator {
  static bool showIcon = false;
  static bool showNameIcon = false;
  static bool showEmailIcon = false;
  static bool showPasswordIcon = false;
  static bool showConfirmIcon = false;

  static String? validateMobile(value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,11}$)';
    RegExp regExp = RegExp(pattern);
    if (value != null) {
      if (value!.length == 0) {
        showIcon = false;
        return "Enter Your Phone Number";
      } else if (!regExp.hasMatch(value)) {
        showIcon = false;
        return "Enter Valid Phone Number";
      }
    }
    showIcon = true;
    return null;
  }

  static String? validatePassword(value) {
    if (value.isEmpty) {
      showPasswordIcon = false;
      return "Password Required";
    }

    showPasswordIcon = true;
    return null;
  }

  static String? confirmPasswordValidator(String? password, String? value) {
    if (password == null) return '';
    if (value == null) return 'confirm password is required';
    value = value.trim();

    String? validate = validatePassword(value);
    if (validate != null) return validate;
    if (password == value) return null;
    return 'Passwords do not match';
  }

  static String? validateEmail(value) {
    var pattern = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
    RegExp regex = RegExp(pattern);
    if (value != null) {
      if (value!.isEmpty) {
        showEmailIcon = false;
        return "Email is required";
      } else if (!regex.hasMatch(value)) {
        showEmailIcon = false;
        return "Enter valid email";
      }
    }

    showEmailIcon = true;
    return null;
  }

  static String? requiredValidator<T>(T? value, String? message) {
    if (value == null || value.toString().isEmpty) {
      return message ?? "This field is required";
    }

    return null;
  }
}
