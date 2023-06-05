import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomElevatedButtonWidget;
import '../../sign_in_exports.dart' show OnSignIn, SignInBloc;

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButtonWidget(
      btnMargin: const EdgeInsets.symmetric(vertical: 64.0),
      text: "signInButton".tr(),
      onPressed: () => context.read<SignInBloc>().add(const OnSignIn()),
    );
  }
}
