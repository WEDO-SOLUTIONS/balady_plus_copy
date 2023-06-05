import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, ReadContext;

import '../../../../_shared_feature_/shared_feature_exports.dart'
    show PhoneNumberField;
import '../../sign_in_exports.dart'
    show SignInBloc, SignInOnChangeInfo, SignInState;

class SignInPhoneNumberField extends StatelessWidget {
  const SignInPhoneNumberField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.phone != current.phone,
      builder: (_, state) => PhoneNumberField(
        prefixIcon: const Icon(Icons.phone_iphone),
        errorText: state.phoneErrorText,
        onChanged: (phone) =>
            context.read<SignInBloc>().add(SignInOnChangeInfo(phone: phone)),
      ),
    );
  }
}
