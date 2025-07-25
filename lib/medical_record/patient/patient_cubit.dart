import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/medical_record/patient/patient_state.dart';

class PatientProfileCubit extends Cubit<PatientProfileState> {
  PatientProfileCubit() : super(PatientProfileState());

  void updateProfile({
    required String name,
    required String birthday,
    required String address,
    required String phone,
    required String email,
  }) {
    emit(PatientProfileState(
      name: name,
      birthday: birthday,
      address: address,
      phone: phone,
      email: email,
    ));
  }
}
