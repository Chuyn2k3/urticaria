import 'package:json_annotation/json_annotation.dart';

part 'user_info_model.g.dart';

enum Gender { MALE, FEMALE, OTHER }

@JsonSerializable()
class UserInfoModel {
  final int id;
  final String fullname;
  final String phone;
  final String email;
  final String birthday;
  final Gender gender;
  final String address;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserInfoModel({
    required this.id,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.birthday,
    required this.gender,
    required this.address,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
}
