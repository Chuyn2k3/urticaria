import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ProfileTileType {
  settings,
  changePassword,
  qrCode,
  hotline,
}

extension ProfileTileTypeExtension on ProfileTileType {
  IconData get icon {
    switch (this) {
      case ProfileTileType.settings:
        return Icons.settings_outlined;
      case ProfileTileType.changePassword:
        return Icons.lock_outline;
      case ProfileTileType.qrCode:
        return Icons.qr_code;
      case ProfileTileType.hotline:
        return Icons.phone_outlined;
    }
  }

  String get label {
    switch (this) {
      case ProfileTileType.settings:
        return 'Thiết lập';
      case ProfileTileType.changePassword:
        return 'Cài đặt mật khẩu';
      case ProfileTileType.qrCode:
        return 'Mã QR cá nhân';
      case ProfileTileType.hotline:
        return 'Hotline';
    }
  }
}
