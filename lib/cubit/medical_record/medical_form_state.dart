import 'package:equatable/equatable.dart';

import '../../core/base/base_response.dart';
import '../../models/vital_group/vital_group.dart';

abstract class MedicalFormState extends Equatable {
  const MedicalFormState();

  @override
  List<Object?> get props => [];
}

class MedicalFormInitial extends MedicalFormState {}

class MedicalFormLoading extends MedicalFormState {}

class MedicalFormLoaded extends MedicalFormState {
  final List<VitalGroup> groups;
  final Map<int, dynamic> answers;

  const MedicalFormLoaded({required this.groups, required this.answers});

  MedicalFormLoaded copyWith({
    List<VitalGroup>? groups,
    Map<int, dynamic>? answers,
  }) {
    return MedicalFormLoaded(
      groups: groups ?? this.groups,
      answers: answers ?? this.answers,
    );
  }

  @override
  List<Object?> get props => [groups, answers];
}

class MedicalFormSubmitting extends MedicalFormLoaded {
  const MedicalFormSubmitting({
    required super.groups,
    required super.answers,
  });
}

class MedicalFormSubmittedSuccess extends MedicalFormLoaded {
  final BaseResponse<dynamic> response;

  const MedicalFormSubmittedSuccess({
    required super.groups,
    required super.answers,
    required this.response,
  });

  @override
  List<Object?> get props => [groups, answers, response];
}

// ✨ Sửa MedicalFormError để giữ lại dữ liệu form
class MedicalFormError extends MedicalFormLoaded {
  final String message;

  const MedicalFormError({
    required this.message,
    required super.groups,
    required super.answers,
  });

  @override
  List<Object?> get props => [message, groups, answers];
}
