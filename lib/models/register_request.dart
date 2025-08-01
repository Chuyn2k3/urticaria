import 'package:json_annotation/json_annotation.dart';
part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  @JsonKey(name: "fullname")
  String fullName;
  String phone;
  String password;
  String idToken;
  String? email;
  String? birthday; // "1990-01-01"
  String? gender; // MALE / FEMALE
  String? address;

  RegisterRequest({
    required this.fullName,
    required this.phone,
    required this.password,
    required this.idToken,
    this.email,
    this.birthday,
    this.gender,
    this.address,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
