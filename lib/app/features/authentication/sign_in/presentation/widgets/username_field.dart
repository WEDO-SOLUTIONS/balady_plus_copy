import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, ReadContext;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextFieldWidget;
import '../../sign_in_exports.dart'
    show SignInBloc, SignInOnChangeInfo, SignInState;

class SignInUsernameField extends StatelessWidget {
  const SignInUsernameField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (_, state) => CustomTextFieldWidget(
        label: fieldLabel,
        hintText: fieldHint,
        isRequired: true,
        autofillHints: const [AutofillHints.name],
        textInputAction: TextInputAction.next,
        prefixIcon: const Icon(Icons.person),
        errorText: state.usernameErrorText,
        onChanged: (username) => context
            .read<SignInBloc>()
            .add(SignInOnChangeInfo(username: username)),
      ),
    );
  }

  String get fieldLabel => "username".tr();
  String get fieldHint => "enter ".tr() + fieldLabel;
}
