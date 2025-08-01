import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urticaria/core/repositories/user_repository.dart';
import 'package:urticaria/core/services/user_service.dart';
import 'package:urticaria/cubit/auth/auth_cubit.dart';
import 'package:urticaria/utils/http_services.dart';
import 'package:urticaria/utils/navigation_service.dart';
import 'package:urticaria/utils/shared_preferences_manager.dart';

GetIt serviceLocator = GetIt.instance;

Future<void> setupLocator() async {
  //serviceLocator
  serviceLocator.registerLazySingleton(() => NavigationService());
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(
      () => SharedPreferencesManager(sharedPreferences: sharedPreferences));

  final Dio dio =
      await setupDio(baseUrl: "https://hospital.huyit.lat", isHaveToken: true);

  serviceLocator.registerLazySingleton(() => AuthCubit());

  serviceLocator.registerLazySingleton<UserServices>(() => UserServices(dio));
//

  serviceLocator.registerFactory<UserRepository>(
      () => UserRepositoryImpl(userServices: serviceLocator<UserServices>()));
}
