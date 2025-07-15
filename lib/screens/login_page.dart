import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../widget/form_input_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {

  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Column(
                children: [
                  SafeArea(
                    child: Image.asset('assets/images/login_bg.jpg'),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        FormInputWidget(
                          passwordController: _passwordController,
                          phoneController: _phoneController,
                        ),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 32.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  }
}
