import 'package:dio/dio.dart';
import 'package:urticaria/feature/live/live_model.dart';

import 'agora_config.dart';

var token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NvdW50SWQiOjYsInRva2VuVHlwZSI6MSwibWV0YWRhdGEiOnsicGhvbmUiOiIzNzc4MzMxODAiLCJmdWxsbmFtZSI6Ikhvw6BuZyBUaOG7iyBDw7pjICJ9LCJpYXQiOjE3NTc0MzIyNjgsImV4cCI6MTc1NzUxODY2OH0.hRPUAEHqnUV5MNbur72WnP-u6koQOXQ5dvjeojxZtds";

class LiveApi {
  final Dio _dio;

  LiveApi()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://hospital.huyit.lat/api/v1/patient',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
        );

  /// POST /livestream
  Future<LiveResponse?> getLive() async {
    try {
      final response = await _dio.get('/live');
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
      final response = await _dio.get(
        '/live/$liveId/join',
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
