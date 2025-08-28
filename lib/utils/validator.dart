import 'package:urticaria/utils/extension.dart';

class Validator {
  static String? validatePassword(
      {required String password, int minLength = 4}) {
    if (password.isEmpty) {
      return "Mật khẩu không được để trống";
    }
    if (password.length < minLength) {
      return "Độ dài mật khẩu không được ít hơn $minLength ký tự";
    }
    return null;
  }

  static String? validateString(
      {required String str, required String name, int minLength = 1}) {
    if (str.isEmpty) {
      return "$name không được để trống";
    }
    if (str.length < minLength) {
      return "$name phải có ít nhất $minLength ký tự";
    }
    return null;
  }

  static String? validateEmail(String str) {
    if (str.isValidEmail()) {
      return null;
    }
    return "Email không hợp lệ";
  }

  static String? validatePhoneNumber(String value) {
    // Chỉ nhận số, đúng 10 chữ số (cho chuẩn số VN)
    final regex = RegExp(r'^[0-9]{10}$');
    if (!regex.hasMatch(value)) {
      return "Số điện thoại không hợp lệ (phải có 10 số)";
    }
    return null;
  }

  static String? checkEmpty(dynamic str) {
    if (str == null || str.toString().isEmpty) {
      return '_';
    }
    return str.toString();
  }
}
