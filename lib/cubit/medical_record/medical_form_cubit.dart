import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/core/repositories/medical_record_repository.dart';
import 'package:urticaria/di/locator.dart';
import 'package:urticaria/models/medical_record_template/medical_record_request.dart';
import 'medical_form_state.dart';

class MedicalFormCubit extends Cubit<MedicalFormState> {
  final templateRepository = serviceLocator<MedicalRecordRepository>();

  MedicalFormCubit() : super(MedicalFormInitial());

  Future<void> loadMedicalForm(int templateId) async {
    print("[MedicalFormCubit] 🔄 Loading templateId: $templateId");
    emit(MedicalFormLoading());
    try {
      final templateRes = await templateRepository.getTemplate(templateId);
      final template = templateRes.data;
      if (template == null) {
        print("[MedicalFormCubit] ❌ Không tìm thấy templateId: $templateId");
        emit(const MedicalFormError(
          message: "Không tìm thấy template",
          groups: [],
          answers: {},
        ));
        return;
      }

      final futures = template.vitalGroupIds
          .map((id) => templateRepository.getVitalGroup(id));
      final results = await Future.wait(futures);

      final groups = results.map((res) => res.data!).toList();
      final answers = <int, dynamic>{};

      print("[MedicalFormCubit] ✅ Load thành công, groups: ${groups.length}");
      emit(MedicalFormLoaded(groups: groups, answers: answers));
    } catch (e) {
      print("[MedicalFormCubit] ❌ Lỗi loadMedicalForm: $e");
      emit(MedicalFormError(
        message: e.toString(),
        groups: [],
        answers: {},
      ));
    }
  }

  /// Cập nhật giá trị cho 1 indicator
  void updateAnswer(int indicatorId, dynamic value) {
    if (state is MedicalFormLoaded) {
      final current = state as MedicalFormLoaded;
      final updated = Map<int, dynamic>.from(current.answers);

      print(
          "[MedicalFormCubit] ✏️ Update answer: indicatorId=$indicatorId | oldValue=${updated[indicatorId]} -> newValue=$value");

      updated[indicatorId] = value;
      emit(current.copyWith(answers: updated));

      print("[MedicalFormCubit] 📊 Current answers: $updated");
    }
  }

  Future<void> submitMedicalRecord({
    required int templateId,
    required int appointmentId,
  }) async {
    if (state is! MedicalFormLoaded) return;
    final current = state as MedicalFormLoaded;

    print(
        "[MedicalFormCubit] 🚀 Submitting record | templateId=$templateId | appointmentId=$appointmentId");
    print("[MedicalFormCubit] 📋 Current answers: ${current.answers}");

    emit(MedicalFormSubmitting(
        groups: current.groups, answers: current.answers));

    try {
      final vitalValues = current.groups.expand((group) {
        return group.indicators.where((indicator) {
          final value = current.answers[indicator.id];
          return value != null; // chỉ giữ những cái có value
        }).map((indicator) {
          final value = current.answers[indicator.id];
          print(
              "[MedicalFormCubit] -> indicatorId=${indicator.id}, groupId=${group.id}, value=$value");
          return VitalValueRequest(
            vitalIndicatorId: indicator.id,
            groupId: group.id,
            value: value,
            note: null,
          );
        });
      }).toList();

      final request = MedicalRecordRequest(
        templateId: templateId,
        appointmentId: appointmentId,
        vitalValues: vitalValues,
      );

      print("[MedicalFormCubit] 📤 Request gửi đi: $request");

      final res = await templateRepository.createMedicalRecord(request);

      print("[MedicalFormCubit] ✅ Submit thành công: $res");

      emit(MedicalFormSubmittedSuccess(
        groups: current.groups,
        answers: current.answers,
        response: res,
      ));
    } catch (e) {
      print("[MedicalFormCubit] ❌ Submit lỗi: $e");
      emit(MedicalFormError(
        message: e.toString(),
        groups: current.groups,
        answers: current.answers,
      ));
    }
  }
}
