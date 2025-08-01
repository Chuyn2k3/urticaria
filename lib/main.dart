import 'package:design_system_sl/theme/theme_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:urticaria/constant/config.dart';
import 'package:urticaria/core/colors/app_colors.dart';
import 'package:urticaria/core/theme/app_themes.dart';
import 'package:urticaria/cubit/auth/auth_cubit.dart';
import 'package:urticaria/cubit/login/login_cubit.dart';
import 'package:urticaria/di/locator.dart';
import 'package:urticaria/feature/bottom_nav/bottom_nav_page.dart';
import 'package:urticaria/feature/booking/cubit/booking_cubit.dart';
import 'package:urticaria/feature/chatbot/cubit/chatbot_cubit.dart';
import 'package:urticaria/feature/emergency/cubit/emergency_cubit.dart';
import 'package:urticaria/feature/medical_record/patient/patient_cubit.dart';
import 'package:urticaria/router/app_router.dart';
import 'package:urticaria/screens/login_page.dart';
import 'package:urticaria/utils/shared_preferences_manager.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await setupLocator();
  await Firebase.initializeApp();
  // final prefs = GetIt.instance<SharedPreferencesManager>();
  // final phone = prefs.getString(AppConfig.SL_USERNAME);
  // final password = prefs.getString(AppConfig.SL_PASSWORD);

  // // Nếu có phone và password thì tự động đăng nhập
  // if (phone != null && password != null) {
  //   final authCubit = serviceLocator<LoginCubit>();
  //   await authCubit.handleLogin(
  //       phone: phone, password: password); // Gọi hàm login của bạn
  // }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppRouter appRouter;
  late AuthCubit _authCubit;

  @override
  void initState() {
    _authCubit = serviceLocator<AuthCubit>();
    appRouter = AppRouter(_authCubit);
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (context) => LoginCubit(),
        // ),
        BlocProvider(
          create: (context) => _authCubit,
        ),
        BlocProvider(create: (context) => PatientProfileCubit()),
        BlocProvider(create: (context) => BookingCubit()),
        BlocProvider(create: (context) => ChatbotCubit()),
        BlocProvider(create: (context) => EmergencyCubit()),
      ],
      child:
          // BlocListener<LoginCubit, LoginAppState>(
          //   listener: (context, state) {
          //     if (state is LoggedInState) {
          //       context.read<AuthCubit>().login();
          //     }
          //   },
          ToastificationWrapper(
        child: MaterialApp.router(
          title: 'Urticaria Care',
          themeMode: ThemeMode.light,
          theme: AppTheme.light(context),
          darkTheme: AppTheme.light(context),
          routerConfig: appRouter.router,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling,
              ),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
      // ),
    );
  }
}
