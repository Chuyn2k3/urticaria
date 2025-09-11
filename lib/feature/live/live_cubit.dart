import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:urticaria/feature/live/live_model.dart';

import '../../constant/config.dart';
import '../../core/services/firebase_service/remote_config_service.dart';
import '../../utils/shared_preferences_manager.dart';
import 'agora_config.dart';

// var token =
//     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NvdW50SWQiOjYsInRva2VuVHlwZSI6MSwibWV0YWRhdGEiOnsicGhvbmUiOiIzNzc4MzMxODAiLCJmdWxsbmFtZSI6Ikhvw6BuZyBUaOG7iyBDw7pjICJ9LCJpYXQiOjE3NTc0MzIyNjgsImV4cCI6MTc1NzUxODY2OH0.hRPUAEHqnUV5MNbur72WnP-u6koQOXQ5dvjeojxZtds";

class LiveApi {
  final Dio _dio;

  LiveApi()
      : _dio = Dio(
            // BaseOptions(
            //   baseUrl: 'https://hospital.huyit.lat/api/v1/patient',
            //   headers: {
            //     'Content-Type': 'application/json',
            //     'Authorization': 'Bearer $token',
            //   },
            // ),
            );

  /// POST /livestream
  Future<LiveResponse?> getLive() async {
    try {
      final url = await FireBaseRemoteConfigService.getSavedUrl() ??
          'https://hospital.huyit.lat';
      final token = GetIt.instance
          .get<SharedPreferencesManager>()
          .getString(AppConfig.accessTokenKey);
      final response = await _dio.get(
        '$url/api/v1/patient/live',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return LiveResponse.fromJson(response.data);
    } on Exception catch (e) {
      print("POST error: ${e}");
      return null;
    }
  }

  Future<AgoraConfig?> joinLive(
    int liveId,
    int doctorId,
    String channelName,
  ) async {
    try {
      final url = await FireBaseRemoteConfigService.getSavedUrl() ??
          'https://hospital.huyit.lat';
      final token = GetIt.instance
          .get<SharedPreferencesManager>()
          .getString(AppConfig.accessTokenKey);
      final response = await _dio.get(
        '$url/api/v1/patient/live/$liveId/join',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return AgoraConfig.fromJson(response.data).copyWith(
        channelName: channelName,
        doctorId: doctorId,
      );
    } on Exception catch (e) {
      print("POST error: ${e}");
      return null;
    }
  }
}
