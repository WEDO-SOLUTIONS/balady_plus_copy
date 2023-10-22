import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../renew_commercial_license_exports.dart';

class RenewCommercialLicenseScreen extends StatelessWidget {
  const RenewCommercialLicenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RenewCommercialLicenseBloc(),
        ),
      ],
      child: const CommercialLicenseBody(),
    );
  }
}
