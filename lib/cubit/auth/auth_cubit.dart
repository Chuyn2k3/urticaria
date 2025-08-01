import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:urticaria/constant/config.dart';
import 'package:urticaria/utils/shared_preferences_manager.dart';

part 'auth_state.dart';

GetIt sl = GetIt.instance;

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  void login() async {
    emit(AuthState(isLogin: true));
  }

  void logout() {
    final spManager = GetIt.instance.get<SharedPreferencesManager>();
    spManager.remove(AppConfig.SL_USERNAME);
    spManager.remove(AppConfig.SL_PASSWORD);
    spManager.remove(AppConfig.accessTokenKey);
    spManager.remove(AppConfig.idTokenKey);
    emit(AuthState(isLogin: false));
  }

  // void checkLogin() async {
  //   final isExpired = await isTokenExpired();
  //   if (isExpired) {
  //     logout();
  //   } else {
  //     login();
  //   }
  // }

  // Future<void> deleteAccount() async {
  //   await sl.get<UserRepository>().deleteAccount();
  //   logout();
  // }
}
