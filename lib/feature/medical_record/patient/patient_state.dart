class PatientProfileState {
  final String name;
  final String birthday;
  final String address;
  final String phone;
  final String email;
  PatientProfileState({
    this.name = '',
    this.birthday = '',
    this.address = '',
    this.phone = '',
    this.email = '',
  });

  PatientProfileState copyWith({
    String? name,
    String? birthday,
    String? address,
    String? phone,
    String? email,
  }) {
    return PatientProfileState(
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      address: address ?? this.address,
    );
  }
}
