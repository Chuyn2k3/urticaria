// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:urticaria/core/repositories/medical_record_repository.dart';
// import 'package:urticaria/di/locator.dart';
// import 'package:urticaria/models/medical_record_template/medical_record_request.dart';
// import 'medical_form_state.dart';
//
// class MedicalFormCubit extends Cubit<MedicalFormState> {
//   final templateRepository = serviceLocator<MedicalRecordRepository>();
//
//   MedicalFormCubit() : super(MedicalFormInitial());
//
//   Future<void> loadMedicalForm(int templateId) async {
//     print("[MedicalFormCubit] 🔄 Loading templateId: $templateId");
//     emit(MedicalFormLoading());
//     try {
//       final templateRes = await templateRepository.getTemplate(templateId);
//       final template = templateRes.data;
//       if (template == null) {
//         print("[MedicalFormCubit] ❌ Không tìm thấy templateId: $templateId");
//         emit(const MedicalFormError(
//           message: "Không tìm thấy template",
//           groups: [],
//           answers: {},
//         ));
//         return;
//       }
//
//       final futures = template.vitalGroupIds
//           .map((id) => templateRepository.getVitalGroup(id));
//       final results = await Future.wait(futures);
//
//       final groups = results.map((res) => res.data!).toList();
//       final answers = <int, dynamic>{};
//
//       print("[MedicalFormCubit] ✅ Load thành công, groups: ${groups.length}");
//       emit(MedicalFormLoaded(groups: groups, answers: answers));
//     } catch (e) {
//       print("[MedicalFormCubit] ❌ Lỗi loadMedicalForm: $e");
//       emit(MedicalFormError(
//         message: e.toString(),
//         groups: [],
//         answers: {},
//       ));
//     }
//   }
//
//   /// Cập nhật giá trị cho 1 indicator
//   void updateAnswer(int indicatorId, dynamic value) {
//     if (state is MedicalFormLoaded) {
//       final current = state as MedicalFormLoaded;
//       final updated = Map<int, dynamic>.from(current.answers);
//
//       print(
//           "[MedicalFormCubit] ✏️ Update answer: indicatorId=$indicatorId | oldValue=${updated[indicatorId]} -> newValue=$value");
//
//       updated[indicatorId] = value;
//       emit(current.copyWith(answers: updated));
//
//       print("[MedicalFormCubit] 📊 Current answers: $updated");
//     }
//   }
//
//   Future<void> submitMedicalRecord({
//     required int templateId,
//     required int appointmentId,
//   }) async {
//     if (state is! MedicalFormLoaded) return;
//     final current = state as MedicalFormLoaded;
//
//     print(
//         "[MedicalFormCubit] 🚀 Submitting record | templateId=$templateId | appointmentId=$appointmentId");
//     print("[MedicalFormCubit] 📋 Current answers: ${current.answers}");
//
//     emit(MedicalFormSubmitting(
//         groups: current.groups, answers: current.answers));
//
//     try {
//       final vitalValues = current.groups.expand((group) {
//         return group.indicators.where((indicator) {
//           final value = current.answers[indicator.id];
//           return value != null; // chỉ giữ những cái có value
//         }).map((indicator) {
//           final value = current.answers[indicator.id];
//           print(
//               "[MedicalFormCubit] -> indicatorId=${indicator.id}, groupId=${group.id}, value=$value");
//           return VitalValueRequest(
//             vitalIndicatorId: indicator.id,
//             groupId: group.id,
//             value: value,
//             note: null,
//           );
//         });
//       }).toList();
//
//       final request = MedicalRecordRequest(
//         templateId: templateId,
//         appointmentId: appointmentId,
//         vitalValues: vitalValues,
//       );
//
//       print("[MedicalFormCubit] 📤 Request gửi đi: $request");
//
//       final res = await templateRepository.createMedicalRecord(request);
//
//       print("[MedicalFormCubit] ✅ Submit thành công: $res");
//
//       emit(MedicalFormSubmittedSuccess(
//         groups: current.groups,
//         answers: current.answers,
//         response: res,
//       ));
//     } catch (e) {
//       print("[MedicalFormCubit] ❌ Submit lỗi: $e");
//       emit(MedicalFormError(
//         message: e.toString(),
//         groups: current.groups,
//         answers: current.answers,
//       ));
//     }
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/core/repositories/medical_record_repository.dart';
import 'package:urticaria/di/locator.dart';
import 'package:urticaria/models/medical_record_template/medical_record_request.dart';
import '../../models/vital_group/vital_group.dart';
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
        emit(MedicalFormError(
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

      // Initially show all groups
      final visibleGroupIds = groups.map((group) => group.id).toSet();

      print("[MedicalFormCubit] ✅ Load thành công, groups: ${groups.length}");
      emit(MedicalFormLoaded(
        groups: groups,
        answers: answers,
        visibleGroupIds: visibleGroupIds,
        visibleIndicatorsInGroup12:
            _computeVisibleIndicatorsInGroup12(answers, groups),
        visibleIndicatorsInGroup27:
            _computeVisibleIndicatorsInGroup27(answers, groups),
      ));
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
      final visibleGroupIds = _computeVisibleGroupIds(updated, current.groups);
      final visibleIndicatorsInGroup12 =
          _computeVisibleIndicatorsInGroup12(updated, current.groups);
      final visibleIndicatorsInGroup27 =
          _computeVisibleIndicatorsInGroup27(updated, current.groups);

      emit(current.copyWith(
        answers: updated,
        visibleGroupIds: visibleGroupIds,
        visibleIndicatorsInGroup12: visibleIndicatorsInGroup12,
        visibleIndicatorsInGroup27: visibleIndicatorsInGroup27,
      ));

      print(
          "[MedicalFormCubit] 📊 Current answers: $updated | visibleGroupIds: $visibleGroupIds | "
          "visibleIndicatorsInGroup12: $visibleIndicatorsInGroup12 | visibleIndicatorsInGroup27: $visibleIndicatorsInGroup27");
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
      groups: current.groups,
      answers: current.answers,
      visibleGroupIds: current.visibleGroupIds,
      visibleIndicatorsInGroup12: current.visibleIndicatorsInGroup12,
      visibleIndicatorsInGroup27: current.visibleIndicatorsInGroup27,
    ));

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
        visibleGroupIds: current.visibleGroupIds,
        visibleIndicatorsInGroup12: current.visibleIndicatorsInGroup12,
        visibleIndicatorsInGroup27: current.visibleIndicatorsInGroup27,
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

  Set<int> _computeVisibleGroupIds(
      Map<int, dynamic> answers, List<VitalGroup> groups) {
    final indicator192 = answers[192] as String?;
    final indicator62 = answers[62] as String?;

    // Initially show all groups
    final visibleGroupIds = groups.map((group) => group.id).toSet();

    // Apply visibility rules only for "Sẩn phù" or "Phù mạch"
    if (indicator192 == "Sẩn phù") {
      visibleGroupIds.remove(18); // Hide group 18 if indicator 192 is "Sẩn phù"
      print(
          "[MedicalFormCubit] 📍 Hiding group 18 due to indicator 192 = Sẩn phù");
    }
    if (indicator62 == "Sẩn phù") {
      visibleGroupIds.remove(28); // Hide group 28 if indicator 62 is "Sẩn phù"
      print(
          "[MedicalFormCubit] 📍 Hiding group 28 due to indicator 62 = Sẩn phù");
    }

    print("[MedicalFormCubit] 📍 Computed visible groups: $visibleGroupIds");
    return visibleGroupIds;
  }

  Set<int> _computeVisibleIndicatorsInGroup12(
      Map<int, dynamic> answers, List<VitalGroup> groups) {
    final indicator192 = answers[192] as String?;

    // If indicator 192 is "Phù mạch", only show indicator 192 in group 12
    if (indicator192 == "Phù mạch") {
      print(
          "[MedicalFormCubit] 📍 Showing only indicator 192 in group 12 for Phù mạch");
      return {192};
    }

    // Default: show all indicators in group 12
    try {
      final group12 = groups.firstWhere((group) => group.id == 12);
      final allIndicatorIds =
          group12.indicators.map((indicator) => indicator.id).toSet();
      print(
          "[MedicalFormCubit] 📍 Showing all indicators in group 12: $allIndicatorIds");
      return allIndicatorIds;
    } catch (e) {
      print(
          "[MedicalFormCubit] ⚠️ Group 12 not found, returning empty indicators");
      return {};
    }
  }

  Set<int> _computeVisibleIndicatorsInGroup27(
      Map<int, dynamic> answers, List<VitalGroup> groups) {
    final indicator62 = answers[62] as String?;

    // If indicator 62 is "Phù mạch", only show indicator 62 in group 27
    if (indicator62 == "Phù mạch") {
      print(
          "[MedicalFormCubit] 📍 Showing only indicator 62 in group 27 for Phù mạch");
      return {62};
    }

    // Default: show all indicators in group 27
    try {
      final group27 = groups.firstWhere((group) => group.id == 27);
      final allIndicatorIds =
          group27.indicators.map((indicator) => indicator.id).toSet();
      print(
          "[MedicalFormCubit] 📍 Showing all indicators in group 27: $allIndicatorIds");
      return allIndicatorIds;
    } catch (e) {
      print(
          "[MedicalFormCubit] ⚠️ Group 27 not found, returning empty indicators");
      return {};
    }
  }
}
