// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      fullName: json['fullname'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      idToken: json['idToken'] as String,
      email: json['email'] as String?,
      birthday: json['birthday'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'fullname': instance.fullName,
      'phone': instance.phone,
      'password': instance.password,
      'idToken': instance.idToken,
      'email': instance.email,
      'birthday': instance.birthday,
      'gender': instance.gender,
      'address': instance.address,
    };
