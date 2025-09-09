import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urticaria/constant/config.dart';
import 'package:urticaria/cubit/auth/auth_cubit.dart';
import 'package:urticaria/cubit/login/login_cubit.dart';
import 'package:urticaria/cubit/profile/profile_cubit.dart';
import 'package:urticaria/feature/signup/signup_form_register.dart';
import 'package:urticaria/router/go_router_name_enum.dart';
import 'package:urticaria/utils/shared_preferences_manager.dart';
import 'package:urticaria/utils/snack_bar.dart';
import 'package:urticaria/utils/validator.dart';
import 'package:urticaria/widget/text_field/glass_input_field.dart';
import '../constant/color.dart';
import '../feature/bottom_nav/bottom_nav_page.dart';
import '../widget/form_input_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final _formKey = GlobalKey<FormState>();
  final sharedPreferences = GetIt.instance<SharedPreferencesManager>();
  final _cubitLogin = LoginCubit();
  @override
  void initState() {
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _animationController.forward();
    checkAutoLogin();
    super.initState();
  }

  void checkAutoLogin() async {
    final sp = GetIt.instance.get<SharedPreferencesManager>();
    final user = sp.getString(AppConfig.SL_USERNAME);
    final pass = sp.getString(AppConfig.SL_PASSWORD);
    if (user != null && pass != null) {
      _cubitLogin.handleLogin(phone: user, password: pass);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => _cubitLogin,
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: BlocListener<LoginCubit, LoginAppState>(
            listener: (context, state) {
              if (state is LoggedInState) {
                sharedPreferences.putString(
                    AppConfig.SL_USERNAME, _phoneController.text);
                sharedPreferences.putString(
                    AppConfig.SL_USERNAME, _phoneController.text);
                context.read<AuthCubit>().login();
                context.read<ProfileUserCubit>().getProfile();
              } else if (state is LoginErrorState) {
                context.showSnackBarFail(text: state.error);
              }
            },
            child: Container(
              height: screenHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0066CC),
                    Color(0xFF004499),
                    Color(0xFF002266),
                  ],
                  stops: [0.0, 0.6, 1.0],
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.08),

                      // Logo và title section
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            // Logo với glassmorphism effect
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.whiteColor.withOpacity(0.3),
                                    AppColors.whiteColor.withOpacity(0.1),
                                  ],
                                ),
                                border: Border.all(
                                  color: AppColors.whiteColor.withOpacity(0.2),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.local_hospital_rounded,
                                size: 50,
                                color: AppColors.whiteColor,
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Title
                            const Text(
                              'Bệnh viện Da liễu TW',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 32,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 1.2,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Chăm sóc sức khỏe da của bạn',
                              style: TextStyle(
                                color: AppColors.whiteColor.withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // Login form với glassmorphism
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.whiteColor.withOpacity(0.25),
                                  AppColors.whiteColor.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: AppColors.whiteColor.withOpacity(0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Welcome text
                                const Text(
                                  'Chào mừng trở lại',
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  'Đăng nhập để tiếp tục',
                                  style: TextStyle(
                                    color:
                                        AppColors.whiteColor.withOpacity(0.7),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),

                                const SizedBox(height: 40),

                                // Custom form inputs
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      GlassInputField(
                                        controller: _phoneController,
                                        hint: 'Số điện thoại',
                                        icon: Icons.phone_rounded,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) =>
                                            Validator.validatePhoneNumber(
                                                value ?? ""),
                                      ),
                                      const SizedBox(height: 20),
                                      GlassInputField(
                                        controller: _passwordController,
                                        hint: 'Mật khẩu',
                                        icon: Icons.lock_rounded,
                                        isPassword: true,
                                        validator: (value) =>
                                            Validator.validatePassword(
                                                password: value ?? ""),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 30),

                                // Login button
                                BlocBuilder<LoginCubit, LoginAppState>(
                                  builder: (context, state) {
                                    return Container(
                                      width: double.infinity,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.circular(28),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.whiteColor
                                                .withOpacity(0.3),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: state is LoginInLoadingState
                                            ? null
                                            : () {
                                                if (_formKey.currentState
                                                        ?.validate() ??
                                                    false) {
                                                  _cubitLogin.handleLogin(
                                                    phone:
                                                        _phoneController.text,
                                                    password:
                                                        _passwordController
                                                            .text,
                                                  );
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.whiteColor,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(28),
                                          ),
                                        ),
                                        child: state is LoginInLoadingState
                                            ? const CircularProgressIndicator(
                                                color: Color(0xFF0066CC))
                                            : const Text(
                                                'Đăng nhập',
                                                style: TextStyle(
                                                  color: Color(0xFF0066CC),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 16),

                                // Register button
                                Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.whiteColor.withOpacity(0.2),
                                        AppColors.whiteColor.withOpacity(0.1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                      color:
                                          AppColors.whiteColor.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      GoRouter.of(context).push(
                                          GoRouterName.register.routePath);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                    ),
                                    child: const Text(
                                      'Đăng ký',
                                      style: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Forgot password
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      // Handle forgot password
                                    },
                                    child: Text(
                                      'Quên mật khẩu?',
                                      style: TextStyle(
                                        color: AppColors.whiteColor
                                            .withOpacity(0.8),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      // Footer
                      Text(
                        '© 2024 Bệnh viện Da liễu TW',
                        style: TextStyle(
                          color: AppColors.whiteColor.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
