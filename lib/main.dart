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
import 'package:urticaria/cubit/Internet/internet_cubit.dart';
import 'package:urticaria/cubit/auth/auth_cubit.dart';
import 'package:urticaria/cubit/login/login_cubit.dart';
import 'package:urticaria/cubit/medical_record/medical_form_cubit.dart';
import 'package:urticaria/cubit/profile/profile_cubit.dart';
import 'package:urticaria/di/locator.dart';
import 'package:urticaria/feature/bottom_nav/bottom_nav_page.dart';
import 'package:urticaria/feature/booking/cubit/booking_cubit.dart';
import 'package:urticaria/feature/chatbot/cubit/chatbot_cubit.dart';
import 'package:urticaria/feature/emergency/cubit/emergency_cubit.dart';
import 'package:urticaria/feature/medical_record/patient/patient_cubit.dart';
import 'package:urticaria/feature/medical_record_v2/cubits/acute_urticaria/acute_urticaria_cubit.dart';
import 'package:urticaria/feature/medical_record_v2/cubits/chronic_followup/chronic_followup_cubit.dart';
import 'package:urticaria/feature/medical_record_v2/cubits/chronic_initital/chronic_initial_cubit.dart';
import 'package:urticaria/router/app_router.dart';
import 'package:urticaria/screens/login_page.dart';
import 'package:urticaria/utils/navigation_service.dart';
import 'package:urticaria/utils/shared_preferences_manager.dart';
import 'package:urticaria/utils/snack_bar.dart';

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
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => _authCubit..checkLogin(),
        ),
        BlocProvider(create: (context) => PatientProfileCubit()),
        BlocProvider(create: (context) => BookingCubit()),
        BlocProvider(create: (context) => ChatbotCubit()),
        BlocProvider(create: (context) => EmergencyCubit()),
        BlocProvider(create: (context) => AcuteUrticariaCubit()),
        BlocProvider(create: (context) => ChronicInitialCubit()),
        BlocProvider(create: (context) => ChronicFollowupCubit()),
        BlocProvider(
          create: (context) =>
              serviceLocator<InternetCubit>()..checkConnection(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<ProfileUserCubit>(),
        ),
        BlocProvider(
          create: (context) => MedicalFormCubit(),
        ),
      ],
      child: BlocListener<InternetCubit, InternetState>(
        listener: (context, state) {
          if (state is ConnectedState) {
            GetIt.instance<NavigationService>()
                .navigatorContext
                .showSnackBarSuccess(
                  text: "Đã có kết nối Internet",
                  positionTop: true,
                );
          }
          if (state is NotConnectedState) {
            GetIt.instance<NavigationService>()
                .navigatorContext
                .showSnackBarFail(
                  text: "Mất kết nối Internet",
                  positionTop: true,
                );
          }
        },
        child: ToastificationWrapper(
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
      ),
    );
  }
}
