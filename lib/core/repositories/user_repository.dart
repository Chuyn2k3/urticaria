import 'package:get_it/get_it.dart';
import 'package:urticaria/constant/config.dart';
import 'package:urticaria/core/base/base_response.dart';
import 'package:urticaria/core/services/user_service.dart';
import 'package:urticaria/models/register_request.dart';
import 'package:urticaria/models/user/credential_model.dart';
import 'package:urticaria/utils/shared_preferences_manager.dart';

abstract class UserRepository {
  Future<BaseResponse<CredentialModel>> login(String phone, String password);
  Future<BaseResponse<CredentialModel>> registerAccount(
      RegisterRequest registerRequest);
}

class UserRepositoryImpl implements UserRepository {
  final UserServices userServices;
  const UserRepositoryImpl({required this.userServices});

  @override
  Future<BaseResponse<CredentialModel>> login(
      String phone, String password) async {
    try {
      final request = {
        'phone': phone,
        'password': password,
      };
      final result = await userServices.loginUser(request);
      GetIt.instance
          .get<SharedPreferencesManager>()
          .putString(AppConfig.accessTokenKey, result.data?.token ?? "");

      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponse<CredentialModel>> registerAccount(
      RegisterRequest registerRequest) async {
    try {
      final result = await userServices.registerAccount(registerRequest);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
