// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:urticaria/core/services/firebase_service.dart';
// import 'package:urticaria/cubit/medical_record/medical_form_cubit.dart';
// import 'package:urticaria/cubit/medical_record/medical_form_state.dart';
// import 'package:urticaria/feature/bottom_nav/bottom_nav_page.dart';
// import 'package:urticaria/models/vital_indicator/vital_indicator_model.dart';
// import 'package:urticaria/utils/navigation_service.dart';
// import 'package:urticaria/utils/snack_bar.dart';
// import '../../../constant/color.dart';
// import '../../../models/vital_group/vital_group.dart';
// import '../../../utils/enum/field_type_enum.dart';
// import '../../../widget/appbar/custom_app_bar.dart';
// import '../../../widget/custom_error_screen.dart';
// import '../../../widget/custom_progress_indicator.dart';
// import '../../../widget/text_field/input_text_field.dart';
// import '../widgets/custom_radio_group.dart';

// class MedicalFormScreen extends StatelessWidget {
//   final int templateId;
//   final int appointmentId;
//   const MedicalFormScreen({
//     super.key,
//     required this.templateId,
//     required this.appointmentId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => MedicalFormCubit()..loadMedicalForm(templateId),
//       child: Scaffold(
//         body: MedicalFormView(
//           templateId: templateId,
//           appointmentId: appointmentId,
//         ),
//       ),
//     );
//   }
// }

// class MedicalFormView extends StatelessWidget {
//   const MedicalFormView({
//     super.key,
//     required this.templateId,
//     required this.appointmentId,
//   });
//   final int templateId;
//   final int appointmentId;

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<MedicalFormCubit, MedicalFormState>(
//       listener: (context, state) async {
//         if (state is MedicalFormSubmittedSuccess) {
//           context.showSnackBarSuccess(
//             text: "✅ Tạo bệnh án thành công",
//             positionTop: true,
//           );
//           await Future.delayed(const Duration(seconds: 1));
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => BottomNavPage()),
//             );
//           });
//         } else if (state is MedicalFormError) {
//           context.showSnackBarFail(
//             text: "❌ Lỗi tạo bệnh án",
//             positionTop: true,
//           );
//           // Không pop màn hình → form vẫn hiển thị
//         }
//       },
//       child: BlocBuilder<MedicalFormCubit, MedicalFormState>(
//         builder: (context, state) {
//           final cubit = context.read<MedicalFormCubit>();

//           // Lấy dữ liệu từ Cubit luôn
//           final groups = (cubit.state is MedicalFormLoaded ||
//                   cubit.state is MedicalFormSubmitting ||
//                   cubit.state is MedicalFormSubmittedSuccess)
//               ? (cubit.state as dynamic).groups
//               : <VitalGroup>[];

//           final answers = (cubit.state is MedicalFormLoaded ||
//                   cubit.state is MedicalFormSubmitting ||
//                   cubit.state is MedicalFormSubmittedSuccess)
//               ? (cubit.state as dynamic).answers
//               : <int, dynamic>{};

//           if (state is MedicalFormLoading) {
//             return const Scaffold(
//               body: CustomProgressIndicator(),
//               backgroundColor: AppColors.whiteColor,
//             );
//           }

//           return Stack(
//             children: [
//               Scaffold(
//                 backgroundColor: Colors.grey[50],
//                 appBar: CustomAppbar.basic(
//                   onTap: () => Navigator.pop(context),
//                   widgetTitle: const Text(
//                     'Phân loại bệnh án',
//                     style: TextStyle(
//                         color: AppColors.whiteColor,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   backgroundColor: AppColors.primaryColor,
//                   actions: [
//                     IconButton(
//                       icon: const Icon(Icons.check, color: Colors.white),
//                       onPressed: () {
//                         context.read<MedicalFormCubit>().submitMedicalRecord(
//                             templateId: templateId,
//                             appointmentId: appointmentId);
//                       },
//                     )
//                   ],
//                 ),
//                 body: ListView.builder(
//                   itemCount: groups.length,
//                   itemBuilder: (context, index) {
//                     final group = groups[index];
//                     return Card(
//                       color: AppColors.whiteColor,
//                       margin: const EdgeInsets.all(12),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       elevation: 3,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(group.name,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleMedium
//                                     ?.copyWith(
//                                       fontWeight: FontWeight.bold,
//                                       color: AppColors.primaryColor,
//                                     )),
//                             const SizedBox(height: 12),
//                             ...group.indicators.map((indicator) {
//                               return Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 8),
//                                 child: IndicatorField(
//                                   indicator: indicator,
//                                   value: answers[indicator.id],
//                                   onChanged: (val) {
//                                     context
//                                         .read<MedicalFormCubit>()
//                                         .updateAnswer(indicator.id, val);
//                                   },
//                                 ),
//                               );
//                             }).toList(),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               if (state is MedicalFormSubmitting)
//                 Container(
//                   color: Colors.black45,
//                   child: const Center(
//                     child: CircularProgressIndicator(
//                       color: AppColors.whiteColor,
//                     ),
//                   ),
//                 )
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class IndicatorField extends StatelessWidget {
//   final VitalIndicator indicator;
//   final dynamic value;
//   final Function(dynamic) onChanged;

//   const IndicatorField({
//     super.key,
//     required this.indicator,
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     switch (indicator.valueType) {
//       case "text":
//         return InputTextField(
//           label: indicator.name,
//           onChanged: onChanged,
//         );

//       case "number":
//         return InputTextField(
//           label: indicator.name,
//           keyboardType: TextInputType.number,
//           onChanged: (val) => onChanged(num.tryParse(val)),
//         );

//       case "boolean":
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(indicator.name, style: Theme.of(context).textTheme.bodyMedium),
//             Row(
//               children: [
//                 Expanded(
//                   child: RadioListTile<bool>(
//                     title: const Text("Có"),
//                     value: true,
//                     groupValue: value,
//                     onChanged: onChanged,
//                     activeColor: AppColors.primaryColor,
//                   ),
//                 ),
//                 Expanded(
//                   child: RadioListTile<bool>(
//                     title: const Text("Không"),
//                     value: false,
//                     groupValue: value,
//                     onChanged: onChanged,
//                     activeColor: AppColors.primaryColor,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );

//       case "selection":
//         final options = indicator.valueOptions as List<String>? ?? [];
//         return CustomRadioGroup(
//             label: indicator.name,
//             value: value,
//             options: options,
//             onChanged: onChanged);

//       case "multi_selection":
//         final options = indicator.valueOptions as List<String>? ?? [];
//         final selected = (value as List<String>?) ?? [];
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(indicator.name),
//             Wrap(
//               spacing: 6,
//               children: options.map((opt) {
//                 final checked = selected.contains(opt);
//                 return FilterChip(
//                   backgroundColor: AppColors.whiteColor,
//                   label: Text(opt),
//                   selected: checked,
//                   selectedColor: AppColors.primaryColor.withOpacity(0.2),
//                   checkmarkColor: AppColors.primaryColor,
//                   onSelected: (sel) {
//                     final updated = List<String>.from(selected);
//                     if (sel) {
//                       updated.add(opt);
//                     } else {
//                       updated.remove(opt);
//                     }
//                     onChanged(updated);
//                   },
//                 );
//               }).toList(),
//             ),
//           ],
//         );

//       case "full_date":
//         return InkWell(
//           onTap: () async {
//             final picked = await showDatePicker(
//               context: context,
//               initialDate: DateTime.now(),
//               firstDate: DateTime(1970),
//               lastDate: DateTime(2100),
//             );
//             if (picked != null) {
//               onChanged(picked.toIso8601String());
//             }
//           },
//           child: InputTextField(
//             label: indicator.name,
//             enabled: false,
//             prefixIcon: const Icon(Icons.calendar_today),
//           ),
//         );

//       case "range":
//         final range = (value as RangeValues?) ?? const RangeValues(0, 100);
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(indicator.name),
//             RangeSlider(
//               values: range,
//               min: 0,
//               max: 100,
//               divisions: 20,
//               activeColor: AppColors.primaryColor,
//               onChanged: (val) => onChanged(val),
//             ),
//           ],
//         );

//       case "custom":
//         final groupJson = indicator.valueOptions['group'];
//         List<CustomFieldGroup> groups = [];

//         if (groupJson is List) {
//           // bình thường
//           groups = groupJson.map((g) => CustomFieldGroup.fromJson(g)).toList();
//         } else if (groupJson is Map<String, dynamic>) {
//           // map -> wrap thành list để đồng bộ
//           groups = [CustomFieldGroup.fromJson(groupJson)];
//         } else {
//           // fallback trống
//           groups = [];
//         }
//         print(groups.length);
//         return buildCustomField(groups, value, onChanged);

//       default:
//         return Text("⚠️ Chưa hỗ trợ loại: ${indicator.valueType}");
//     }
//   }

//   Widget buildCustomField(
//       dynamic fieldOrGroup, dynamic value, Function(dynamic) onChanged) {
//     // Xử lý danh sách groups
//     if (fieldOrGroup is List) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: fieldOrGroup
//             .map((e) => buildCustomField(e, value, onChanged))
//             .toList(),
//       );
//     }

//     // Xử lý CustomFieldGroup
//     if (fieldOrGroup is CustomFieldGroup) {
//       final group = fieldOrGroup;
//       List<Widget> children = [];
//       if (group.label != null) {
//         children.add(
//           Text(
//             group.label!,
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         );
//       }
//       for (final f in group.fields) {
//         children.add(buildCustomField(f, value, onChanged));
//       }
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: children,
//       );
//     }

//     // Xử lý CustomField
//     if (fieldOrGroup is CustomField) {
//       final field = fieldOrGroup;
//       List<Widget> widgets = [];

//       switch (field.type) {
//         case FieldType.text:
//           widgets.add(
//             InputTextField(
//               label: field.label ?? '',
//               onChanged: onChanged,
//             ),
//           );
//           break;
//         case FieldType.number:
//           widgets.add(
//             InputTextField(
//               label: field.label ?? '',
//               keyboardType: TextInputType.number,
//               onChanged: (val) => onChanged(num.tryParse(val)),
//             ),
//           );
//           break;
//         case FieldType.select:
//           widgets.add(
//             CustomRadioGroup(
//               label: field.label ?? '',
//               value: value,
//               options: field.options ?? [],
//               onChanged: onChanged,
//             ),
//           );
//           break;
//         case FieldType.multiSelection:
//           final selected = (value as List<String>?) ?? [];
//           widgets.add(
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(field.label ?? ''),
//                 Wrap(
//                   spacing: 6,
//                   children: (field.options ?? []).map((opt) {
//                     final checked = selected.contains(opt);
//                     return FilterChip(
//                       backgroundColor: AppColors.whiteColor,
//                       label: Text(opt),
//                       selected: checked,
//                       onSelected: (sel) {
//                         final updated = List<String>.from(selected);
//                         if (sel) {
//                           updated.add(opt);
//                         } else {
//                           updated.remove(opt);
//                         }
//                         onChanged(updated);
//                       },
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//           );
//           break;
//         case FieldType.fullYearRange:
//           widgets.add(
//             InkWell(
//               onTap: () async {
//                 final picked = await showDatePicker(
//                   context: getContext, // Sửa: Sử dụng context từ IndicatorField
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(1970),
//                   lastDate: DateTime(2100),
//                 );
//                 if (picked != null) onChanged(picked.toIso8601String());
//               },
//               child: InputTextField(
//                 label: field.label ?? "Khoảng năm",
//                 enabled: false,
//                 prefixIcon: const Icon(Icons.calendar_today),
//               ),
//             ),
//           );
//           break;
//         case FieldType.prescription:
//           widgets.add(
//             InputTextField(
//               label: field.label ?? 'Kê đơn thuốc',
//               onChanged: (value) => onChanged(value),
//               hintText: 'Nhập tên thuốc hoặc thông tin đơn thuốc',
//               prefixIcon: const Icon(Icons.medical_services),
//             ),
//           );
//           break;
//         case FieldType.custom:
//           if (field.groups != null && field.groups!.isNotEmpty) {
//             for (final g in field.groups!) {
//               widgets.add(buildCustomField(g, value, onChanged));
//             }
//           } else {
//             // Xử lý trường hợp custom field không có groups nhưng có thể có fields lồng nhau
//             widgets.add(
//               Text(
//                 field.label ?? 'Custom Field',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             );
//           }
//           break;
//         default:
//           widgets.add(Text("⚠️ Chưa hỗ trợ type ${field.type}"));
//       }

//       // Hiển thị requiredFields
//       if (field.requiredFields != null) {
//         for (final rf in field.requiredFields!) {
//           widgets.add(buildCustomField(rf, value, onChanged));
//         }
//       }

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: widgets,
//       );
//     }

//     // Xử lý JSON thô (fallback)
//     if (fieldOrGroup is Map<String, dynamic>) {
//       return buildCustomField(
//           CustomField.fromJson(fieldOrGroup), value, onChanged);
//     }

//     return SizedBox.shrink();
//   }
//   // Widget buildCustomField(
//   //     dynamic fieldOrGroup, dynamic value, Function(dynamic) onChanged) {
//   //   // nếu là list thì render từng phần tử
//   //
//   //   if (fieldOrGroup is List) {
//   //     return Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: fieldOrGroup
//   //           .map((e) => buildCustomField(e, value, onChanged))
//   //           .toList(),
//   //     );
//   //   }
//   //
//   //   // nếu là group
//   //   if (fieldOrGroup is CustomFieldGroup) {
//   //     final group = fieldOrGroup;
//   //     List<Widget> children = [];
//   //     if (group.label != null) {
//   //       children.add(
//   //           Text(group.label!, style: TextStyle(fontWeight: FontWeight.bold)));
//   //     }
//   //     for (final f in group.fields) {
//   //       children.add(buildCustomField(f, value, onChanged));
//   //     }
//   //     return Column(
//   //         crossAxisAlignment: CrossAxisAlignment.start, children: children);
//   //   }
//   //
//   //   // nếu là field
//   //   if (fieldOrGroup is CustomField) {
//   //     final field = fieldOrGroup;
//   //     List<Widget> widgets = [];
//   //
//   //     switch (field.type) {
//   //       case FieldType.text:
//   //         widgets.add(
//   //             InputTextField(label: field.label ?? '', onChanged: onChanged));
//   //         break;
//   //       case FieldType.number:
//   //         widgets.add(InputTextField(
//   //           label: field.label ?? '',
//   //           keyboardType: TextInputType.number,
//   //           onChanged: (val) => onChanged(num.tryParse(val)),
//   //         ));
//   //         break;
//   //       case FieldType.select:
//   //         widgets.add(CustomRadioGroup(
//   //           label: field.label ?? '',
//   //           value: value,
//   //           options: field.options ?? [],
//   //           onChanged: onChanged,
//   //         ));
//   //         break;
//   //       case FieldType.multiSelection:
//   //         final selected = (value as List<String>?) ?? [];
//   //         widgets.add(Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             Text(field.label ?? ''),
//   //             Wrap(
//   //               spacing: 6,
//   //               children: (field.options ?? []).map((opt) {
//   //                 final checked = selected.contains(opt);
//   //                 return FilterChip(
//   //                   label: Text(opt),
//   //                   selected: checked,
//   //                   onSelected: (sel) {
//   //                     final updated = List<String>.from(selected);
//   //                     if (sel)
//   //                       updated.add(opt);
//   //                     else
//   //                       updated.remove(opt);
//   //                     onChanged(updated);
//   //                   },
//   //                 );
//   //               }).toList(),
//   //             ),
//   //           ],
//   //         ));
//   //         break;
//   //       case FieldType.fullYearRange:
//   //         widgets.add(InkWell(
//   //           onTap: () async {
//   //             final picked = await showDatePicker(
//   //               context: getContext,
//   //               initialDate: DateTime.now(),
//   //               firstDate: DateTime(1970),
//   //               lastDate: DateTime(2100),
//   //             );
//   //             if (picked != null) onChanged(picked.toIso8601String());
//   //           },
//   //           child: InputTextField(
//   //               label: field.label ?? "Khoảng năm",
//   //               enabled: false,
//   //               prefixIcon: const Icon(Icons.calendar_today)),
//   //         ));
//   //         break;
//   //       case FieldType.custom:
//   //         // Nếu có groups thì render theo groups
//   //         if (field.groups != null && field.groups!.isNotEmpty) {
//   //           for (final g in field.groups!) {
//   //             widgets.add(buildCustomField(g, value, onChanged));
//   //           }
//   //         }
//   //         // fallback
//   //         else if (field.groups == null) {
//   //           widgets.add(Text("⚠️ Chưa có group hoặc field con"));
//   //         }
//   //         break;
//   //
//   //       case FieldType.prescription:
//   //         widgets.add(
//   //           InputTextField(
//   //             label: field.label ?? 'Kê đơn thuốc',
//   //             onChanged: (value) =>
//   //                 onChanged(value), // Update the value in the Cubit
//   //             hintText: 'Nhập tên thuốc hoặc thông tin đơn thuốc',
//   //             prefixIcon: const Icon(Icons.medical_services),
//   //           ),
//   //         );
//   //         break;
//   //
//   //       default:
//   //         widgets.add(Text("⚠️ Chưa hỗ trợ type ${field.type}"));
//   //     }
//   //
//   //     if (field.requiredFields != null) {
//   //       for (final rf in field.requiredFields!) {
//   //         widgets.add(buildCustomField(rf, value, onChanged));
//   //       }
//   //     }
//   //
//   //     return Column(
//   //         crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
//   //   }
//   //
//   //   // fallback
//   //   return SizedBox.shrink();
//   // }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/core/services/firebase_service.dart';
import 'package:urticaria/cubit/medical_record/medical_form_cubit.dart';
import 'package:urticaria/cubit/medical_record/medical_form_state.dart';
import 'package:urticaria/feature/bottom_nav/bottom_nav_page.dart';
import 'package:urticaria/feature/medical_record_v2/widgets/custom_checkbox_group.dart';
import 'package:urticaria/models/vital_indicator/vital_indicator_model.dart';
import 'package:urticaria/utils/navigation_service.dart';
import 'package:urticaria/utils/snack_bar.dart';
import '../../../constant/color.dart';
import '../../../models/vital_group/vital_group.dart';
import '../../../utils/enum/field_type_enum.dart';
import '../../../widget/appbar/custom_app_bar.dart';
import '../../../widget/custom_error_screen.dart';
import '../../../widget/custom_progress_indicator.dart';
import '../../../widget/text_field/input_text_field.dart';
import '../widgets/custom_radio_group.dart';

class MedicalFormScreen extends StatelessWidget {
  final int templateId;
  final int appointmentId;
  const MedicalFormScreen({
    super.key,
    required this.templateId,
    required this.appointmentId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MedicalFormCubit()..loadMedicalForm(templateId),
      child: Scaffold(
        body: MedicalFormView(
          templateId: templateId,
          appointmentId: appointmentId,
        ),
      ),
    );
  }
}

class MedicalFormView extends StatefulWidget {
  const MedicalFormView({
    super.key,
    required this.templateId,
    required this.appointmentId,
  });
  final int templateId;
  final int appointmentId;

  @override
  State<MedicalFormView> createState() => _MedicalFormViewState();
}

class _MedicalFormViewState extends State<MedicalFormView> {
  int currentStep = 0;
  PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void nextStep(int totalSteps) {
    if (currentStep < totalSteps - 1) {
      setState(() {
        currentStep++;
      });
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicalFormCubit, MedicalFormState>(
      listener: (context, state) async {
        if (state is MedicalFormSubmittedSuccess) {
          context.showSnackBarSuccess(
            text: "✅ Tạo bệnh án thành công",
            positionTop: true,
          );
          await Future.delayed(const Duration(seconds: 1));
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => BottomNavPage()),
            );
          });
        } else if (state is MedicalFormError) {
          context.showSnackBarFail(
            text: "❌ Lỗi tạo bệnh án",
            positionTop: true,
          );
        }
      },
      child: BlocBuilder<MedicalFormCubit, MedicalFormState>(
        builder: (context, state) {
          final cubit = context.read<MedicalFormCubit>();

          final groups = (cubit.state is MedicalFormLoaded ||
                  cubit.state is MedicalFormSubmitting ||
                  cubit.state is MedicalFormSubmittedSuccess)
              ? (cubit.state as dynamic).groups
              : <VitalGroup>[];

          final answers = (cubit.state is MedicalFormLoaded ||
                  cubit.state is MedicalFormSubmitting ||
                  cubit.state is MedicalFormSubmittedSuccess)
              ? (cubit.state as dynamic).answers
              : <int, dynamic>{};

          if (state is MedicalFormLoading) {
            return const Scaffold(
              body: CustomProgressIndicator(),
              backgroundColor: AppColors.whiteColor,
            );
          }

          if (groups.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('Không có dữ liệu form')),
            );
          }

          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.grey[50],
                appBar: CustomAppbar.basic(
                  onTap: () => Navigator.pop(context),
                  widgetTitle: Column(
                    children: [
                      const Text(
                        'Phân loại bệnh án',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Bước ${currentStep + 1}/${groups.length}',
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.primaryColor,
                  actions: [
                    if (currentStep == groups.length - 1)
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.white),
                        onPressed: () {
                          context.read<MedicalFormCubit>().submitMedicalRecord(
                              templateId: widget.templateId,
                              appointmentId: widget.appointmentId);
                        },
                      )
                  ],
                ),
                body: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: LinearProgressIndicator(
                        value: (currentStep + 1) / groups.length,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: pageController,
                        onPageChanged: (index) {
                          setState(() {
                            currentStep = index;
                          });
                        },
                        itemCount: groups.length,
                        itemBuilder: (context, index) {
                          final group = groups[index];
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Card(
                              color: AppColors.whiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      group.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryColor,
                                          ),
                                    ),
                                    const SizedBox(height: 20),
                                    ...group.indicators.map((indicator) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: IndicatorField(
                                          indicator: indicator,
                                          value: answers[indicator.id],
                                          onChanged: (val) {
                                            context
                                                .read<MedicalFormCubit>()
                                                .updateAnswer(
                                                    indicator.id, val);
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          if (currentStep > 0)
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: previousStep,
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Quay lại'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primaryColor,
                                  side: const BorderSide(
                                    color: AppColors.primaryColor,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          if (currentStep > 0) const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: currentStep == groups.length - 1
                                  ? () {
                                      context
                                          .read<MedicalFormCubit>()
                                          .submitMedicalRecord(
                                            templateId: widget.templateId,
                                            appointmentId: widget.appointmentId,
                                          );
                                    }
                                  : () => nextStep(groups.length),
                              icon: Icon(
                                currentStep == groups.length - 1
                                    ? Icons.check
                                    : Icons.arrow_forward,
                              ),
                              label: Text(
                                currentStep == groups.length - 1
                                    ? 'Hoàn thành'
                                    : 'Tiếp theo',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (state is MedicalFormSubmitting)
                Container(
                  color: Colors.black45,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.whiteColor,
                    ),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}

class IndicatorField extends StatelessWidget {
  final VitalIndicator indicator;
  final dynamic value;
  final Function(dynamic) onChanged;

  const IndicatorField({
    super.key,
    required this.indicator,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (indicator.valueType) {
      case "text":
        return InputTextField(
          label: indicator.name,
          onChanged: onChanged,
        );

      case "number":
        return InputTextField(
          label: indicator.name,
          keyboardType: TextInputType.number,
          onChanged: (val) => onChanged(num.tryParse(val)),
        );

      case "boolean":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(indicator.name, style: Theme.of(context).textTheme.bodyMedium),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Có"),
                    value: true,
                    groupValue: value,
                    onChanged: onChanged,
                    activeColor: AppColors.primaryColor,
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Không"),
                    value: false,
                    groupValue: value,
                    onChanged: onChanged,
                    activeColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        );

      case "selection":
        final options = indicator.valueOptions as List<String>? ?? [];
        return CustomRadioGroup(
            label: indicator.name,
            value: value,
            options: options,
            onChanged: onChanged);

      case "multi_selection":
        final options = indicator.valueOptions as List<String>? ?? [];
        final selected = (value as List<String>?) ?? [];

        return CustomCheckboxGroup(
          label: indicator.name,
          selectedValues: selected,
          options: options,
          onChanged: (newValues) => onChanged(newValues),
          // isRequired: indicator.isRequired ?? false,
          enabled: true,
        );

      case "full_date":
        return InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1970),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              onChanged(picked.toIso8601String());
            }
          },
          child: InputTextField(
            label: indicator.name,
            enabled: false,
            prefixIcon: const Icon(Icons.calendar_today),
          ),
        );

      case "range":
        final range = (value as RangeValues?) ?? const RangeValues(0, 100);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(indicator.name),
            RangeSlider(
              values: range,
              min: 0,
              max: 100,
              divisions: 20,
              activeColor: AppColors.primaryColor,
              onChanged: (val) => onChanged(val),
            ),
          ],
        );

      case "custom":
        final groupJson = indicator.valueOptions['group'];
        List<CustomFieldGroup> groups = [];

        if (groupJson is List) {
          groups = groupJson.map((g) => CustomFieldGroup.fromJson(g)).toList();
        } else if (groupJson is Map<String, dynamic>) {
          groups = [CustomFieldGroup.fromJson(groupJson)];
        } else {
          groups = [];
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              indicator.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            buildCustomField(groups, value, onChanged),
          ],
        );

      default:
        return Text("⚠️ Chưa hỗ trợ loại: ${indicator.valueType}");
    }
  }

  Widget buildCustomField(
      dynamic fieldOrGroup, dynamic value, Function(dynamic) onChanged) {
    if (fieldOrGroup is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fieldOrGroup
            .map((e) => buildCustomField(e, value, onChanged))
            .toList(),
      );
    }

    if (fieldOrGroup is CustomFieldGroup) {
      final group = fieldOrGroup;
      List<Widget> children = [];
      if (group.label != null) {
        children.add(
          Text(
            group.label!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }
      for (final f in group.fields) {
        children.add(buildCustomField(f, value, onChanged));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }

    if (fieldOrGroup is CustomField) {
      final field = fieldOrGroup;
      List<Widget> widgets = [];

      switch (field.type) {
        case FieldType.text:
          widgets.add(
            InputTextField(
              label: field.label ?? '',
              onChanged: onChanged,
            ),
          );
          break;
        case FieldType.number:
          widgets.add(
            InputTextField(
              label: field.label ?? '',
              keyboardType: TextInputType.number,
              onChanged: (val) => onChanged(num.tryParse(val)),
            ),
          );
          break;
        case FieldType.select:
          widgets.add(
            CustomRadioGroup(
              label: field.label ?? '',
              value: value,
              options: field.options ?? [],
              onChanged: onChanged,
            ),
          );
          break;
        case FieldType.multiSelection:
          final selected = (value as List<String>?) ?? [];
          widgets.add(
            CustomCheckboxGroup(
              label: field.label ?? '',
              options: field.options ?? [],
              selectedValues: selected,
              onChanged: onChanged,
            ),
          );
          break;

        // case FieldType.multiSelection:
        //   final selected = (value as List<String>?) ?? [];
        //   widgets.add(
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(field.label ?? ''),
        //         Wrap(
        //           spacing: 6,
        //           children: (field.options ?? []).map((opt) {
        //             final checked = selected.contains(opt);
        //             return FilterChip(
        //               backgroundColor: AppColors.whiteColor,
        //               label: Text(opt),
        //               selected: checked,
        //               selectedColor: AppColors.primaryColor.withOpacity(0.2),
        //               checkmarkColor: AppColors.primaryColor,
        //               onSelected: (sel) {
        //                 final updated = List<String>.from(selected);
        //                 if (sel) {
        //                   updated.add(opt);
        //                 } else {
        //                   updated.remove(opt);
        //                 }
        //                 onChanged(updated);
        //               },
        //             );
        //           }).toList(),
        //         ),
        //       ],
        //     ),
        //   );
        //   break;
        case FieldType.fullYearRange:
          widgets.add(
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: getContext,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1970),
                  lastDate: DateTime(2100),
                );
                if (picked != null) onChanged(picked.toIso8601String());
              },
              child: InputTextField(
                label: field.label ?? "Khoảng năm",
                enabled: false,
                prefixIcon: const Icon(Icons.calendar_today),
              ),
            ),
          );
          break;
        case FieldType.prescription:
          widgets.add(
            InputTextField(
              label: field.label ?? 'Kê đơn thuốc',
              onChanged: (value) => onChanged(value),
              hintText: 'Nhập tên thuốc hoặc thông tin đơn thuốc',
              prefixIcon: const Icon(Icons.medical_services),
            ),
          );
          break;
        case FieldType.custom:
          if (field.groups != null && field.groups!.isNotEmpty) {
            for (final g in field.groups!) {
              widgets.add(buildCustomField(g, value, onChanged));
            }
          } else {
            widgets.add(
              Text(
                field.label ?? 'Custom Field',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }
          break;
        default:
          widgets.add(Text("⚠️ Chưa hỗ trợ type ${field.type}"));
      }

      if (field.requiredFields != null) {
        for (final rf in field.requiredFields!) {
          widgets.add(buildCustomField(rf, value, onChanged));
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      );
    }

    if (fieldOrGroup is Map<String, dynamic>) {
      return buildCustomField(
          CustomField.fromJson(fieldOrGroup), value, onChanged);
    }

    return SizedBox.shrink();
  }
}
