import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urticaria/core/repositories/appointment_repository.dart';
import 'package:urticaria/core/repositories/medical_record_repository.dart';
import 'package:urticaria/core/repositories/urticaria_repository.dart';
import 'package:urticaria/core/repositories/user_repository.dart';
import 'package:urticaria/core/services/appointment_service.dart';
import 'package:urticaria/core/services/medical_record_service.dart';
import 'package:urticaria/core/services/urticaria_api_service.dart';
import 'package:urticaria/core/services/user_service.dart';
import 'package:urticaria/cubit/Internet/internet_cubit.dart';
import 'package:urticaria/cubit/auth/auth_cubit.dart';
import 'package:urticaria/cubit/login/login_cubit.dart';
import 'package:urticaria/cubit/profile/profile_cubit.dart';
import 'package:urticaria/feature/medical_record_v2/cubits/acute_urticaria/acute_urticaria_cubit.dart';
import 'package:urticaria/feature/medical_record_v2/cubits/chronic_followup/chronic_followup_cubit.dart';
import 'package:urticaria/feature/medical_record_v2/cubits/chronic_initital/chronic_initial_cubit.dart';
import 'package:urticaria/utils/http_services.dart';
import 'package:urticaria/utils/navigation_service.dart';
import 'package:urticaria/utils/shared_preferences_manager.dart';

import '../core/services/firebase_service/remote_config_service.dart';

GetIt serviceLocator = GetIt.instance;

Future<void> setupLocator() async {
  //serviceLocator
  serviceLocator.registerLazySingleton(() => NavigationService());
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => ProfileUserCubit());
  serviceLocator.registerLazySingleton(
      () => SharedPreferencesManager(sharedPreferences: sharedPreferences));

  final url = await FireBaseRemoteConfigService.getSavedUrl();
  final Dio dio = await setupDio(
      baseUrl: url ?? "https://hospital.huyit.lat", isHaveToken: true);

  serviceLocator.registerLazySingleton(() => AuthCubit());
  serviceLocator.registerLazySingleton(() => LoginCubit());
  serviceLocator.registerLazySingleton(() => InternetCubit());
  serviceLocator.registerLazySingleton<UserServices>(() => UserServices(dio));
  // sl.registerLazySingleton<UrticariaApiService>(
  //   () => UrticariaApiService(dio),
  // );
  // serviceLocator.registerLazySingleton<UrticariaRepository>(
  //   () => UrticariaRepositoryImpl(sl<UrticariaApiService>()),
  // );

  // Cubits
  serviceLocator.registerFactory<AcuteUrticariaCubit>(
    () => AcuteUrticariaCubit(),
  );

  serviceLocator.registerFactory<ChronicInitialCubit>(
    () => ChronicInitialCubit(),
  );

  serviceLocator.registerFactory<ChronicFollowupCubit>(
    () => ChronicFollowupCubit(),
  );
  serviceLocator.registerFactory<UserRepository>(
      () => UserRepositoryImpl(userServices: serviceLocator<UserServices>()));
  serviceLocator
      .registerLazySingleton<AppointmentService>(() => AppointmentService(dio));

  // register repository
  serviceLocator.registerLazySingleton<AppointmentRepository>(() =>
      AppointmentRepositoryImpl(service: serviceLocator<AppointmentService>()));

  serviceLocator.registerLazySingleton<MedicalRecordService>(
      () => MedicalRecordService(dio));

  // register repository
  serviceLocator.registerLazySingleton<MedicalRecordRepository>(() =>
      MedicalRecordRepositoryImpl(
          service: serviceLocator<MedicalRecordService>()));
}
