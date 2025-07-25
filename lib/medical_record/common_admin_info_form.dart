import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonAdministrativeInfoForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController birthdayController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final String? selectedGender;
  final Function(String?) onGenderChanged;

  const CommonAdministrativeInfoForm({
    super.key,
    required this.nameController,
    required this.birthdayController,
    required this.addressController,
    required this.phoneController,
    required this.emailController,
    this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF0066CC);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: themeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Thông tin hành chính',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Vui lòng điền đầy đủ thông tin cá nhân của bạn',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),

          // Họ và tên
          _buildInputField(
            label: 'Họ và tên *',
            controller: nameController,
            icon: Icons.person,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Vui lòng nhập họ tên';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Giới tính và năm sinh
          Row(
            children: [
              Expanded(
                child: _buildGenderSelector(themeColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInputField(
                  label: 'Năm sinh *',
                  controller: birthdayController,
                  icon: Icons.cake,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Vui lòng nhập năm sinh';
                    final year = int.tryParse(value!);
                    if (year == null ||
                        year < 1900 ||
                        year > DateTime.now().year) {
                      return 'Năm sinh không hợp lệ';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Số điện thoại
          _buildInputField(
            label: 'Số điện thoại *',
            controller: phoneController,
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Vui lòng nhập số điện thoại';
              if (value!.length < 10) return 'Số điện thoại không hợp lệ';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email
          _buildInputField(
            label: 'Email',
            controller: emailController,
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isNotEmpty ?? false) {
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value!)) {
                  return 'Email không hợp lệ';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Địa chỉ
          _buildInputField(
            label: 'Địa chỉ *',
            controller: addressController,
            icon: Icons.location_on,
            maxLines: 2,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Vui lòng nhập địa chỉ';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF0066CC), size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0066CC), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector(Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Giới tính *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedGender,
              hint: Row(
                children: [
                  Icon(Icons.wc, color: themeColor, size: 20),
                  const SizedBox(width: 12),
                  Flexible(child: const Text('Chọn giới tính')),
                ],
              ),
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: 'Nam',
                  child: Row(
                    children: [
                      Icon(Icons.male, color: themeColor, size: 20),
                      const SizedBox(width: 12),
                      const Text('Nam'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'Nữ',
                  child: Row(
                    children: [
                      Icon(Icons.female, color: Colors.pink, size: 20),
                      const SizedBox(width: 12),
                      const Text('Nữ'),
                    ],
                  ),
                ),
              ],
              onChanged: onGenderChanged,
            ),
          ),
        ),
      ],
    );
  }
}
