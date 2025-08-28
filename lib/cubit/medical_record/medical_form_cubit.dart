import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/core/repositories/medical_record_repository.dart';
import 'package:urticaria/di/locator.dart';
import 'package:urticaria/models/medical_record_template/medical_record_request.dart';
import 'medical_form_state.dart';

class MedicalFormCubit extends Cubit<MedicalFormState> {
  final templateRepository = serviceLocator<MedicalRecordRepository>();

  MedicalFormCubit() : super(MedicalFormInitial());

  Future<void> loadMedicalForm(int templateId) async {
    emit(MedicalFormLoading());
    try {
      final templateRes = await templateRepository.getTemplate(templateId);
      final template = templateRes.data;
      if (template == null) {
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

      emit(MedicalFormLoaded(groups: groups, answers: answers));
    } catch (e) {
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
      updated[indicatorId] = value;
      emit(current.copyWith(answers: updated));
    }
  }

  Future<void> submitMedicalRecord({
    required int templateId,
    required int appointmentId,
  }) async {
    if (state is! MedicalFormLoaded) return;
    final current = state as MedicalFormLoaded;

    emit(MedicalFormSubmitting(
        groups: current.groups, answers: current.answers));

    try {
      final vitalValues = current.groups.expand((group) {
        return group.indicators.map((indicator) {
          final value = current.answers[indicator.id];
          return VitalValueRequest(
            vitalIndicatorId: indicator.id,
            groupId: group.id,
            value: {"value": value},
            note: null,
          );
        });
      }).toList();

      final request = MedicalRecordRequest(
        templateId: templateId,
        appointmentId: appointmentId,
        vitalValues: vitalValues,
      );

      final res = await templateRepository.createMedicalRecord(request);

      emit(MedicalFormSubmittedSuccess(
        groups: current.groups,
        answers: current.answers,
        response: res,
      ));
    } catch (e) {
      // ✨ Giữ lại dữ liệu khi lỗi
      emit(MedicalFormError(
        message: e.toString(),
        groups: current.groups,
        answers: current.answers,
      ));
    }
  }
}
