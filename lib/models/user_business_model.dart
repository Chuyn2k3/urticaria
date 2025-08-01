import 'package:json_annotation/json_annotation.dart';

part 'user_business_model.g.dart';

@JsonSerializable()
class UserBusinessModel {
  final String? id;
  final String? ma;
  final String? hoTen;
  final int? gioiTinh;
  final String? ngaySinh;
  final String? ngaySinhText;
  final String? diaChiLienHe;
  final String? dienThoai;
  final String? passWord;
  final String? passWordDefault;
  final String? lastTimeUpdate;
  final String? soCmt;
  final String? thuDienTu;
  final String? tuoi;
  final String? maTheBHYT;

  @JsonKey(name: 'diaChiHanhChinh_ID')
  final String? diaChiHanhChinhId;

  UserBusinessModel({
    this.id,
    this.ma,
    this.hoTen,
    this.gioiTinh,
    this.ngaySinh,
    this.ngaySinhText,
    this.diaChiLienHe,
    this.dienThoai,
    this.passWord,
    this.passWordDefault,
    this.lastTimeUpdate,
    this.soCmt,
    this.thuDienTu,
    this.tuoi,
    this.maTheBHYT,
    this.diaChiHanhChinhId,
  });

  factory UserBusinessModel.fromJson(Map<String, dynamic> json) =>
      _$UserBusinessModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserBusinessModelToJson(this);

  factory UserBusinessModel.fake() => UserBusinessModel(
        id: 'U123',
        ma: 'BN001',
        hoTen: 'Nguyễn Văn A',
        gioiTinh: 1,
        ngaySinh: '1990-01-01',
        ngaySinhText: '01/01/1990',
        diaChiLienHe: '123 Đường Lê Lợi, Quận 1, TP.HCM',
        dienThoai: '0909123456',
        passWord: '123456',
        passWordDefault: '123456',
        lastTimeUpdate: '2024-06-01T08:00:00',
        soCmt: '123456789',
        thuDienTu: 'nguyenvana@gmail.com',
        tuoi: '34',
        maTheBHYT: 'BHYT123456',
        diaChiHanhChinhId: 'HC001',
      );
}
