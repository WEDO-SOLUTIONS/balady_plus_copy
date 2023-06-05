import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show WidgetConversion;
import '../../sign_in_exports.dart'
    show
        SignInButton,
        SignInPasswordField,
        SignInPhoneNumberField,
        SignInUsernameField;

class SignInBodyWidget extends StatelessWidget {
  const SignInBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: padding,
      children: const [
        // Phone Number
        SignInPhoneNumberField(),
        // Username
        SignInUsernameField(),
        // Password
        SignInPasswordField(),
        // Button
        SignInButton(),
      ].addPadding(bottom: 16.0),
    );
  }

  EdgeInsetsGeometry get padding =>
      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 54.0);
}
