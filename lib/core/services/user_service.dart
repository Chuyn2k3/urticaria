import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:urticaria/core/base/base_response.dart';
import 'package:urticaria/models/register_request.dart';
import 'package:urticaria/models/user/credential_model.dart';

part 'user_service.g.dart';

@RestApi()
abstract class UserServices {
  factory UserServices(Dio dio, {String baseUrl}) = _UserServices;
  @POST("/api/v1/auth/patient/login")
  Future<BaseResponse<CredentialModel>> loginUser(
      @Body() Map<String, dynamic> request);

  @POST("/api/v1/auth/patient/register")
  Future<BaseResponse<CredentialModel>> registerAccount(
      @Body() RegisterRequest registerRequest);
}
