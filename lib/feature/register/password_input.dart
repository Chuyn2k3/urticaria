import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:urticaria/gen/assets.gen.dart';
import 'package:urticaria/widget/text_field/input_text_field.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput(
      {super.key, required this.hintText, this.controller, this.validator});
  final String hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  var obscuredTextField = true;
  @override
  Widget build(BuildContext context) {
    return InputTextField(
      hintText: widget.hintText,
      maxLine: 1,
      textController: widget.controller,
      validator: widget.validator,
      textAlign: TextAlign.left,
      obscureText: obscuredTextField,
      iconButton: IconButton(
        onPressed: () {
          setState(() {
            obscuredTextField = !obscuredTextField;
          });
        },
        icon: obscuredTextField
            ? SvgPicture.asset(Assets.icons.eyeclose)
            : SvgPicture.asset(Assets.icons.eyeopen),
      ),
    );
  }
}
