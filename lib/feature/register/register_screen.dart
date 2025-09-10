import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:urticaria/cubit/register_account/register_account_cubit.dart';
import 'package:urticaria/feature/register/register_input_enum.dart';
import 'package:urticaria/models/register_request.dart';
import 'package:urticaria/router/go_router_name_enum.dart';
import 'package:urticaria/utils/common_app.dart';
import 'package:urticaria/utils/icons.dart';
import 'package:urticaria/utils/snack_bar.dart';
import 'package:urticaria/widget/app_button.dart';
import 'package:urticaria/widget/appbar/custom_app_bar.dart';
import 'package:urticaria/widget/base_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final items = RegisternputEnum.values
      .map((e) => RegisternputEnumConfig.create(type: e))
      .toList();
  Widget? _childBody;

  @override
  Widget build(BuildContext context) {
    _childBody ??= _bodyWidget(context);
    return _childBody ?? _bodyWidget(context);
  }

  Widget _bodyWidget(BuildContext context) {
    return Form(
      key: formKey,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BaseScaffold(
            appBar: CustomAppbar.basic(
              onTap: () => GoRouter.of(context).pop(context),
              isLeading: true,
              title: "Đăng ký",
            ),
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ...List.generate(items.length,
                      (index) => items[index].widgetItem(context)),
                  BlocConsumer<RegisterAccountCubit, RegisterAccountState>(
                    listener: (context, state) async {
                      if (state is RegisterAccountSuccessState) {
                        context.showSnackBarSuccess(
                            text: "Đăng ký thành công", positionTop: true);
                        await Future.delayed(Duration(milliseconds: 1500));
                        GoRouter.of(context).push(GoRouterName.login.routePath);
                      } else if (state is RegisterAccountErrorState) {
                        context.showSnackBarFail(text: state.error);
                      }
                    },
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AppButton(
                          title: state is RegisterAccountLoadingState
                              ? "Đang đăng ký..."
                              : "ĐĂNG KÝ",
                          onPressed: state is RegisterAccountLoadingState
                              ? () {}
                              : () => _eventRegisterAccount(context),
                          iconRight: IconEnums.user_plus,
                          isLeftGradient: true,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(child: _textRegister(context)),
                  const SizedBox(height: 24),
                ]))),
      ),
    );
  }

  void _eventRegisterAccount(BuildContext context) {
    var form = formKey.currentState!;
    if (!form.validate()) {
      return;
    }
    form.save();
    final map = RegisternputEnumConfig.createRequestValueMap(items);

    context.read<RegisterAccountCubit>().registerAccount(
          RegisterRequest(
            fullName: map['fullname'] ?? '',
            phone: map['phone'] ?? '',
            password: map['password'] ?? '',
            idToken: "9999", // Bắt buộc lấy từ Firebase Auth
            email: map['email'],
            birthday: map['birthday'],
            gender: map['gender'],
            address: map['address'],
          ),
        );
  }

  RichText _textRegister(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: textTheme.t16R.copyWith(color: colorApp.blue),
            children: [
          TextSpan(
              text: "Bạn đã có tài khoản? ",
              style: textTheme.t16R.copyWith(color: colorApp.labelPrimary)),
          TextSpan(
            text: "Đăng nhập",
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                GoRouter.of(context).pop();
              },
          )
        ]));
  }
}
