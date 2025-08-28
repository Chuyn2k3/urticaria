import 'package:equatable/equatable.dart';
import 'package:urticaria/models/vital_group/vital_group.dart';
import 'package:urticaria/core/base/base_response.dart';

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

class MedicalFormError extends MedicalFormState {
  final String message;
  const MedicalFormError(this.message);

  @override
  List<Object?> get props => [message];
}
