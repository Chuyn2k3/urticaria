import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
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
import '../../../utils/shared_preferences_manager.dart';
import '../../../widget/appbar/custom_app_bar.dart';
import '../../../widget/custom_error_screen.dart';
import '../../../widget/custom_progress_indicator.dart';
import '../../../widget/text_field/input_text_field.dart';
import '../widgets/custom_radio_group.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/image_upload_widget.dart';

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
              backgroundColor: AppColors.backgroundColor,
            );
          }

          if (groups.isEmpty) {
            return const Scaffold(
              backgroundColor: AppColors.backgroundColor,
              body: Center(
                child: Text(
                  'Không có dữ liệu form',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }

          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.backgroundColor,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(120),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: AppColors.whiteColor,
                                  size: 20,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Phân loại bệnh án',
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Bước ${currentStep + 1}/${groups.length}',
                                      style: const TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (currentStep == groups.length - 1)
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.successColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.successColor
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<MedicalFormCubit>()
                                        .submitMedicalRecord(
                                            templateId: widget.templateId,
                                            appointmentId:
                                                widget.appointmentId);
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                body: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tiến độ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '${((currentStep + 1) / groups.length * 100).round()}%',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.borderColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: (currentStep + 1) / groups.length,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor,
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ),
                        ],
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

                          // Lọc các indicator có visibility chứa "patient"
                          final visibleIndicators = group.indicators
                              .where(
                                  (indicator) => indicator.isVisibleToPatient)
                              .toList();
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryColor
                                        .withOpacity(0.08),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primaryColor
                                                .withOpacity(0.1),
                                            AppColors.primaryColor
                                                .withOpacity(0.05),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                color: AppColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              group.name,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryColor,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    visibleIndicators.map((indicator) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: IndicatorField(
                                          indicator: indicator,
                                          value: answers[indicator.id],
                                          onChanged: (val) {
                                            context
                                                .read<MedicalFormCubit>()
                                                .updateAnswer(
                                                    indicator.id, val);
                                          },
                                          templateId: widget.templateId,
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
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Row(
                          children: [
                            if (currentStep > 0)
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: OutlinedButton.icon(
                                    onPressed: previousStep,
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      'Quay lại',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primaryColor,
                                      backgroundColor: Colors.transparent,
                                      side: BorderSide.none,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (currentStep > 0) const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [
                                      currentStep == groups.length - 1
                                          ? AppColors.successColor
                                          : AppColors.primaryColor,
                                      currentStep == groups.length - 1
                                          ? AppColors.successColor
                                              .withOpacity(0.8)
                                          : AppColors.primaryColor
                                              .withOpacity(0.8),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (currentStep == groups.length - 1
                                              ? AppColors.successColor
                                              : AppColors.primaryColor)
                                          .withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: currentStep == groups.length - 1
                                      ? () {
                                          context
                                              .read<MedicalFormCubit>()
                                              .submitMedicalRecord(
                                                templateId: widget.templateId,
                                                appointmentId:
                                                    widget.appointmentId,
                                              );
                                        }
                                      : () => nextStep(groups.length),
                                  icon: Icon(
                                    currentStep == groups.length - 1
                                        ? Icons.check_circle_rounded
                                        : Icons.arrow_forward_ios,
                                    size: 20,
                                  ),
                                  label: Text(
                                    currentStep == groups.length - 1
                                        ? 'Hoàn thành'
                                        : 'Tiếp theo',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: AppColors.whiteColor,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (state is MedicalFormSubmitting)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Đang xử lý...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
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
  final int templateId;
  const IndicatorField({
    super.key,
    required this.indicator,
    required this.value,
    required this.onChanged,
    required this.templateId,
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
        final dateValue = value is String && value.isNotEmpty
            ? DateTime.tryParse(value)
            : null;

        return InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: dateValue ?? DateTime.now(),
              firstDate: DateTime(1970),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              onChanged(picked.toIso8601String());
            }
          },
          child: IgnorePointer(
            child: InputTextField(
              label: indicator.name,
              enabled: false,
              prefixIcon: const Icon(Icons.calendar_today),
              textController: TextEditingController(
                text: dateValue != null
                    ? "${dateValue.day.toString().padLeft(2, '0')}/"
                        "${dateValue.month.toString().padLeft(2, '0')}/"
                        "${dateValue.year}"
                    : '',
              ),
            ),
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

// Trong class IndicatorField, hàm buildCustomField
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
      if (group.label != null && group.label!.trim().isNotEmpty) {
        children.add(
          Text(
            group.label!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }

      for (int idx = 0; idx < group.fields.length; idx++) {
        final f = group.fields[idx];
        // Tính key theo quy tắc
        final groupLabel = group.label?.trim() ?? '';
        final fieldLabel = f.label?.trim() ??
            (groupLabel.isNotEmpty ? groupLabel : 'field_$idx');
        final fieldKey =
            groupLabel.isNotEmpty ? '$groupLabel.$fieldLabel' : fieldLabel;

        // Lấy value hiện tại cho field này
        final fieldValue = value?[fieldKey];

        children.add(
          buildCustomField(
            f,
            fieldValue, // Value riêng cho field
            (updatedValue) {
              final newMap = Map<String, dynamic>.from(value ?? {});
              if (_isValueNotEmpty(updatedValue)) {
                newMap[fieldKey] = updatedValue;
              } else {
                newMap.remove(fieldKey); // Lọc bỏ nếu rỗng
              }
              print(
                  'Updated value for key "$fieldKey": $updatedValue (new map: $newMap)'); // Log update
              onChanged(newMap);
            },
          ),
        );
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
              onChanged: (val) {
                final filteredVal = _isValueNotEmpty(val) ? val : null;
                print(
                    'Text changed for "${field.label}": $val (filtered: $filteredVal)'); // Log text input
                onChanged(filteredVal);
              },
            ),
          );
          break;
        case FieldType.number:
          widgets.add(
            InputTextField(
              label: field.label ?? '',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                final numVal = num.tryParse(val);
                final filteredVal = _isValueNotEmpty(numVal) ? numVal : null;
                print(
                    'Number changed for "${field.label}": $val (parsed: $numVal, filtered: $filteredVal)'); // Log number input
                onChanged(filteredVal);
              },
            ),
          );
          break;
        case FieldType.select:
          final allValues = (value as Map<String, dynamic>?) ?? {};
          final fieldKey =
              field.label ?? indicator.name ?? 'select_${indicator.id}';
          final currentOption = allValues[fieldKey] ?? null;

          final needsImage = (field.requiredFields ?? [])
              .any((rf) => rf.type == FieldType.image);

          widgets.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomRadioGroup(
                  label: field.label ?? indicator.name ?? 'Chọn tùy chọn',
                  value: currentOption,
                  options: field.options ?? [],
                  onChanged: (opt) {
                    final updated = Map<String, dynamic>.from(allValues);
                    if (_isValueNotEmpty(opt)) {
                      updated[fieldKey] = opt;
                    } else {
                      updated.remove(fieldKey);
                    }
                    // Giữ image cũ nếu có
                    print(
                        'Select changed for key "$fieldKey": $opt (updated map: $updated)'); // Log select change
                    onChanged(updated);
                  },
                ),
                if (needsImage && currentOption != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ImageUploadField(
                      label: "Ảnh cho $currentOption",
                      templateId: templateId,
                      onChanged: (link) {
                        final updated = Map<String, dynamic>.from(allValues);
                        final imageKey = "${fieldKey}_image";
                        if (_isValueNotEmpty(link)) {
                          updated[imageKey] = link;
                        } else {
                          updated.remove(imageKey);
                        }
                        print(
                            'Image changed for "$imageKey": $link (updated map: $updated)'); // Log image upload
                        onChanged(updated);
                      },
                    ),
                  ),
              ],
            ),
          );
          break;
        case FieldType.multiSelection:
          final allValues = (value as Map<String, dynamic>?) ?? {};
          final fieldKey = field.label ??
              indicator.name ??
              'multi_selection_${indicator.id}';
          final fieldValue =
              (allValues[fieldKey] as Map<String, dynamic>?) ?? {};
          final selectedValues = fieldValue.keys.toList();

          final needsImage = (field.requiredFields ?? [])
              .any((rf) => rf.type == FieldType.image);

          widgets.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCheckboxGroup(
                  label: field.label ?? indicator.name ?? 'Chọn tùy chọn',
                  selectedValues: selectedValues,
                  options: field.options ?? [],
                  onChanged: (vals) {
                    final updated = <String, dynamic>{};
                    for (var v in vals) {
                      if (_isValueNotEmpty(v)) {
                        updated[v] = fieldValue[v] as String?; // Giữ image cũ
                      }
                    }
                    final newAll = Map<String, dynamic>.from(allValues);
                    if (updated.isNotEmpty) {
                      newAll[fieldKey] = updated;
                    } else {
                      newAll.remove(fieldKey);
                    }
                    print(
                        'Multi-selection changed for key "$fieldKey": $vals (updated map: $newAll)'); // Log multi-select change
                    onChanged(newAll);
                  },
                ),
                if (needsImage)
                  ...selectedValues.map((opt) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ImageUploadField(
                        label: "Ảnh cho $opt",
                        templateId: templateId,
                        onChanged: (link) {
                          final updated = Map<String, dynamic>.from(fieldValue);
                          if (_isValueNotEmpty(link)) {
                            updated[opt] = link; // Lưu image dưới selected opt
                          } else {
                            updated.remove(opt);
                          }
                          final newAll = Map<String, dynamic>.from(allValues);
                          newAll[fieldKey] = updated;
                          print(
                              'Image for multi "$opt" in "$fieldKey": $link (updated map: $newAll)'); // Log image in multi
                          onChanged(newAll);
                        },
                        selectedOption: opt,
                      ),
                    );
                  }),
              ],
            ),
          );
          break;
        case FieldType.fullYearRange:
          final dateValue = value is String && value.isNotEmpty
              ? DateTime.tryParse(value)
              : null;

          widgets.add(InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context:
                    getContext, // Giả sử context có sẵn, hoặc dùng getContext nếu cần
                initialDate: dateValue ?? DateTime.now(),
                firstDate: DateTime(1970),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                final val = picked.toIso8601String();
                print(
                    'Date changed for "${indicator.name}": $val'); // Log date change
                onChanged(_isValueNotEmpty(val) ? val : null);
              }
            },
            child: IgnorePointer(
              child: InputTextField(
                label: indicator.name,
                enabled: false,
                prefixIcon: const Icon(Icons.calendar_today),
                textController: TextEditingController(
                  text: dateValue != null
                      ? "${dateValue.day.toString().padLeft(2, '0')}/"
                          "${dateValue.month.toString().padLeft(2, '0')}/"
                          "${dateValue.year}"
                      : '',
                ),
              ),
            ),
          ));
          break;
        case FieldType.prescription:
          widgets.add(
            InputTextField(
              label: field.label ?? 'Kê đơn thuốc',
              onChanged: (value) {
                final filteredVal = _isValueNotEmpty(value) ? value : null;
                print(
                    'Prescription changed for "${field.label}": $value (filtered: $filteredVal)'); // Log prescription
                onChanged(filteredVal);
              },
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

// Hàm helper lọc rỗng (giữ nguyên)
  bool _isValueNotEmpty(dynamic val) {
    if (val == null) return false;
    if (val is String) return val.trim().isNotEmpty;
    if (val is num) return true;
    if (val is List) return val.isNotEmpty;
    if (val is Map) return val.isNotEmpty;
    return true;
  }
}
