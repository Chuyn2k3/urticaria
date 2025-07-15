class PatientProfileState {
  final String name;
  final String birthday;
  final String address;

  PatientProfileState({this.name = '', this.birthday = '', this.address = ''});

  PatientProfileState copyWith({
    String? name,
    String? birthday,
    String? address,
  }) {
    return PatientProfileState(
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      address: address ?? this.address,
    );
  }
}
