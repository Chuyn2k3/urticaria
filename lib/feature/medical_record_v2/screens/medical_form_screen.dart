import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/cubit/medical_record/medical_form_cubit.dart';
import 'package:urticaria/cubit/medical_record/medical_form_state.dart';
import 'package:urticaria/models/vital_indicator/vital_indicator_model.dart';

class MedicalFormScreen extends StatelessWidget {
  final int templateId;
  final int appointmentId;
  const MedicalFormScreen(
      {super.key, required this.templateId, required this.appointmentId});

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

class MedicalFormView extends StatelessWidget {
  const MedicalFormView(
      {super.key, required this.templateId, required this.appointmentId});
  final int templateId;
  final int appointmentId;
  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicalFormCubit, MedicalFormState>(
      listenWhen: (prev, curr) =>
          curr is MedicalFormSubmitting ||
          curr is MedicalFormSubmittedSuccess ||
          curr is MedicalFormError,
      listener: (context, state) {
        if (state is MedicalFormSubmittedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Tạo bệnh án thành công")),
          );
        } else if (state is MedicalFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ Lỗi khi tạo bệnh án: ${state.message}")),
          );
        }
      },
      child: BlocBuilder<MedicalFormCubit, MedicalFormState>(
        builder: (context, state) {
          if (state is MedicalFormLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MedicalFormError) {
            return Center(child: Text("❌ Lỗi: ${state.message}"));
          }
          if (state is MedicalFormLoaded ||
              state is MedicalFormSubmitting ||
              state is MedicalFormSubmittedSuccess) {
            final groups = (state as dynamic).groups;
            final answers = (state as dynamic).answers;

            return Stack(
              children: [
                Scaffold(
                  appBar: AppBar(
                    title: const Text("Bệnh án"),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          context.read<MedicalFormCubit>().submitMedicalRecord(
                                templateId: templateId,
                                appointmentId: appointmentId, // TODO: dynamic
                              );
                          print("Answers: $answers");
                        },
                      )
                    ],
                  ),
                  body: ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      return Card(
                        margin: const EdgeInsets.all(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(group.name,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 8),
                              ...group.indicators.map((indicator) {
                                return _buildIndicatorWidget(
                                  context,
                                  indicator,
                                  answers[indicator.id],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (state is MedicalFormSubmitting)
                  Container(
                    color: Colors.black45,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildIndicatorWidget(
      BuildContext context, VitalIndicator indicator, dynamic value) {
    final cubit = context.read<MedicalFormCubit>();
    switch (indicator.valueType) {
      case "text":
        return TextFormField(
          decoration: InputDecoration(labelText: indicator.name),
          initialValue: value?.toString(),
          onChanged: (val) => cubit.updateAnswer(indicator.id, val),
        );
      case "number":
        return TextFormField(
          decoration: InputDecoration(labelText: indicator.name),
          initialValue: value?.toString(),
          keyboardType: TextInputType.number,
          onChanged: (val) =>
              cubit.updateAnswer(indicator.id, num.tryParse(val)),
        );
      case "selection":
        final options = indicator.valueOptions as List<String>? ?? [];
        return DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(labelText: indicator.name),
          items: options
              .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
              .toList(),
          onChanged: (val) => cubit.updateAnswer(indicator.id, val),
        );
      case "multi_selection":
        final options = indicator.valueOptions as List<String>? ?? [];
        final selected = (value as List<String>?) ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(indicator.name),
            ...options.map((opt) {
              final checked = selected.contains(opt);
              return CheckboxListTile(
                title: Text(opt),
                value: checked,
                onChanged: (checkedVal) {
                  final updated = List<String>.from(selected);
                  if (checkedVal == true) {
                    updated.add(opt);
                  } else {
                    updated.remove(opt);
                  }
                  cubit.updateAnswer(indicator.id, updated);
                },
              );
            }).toList(),
          ],
        );
      case "boolean":
        return SwitchListTile(
          title: Text(indicator.name),
          value: value ?? false,
          onChanged: (val) => cubit.updateAnswer(indicator.id, val),
        );
      default:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text("⚠️ Chưa hỗ trợ loại: ${indicator.valueType}"),
        );
    }
  }
}
