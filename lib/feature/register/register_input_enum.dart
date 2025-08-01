import 'package:flutter/material.dart';
import 'package:urticaria/utils/common_app.dart';
import 'package:urticaria/utils/validator.dart';
import 'package:urticaria/widget/text_field/input_text_field.dart';

import 'password_input.dart';

enum RegisternputEnum {
  fullName,
  phone,
  email,
  password,
  birthday, // "1990-01-01"
  gender, // MALE / FEMALE
  address,
}

extension ProfileInput on RegisternputEnum {
  String get hintText {
    switch (this) {
      case RegisternputEnum.fullName:
        return "Họ và tên";
      case RegisternputEnum.phone:
        return "Số điện thoại";
      case RegisternputEnum.email:
        return "Email";
      case RegisternputEnum.password:
        return "Mật khẩu";
      case RegisternputEnum.birthday:
        return "Ngày sinh (yyyy-mm-dd)";
      case RegisternputEnum.gender:
        return "Giới tính";
      case RegisternputEnum.address:
        return "Địa chỉ";
    }
  }

  String get text {
    switch (this) {
      case RegisternputEnum.fullName:
        return "Họ và tên";
      case RegisternputEnum.phone:
        return "Số điện thoại";
      case RegisternputEnum.email:
        return "Email";
      case RegisternputEnum.password:
        return "Mật khẩu";
      case RegisternputEnum.birthday:
        return "Ngày sinh";
      case RegisternputEnum.gender:
        return "Giới tính";
      case RegisternputEnum.address:
        return "Địa chỉ";
    }
  }

  IconData get icon {
    switch (this) {
      case RegisternputEnum.fullName:
        return Icons.person;
      case RegisternputEnum.phone:
        return Icons.phone;
      case RegisternputEnum.email:
        return Icons.email;
      case RegisternputEnum.password:
        return Icons.lock;
      case RegisternputEnum.birthday:
        return Icons.cake;
      case RegisternputEnum.gender:
        return Icons.wc;
      case RegisternputEnum.address:
        return Icons.home;
    }
  }

  String? Function(String?)? get validator {
    switch (this) {
      case RegisternputEnum.fullName:
        return (item) =>
            Validator.validateString(str: item ?? '', name: "Họ và tên");
      case RegisternputEnum.phone:
        return (item) => Validator.validatePhoneNumber(item ?? '');
      case RegisternputEnum.email:
        return (item) => (item == null || item.isEmpty)
            ? null
            : Validator.validateEmail(item);
      case RegisternputEnum.password:
        return (item) => Validator.validatePassword(password: item ?? '');
      case RegisternputEnum.birthday:
        return (item) =>
            (item == null || item.isEmpty) ? "Vui lòng chọn ngày sinh" : null;
      case RegisternputEnum.gender:
        return (item) => null;
      case RegisternputEnum.address:
        return (item) => null;
    }
  }
}

class RegisternputEnumConfig {
  final RegisternputEnum type;

  RegisternputEnumConfig.create({required this.type}) {
    configController();
  }

  TextEditingController? controller;
  String? genderValue; // cho dropdown
  DateTime? birthdayValue; // cho date picker

  void configController() {
    if (type == RegisternputEnum.gender || type == RegisternputEnum.birthday) {
      controller = null;
    } else {
      controller = TextEditingController(text: '');
    }
  }

  Map<String, dynamic> get requestValue {
    switch (type) {
      case RegisternputEnum.fullName:
        return {'fullname': controller?.text ?? ''};
      case RegisternputEnum.phone:
        return {'phone': controller?.text ?? ''};
      case RegisternputEnum.email:
        return {
          'email': controller?.text.isEmpty == true ? null : controller?.text
        };
      case RegisternputEnum.password:
        return {'password': controller?.text ?? ''};
      case RegisternputEnum.birthday:
        return {'birthday': birthdayValue?.toIso8601String() ?? ''};
      case RegisternputEnum.gender:
        return {'gender': genderValue ?? ''};
      case RegisternputEnum.address:
        return {'address': controller?.text ?? ''};
    }
  }

  Widget widgetItem(BuildContext context) {
    switch (type) {
      case RegisternputEnum.password:
        return _buildPasswordField();
      case RegisternputEnum.birthday:
        return _buildBirthdayPicker(context);
      case RegisternputEnum.gender:
        return _buildGenderDropdown();
      default:
        return _buildTextField();
    }
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(type.text,
              style: textTheme.t14B.copyWith(color: colorApp.labelPrimary)),
          const SizedBox(height: 4),
          PasswordInput(
            hintText: type.hintText,
            controller: controller,
            validator: type.validator,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBirthdayPicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type.text,
            style: textTheme.t14B.copyWith(color: colorApp.labelPrimary),
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                birthdayValue = date;
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixIcon:
                    const Icon(Icons.calendar_today, color: Colors.blue),
              ),
              child: Text(
                birthdayValue == null
                    ? type.hintText
                    : "${birthdayValue!.year}-${birthdayValue!.month.toString().padLeft(2, '0')}-${birthdayValue!.day.toString().padLeft(2, '0')}",
                style: textTheme.t14R.copyWith(
                  color: birthdayValue == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type.text,
            style: textTheme.t14B.copyWith(color: colorApp.labelPrimary),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: genderValue,
            hint: const Text("Chọn giới tính"),
            items: const [
              DropdownMenuItem(value: "MALE", child: Text("Nam")),
              DropdownMenuItem(value: "FEMALE", child: Text("Nữ")),
            ],
            onChanged: (value) {
              genderValue = value;
            },
            //validator: type.validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(type.text,
              style: textTheme.t14B.copyWith(color: colorApp.labelPrimary)),
          const SizedBox(height: 4),
          InputTextField(
            hintText: type.hintText,
            maxLine: 1,
            textAlign: TextAlign.left,
            textController: controller,
            validator: type.validator,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  static Map<String, dynamic> createRequestValueMap(
      List<RegisternputEnumConfig> items) {
    final resultMap = <String, dynamic>{};
    for (var item in items) {
      final key = item.requestValue.keys.first;
      final value = item.requestValue.values.first;

      // Bỏ qua nếu null hoặc chuỗi rỗng
      if (value != null && (value is! String || value.trim().isNotEmpty)) {
        resultMap[key] = value;
      }
    }

    return resultMap;
  }
}
