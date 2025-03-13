import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/pages/check_debts/commercial_debts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import '../../../commercial_license_exports.dart';
import '../../../domain/entities/request_info_arragments.dart';
import '../../step10/bloc/cr_step10_addetional_data_cubit.dart';
import '../../step11/bloc/cr_step11_attachment_data_cubit.dart';
import '../../step12/bloc/cr_step12_sadad_cubit.dart';
import '../../step13/bloc/cr_step13_review_cubit.dart';
import '../../step3/bloc/map_bloc.dart';
import '../../step4/bloc/cr_step4_shop_data_cubit.dart';
import '../../step5/bloc/cr_step5_attachment_data_cubit.dart';
import '../../step6/bloc/cr_step6_establishment_data_cubit.dart';

class CommercialLicenseScreen extends StatefulWidget {
  const CommercialLicenseScreen({Key? key}) : super(key: key);

  @override
  State<CommercialLicenseScreen> createState() =>
      _CommercialLicenseScreenState();
}

class _CommercialLicenseScreenState extends State<CommercialLicenseScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.startServiceIssueACommercialLicense);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.CommercialLicense_Open_Create_Details_Event);
  }

  @override
  Widget build(BuildContext context) {
    RequestInfoArragments? requestData = ModalRoute.of(context)!.settings.arguments as RequestInfoArragments?;

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
      child: CommercialLicenseBody(
        requestData: requestData,
      ),
    );
  }
}
