import 'package:balady_authorization/src/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/auth_quick_access_cell.dart';
import '../widgets/biometric_cell.dart';

class AuthQuickAccessBiometricWidget extends StatelessWidget {
  const AuthQuickAccessBiometricWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (BuildContext context, state) {
        if (state is AuthenticatedMunicipalityState) {
          return Column(
            children: [
              AuthQuickAccessCell(isQuickAccess: state.loginData.isPasCode),
              SizedBox(height: 8,),
              AuthBiometricCell(isBiometrics: state.loginData.isBiometrics),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
