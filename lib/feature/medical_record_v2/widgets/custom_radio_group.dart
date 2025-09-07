// import 'package:flutter/material.dart';

// import '../../../constant/color.dart';

// class CustomRadioGroup extends StatelessWidget {
//   final String label;
//   final String? value;
//   final List<String> options;
//   final Function(String?) onChanged;
//   final bool isRequired;
//   final bool enabled;

//   const CustomRadioGroup({
//     Key? key,
//     required this.label,
//     this.value,
//     required this.options,
//     required this.onChanged,
//     this.isRequired = false,
//     this.enabled = true,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           RichText(
//             text: TextSpan(
//               text: label,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black87,
//               ),
//               children: [
//                 if (isRequired)
//                   const TextSpan(
//                     text: ' *',
//                     style: TextStyle(color: Colors.red),
//                   ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey[300]!),
//               borderRadius: BorderRadius.circular(8),
//               color: enabled ? AppColors.whiteColor : Colors.grey[50],
//             ),
//             child: Column(
//               children: options.map((option) {
//                 return RadioListTile<String>(
//                   title: Text(
//                     option,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: enabled ? Colors.black87 : Colors.grey[600],
//                     ),
//                   ),
//                   value: option,
//                   groupValue: value,
//                   onChanged: enabled ? onChanged : null,
//                   contentPadding: EdgeInsets.zero,
//                   dense: true,
//                   activeColor: Colors.blue,
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:urticaria/constant/color.dart';

class CustomRadioGroup extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final Function(String?) onChanged;
  final bool isRequired;
  final bool enabled;

  const CustomRadioGroup({
    Key? key,
    required this.label,
    this.value,
    required this.options,
    required this.onChanged,
    this.isRequired = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.1,
                ),
                children: [
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: AppColors.errorColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: enabled ? AppColors.whiteColor : AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.borderColor,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isSelected = value == option;

                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withOpacity(0.08)
                          : Colors.transparent,
                      border: index < options.length - 1
                          ? Border(
                              bottom: BorderSide(
                                color: AppColors.borderColor.withOpacity(0.5),
                                width: 0.8,
                              ),
                            )
                          : null,
                    ),
                    child: RadioListTile<String>(
                      title: Text(
                        option,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: enabled
                              ? (isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.textPrimary)
                              : AppColors.textSecondary,
                          letterSpacing: 0.1,
                        ),
                      ),
                      value: option,
                      groupValue: value,
                      onChanged: enabled ? onChanged : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      dense: false,
                      activeColor: AppColors.primaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.comfortable,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
