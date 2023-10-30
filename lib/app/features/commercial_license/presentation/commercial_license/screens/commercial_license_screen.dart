import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../commercial_license_exports.dart';
import '../../step10/bloc/cr_step10_addetional_data_cubit.dart';
import '../../step11/bloc/cr_step11_attachment_data_cubit.dart';
import '../../step12/bloc/cr_step12_sadad_cubit.dart';
import '../../step13/bloc/cr_step13_review_cubit.dart';
import '../../step3/bloc/map_bloc.dart';
import '../../step4/bloc/cr_step4_shop_data_cubit.dart';
import '../../step5/bloc/cr_step5_attachment_data_cubit.dart';
import '../../step6/bloc/cr_step6_establishment_data_cubit.dart';

class CommercialLicenseScreen extends StatelessWidget {
  const CommercialLicenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
        BlocProvider(
          create: (context) => MapBloc(),
        ),
        BlocProvider.value(
          value: sl<CommercialLicenseBloc>(),
        ),
        BlocProvider(
          create: (context) => CrStep4ShopDataCubit(),
        ),
        BlocProvider(
          create: (context) => CRStep5AttachmentCubit(),
        ),
        BlocProvider(
          create: (context) => CRStep6EstablishmentCubit(),
        ),
        BlocProvider(
          create: (context) => CRStep11AttachmentCubit(),
        ),
        BlocProvider(create: (context) => CRStep10AddetionalDataCubit()),
        BlocProvider(
          create: (context) => CrStep12SadadCubit(),
        ),
        BlocProvider(
          create: (context) => CrStep13ReviewDataCubit(),
        ),
      ],
      child: const CommercialLicenseBody(),
    );
  }
}
