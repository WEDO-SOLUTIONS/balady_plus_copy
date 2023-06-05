import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, ReadContext;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomIconButtonWidget, CustomTextFieldWidget;
import '../../sign_in_exports.dart'
    show SignInBloc, SignInOnChangeInfo, SignInOnShowHidePassword, SignInState;

class SignInPasswordField extends StatelessWidget {
  const SignInPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.hidePassword != current.hidePassword,
      builder: (_, state) => CustomTextFieldWidget(
        label: fieldLabel,
        hintText: fieldHint,
        isRequired: true,
        autofillHints: const [AutofillHints.password],
        obsecureText: state.hidePassword,
        textInputAction: TextInputAction.done,
        prefixIcon: const Icon(Icons.key),
        suffixIcon: CustomIconButtonWidget(
          onPressed: () =>
              context.read<SignInBloc>().add(const SignInOnShowHidePassword()),
          icon: state.hidePassword
              ? Icons.remove_red_eye
              : Icons.hide_source_outlined,
          iconSize: 20.0,
        ),
        errorText: state.passwordErrorText,
        onChanged: (password) => context
            .read<SignInBloc>()
            .add(SignInOnChangeInfo(password: password)),
      ),
    );
  }

  String get fieldLabel => "password".tr();
  String get fieldHint => "enter ".tr() + fieldLabel;
}
