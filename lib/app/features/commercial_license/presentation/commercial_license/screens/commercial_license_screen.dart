import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../commercial_license_exports.dart';

class CommercialLicenseScreen extends StatelessWidget {
  const CommercialLicenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CommercialLicenseBloc(),
        ),
        BlocProvider(
          create: (context) => WorkTimesCubit(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => CrStep1ApplicantDataCubit()..getRecordInfo(),
        ),
        BlocProvider(
          create: (context) => CrStep2ActivityDataCubit(),
        ),
      ],
      child: const CommercialLicenseBody(),
    );
  }
}
