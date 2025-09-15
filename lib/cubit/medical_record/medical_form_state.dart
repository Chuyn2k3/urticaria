// import 'package:equatable/equatable.dart';
//
// import '../../core/base/base_response.dart';
// import '../../models/vital_group/vital_group.dart';
//
// abstract class MedicalFormState extends Equatable {
//   const MedicalFormState();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class MedicalFormInitial extends MedicalFormState {}
//
// class MedicalFormLoading extends MedicalFormState {}
//
// class MedicalFormLoaded extends MedicalFormState {
//   final List<VitalGroup> groups;
//   final Map<int, dynamic> answers;
//
//   const MedicalFormLoaded({required this.groups, required this.answers});
//
//   MedicalFormLoaded copyWith({
//     List<VitalGroup>? groups,
//     Map<int, dynamic>? answers,
//   }) {
//     return MedicalFormLoaded(
//       groups: groups ?? this.groups,
//       answers: answers ?? this.answers,
//     );
//   }
//
//   @override
//   List<Object?> get props => [groups, answers];
// }
//
// class MedicalFormSubmitting extends MedicalFormLoaded {
//   const MedicalFormSubmitting({
//     required super.groups,
//     required super.answers,
//   });
// }
//
// class MedicalFormSubmittedSuccess extends MedicalFormLoaded {
//   final BaseResponse<dynamic> response;
//
//   const MedicalFormSubmittedSuccess({
//     required super.groups,
//     required super.answers,
//     required this.response,
//   });
//
//   @override
//   List<Object?> get props => [groups, answers, response];
// }
//
// // ✨ Sửa MedicalFormError để giữ lại dữ liệu form
// class MedicalFormError extends MedicalFormLoaded {
//   final String message;
//
//   const MedicalFormError({
//     required this.message,
//     required super.groups,
//     required super.answers,
//   });
//
//   @override
//   List<Object?> get props => [message, groups, answers];
// }
import '../../models/vital_group/vital_group.dart';

abstract class MedicalFormState {}

class MedicalFormInitial extends MedicalFormState {}

class MedicalFormLoading extends MedicalFormState {}

class MedicalFormLoaded extends MedicalFormState {
  final List<VitalGroup> groups;
  final Map<int, dynamic> answers;
  final Set<int> visibleGroupIds; // Store visible group IDs
  final Set<int>
      visibleIndicatorsInGroup12; // Store visible indicator IDs in group 12
  final Set<int>
      visibleIndicatorsInGroup27; // Store visible indicator IDs in group 27

  MedicalFormLoaded({
    required this.groups,
    required this.answers,
    required this.visibleGroupIds,
    required this.visibleIndicatorsInGroup12,
    required this.visibleIndicatorsInGroup27,
  });

  MedicalFormLoaded copyWith({
    List<VitalGroup>? groups,
    Map<int, dynamic>? answers,
    Set<int>? visibleGroupIds,
    Set<int>? visibleIndicatorsInGroup12,
    Set<int>? visibleIndicatorsInGroup27,
  }) {
    return MedicalFormLoaded(
      groups: groups ?? this.groups,
      answers: answers ?? this.answers,
      visibleGroupIds: visibleGroupIds ?? this.visibleGroupIds,
      visibleIndicatorsInGroup12:
          visibleIndicatorsInGroup12 ?? this.visibleIndicatorsInGroup12,
      visibleIndicatorsInGroup27:
          visibleIndicatorsInGroup27 ?? this.visibleIndicatorsInGroup27,
    );
  }
}

class MedicalFormSubmitting extends MedicalFormState {
  final List<VitalGroup> groups;
  final Map<int, dynamic> answers;
  final Set<int> visibleGroupIds;
  final Set<int> visibleIndicatorsInGroup12;
  final Set<int> visibleIndicatorsInGroup27;

  MedicalFormSubmitting({
    required this.groups,
    required this.answers,
    required this.visibleGroupIds,
    required this.visibleIndicatorsInGroup12,
    required this.visibleIndicatorsInGroup27,
  });
}

class MedicalFormSubmittedSuccess extends MedicalFormState {
  final List<VitalGroup> groups;
  final Map<int, dynamic> answers;
  final Set<int> visibleGroupIds;
  final Set<int> visibleIndicatorsInGroup12;
  final Set<int> visibleIndicatorsInGroup27;
  final dynamic response;

  MedicalFormSubmittedSuccess({
    required this.groups,
    required this.answers,
    required this.visibleGroupIds,
    required this.visibleIndicatorsInGroup12,
    required this.visibleIndicatorsInGroup27,
    required this.response,
  });
}

class MedicalFormError extends MedicalFormState {
  final String message;
  final List<VitalGroup> groups;
  final Map<int, dynamic> answers;

  MedicalFormError({
    required this.message,
    required this.groups,
    required this.answers,
  });
}
