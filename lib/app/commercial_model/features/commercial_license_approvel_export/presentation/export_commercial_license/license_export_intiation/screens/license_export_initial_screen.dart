import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/pages/check_debts/commercial_debts_screen.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step1/bloc/step1_applicant_data_export_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step2/bloc/step2_activity_data_export_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import '../../../intial_approval/step3/bloc/step3_conclusion_cubit.dart';
import '../../step1/bloc/step1_shop_data_cubit.dart';
import '../blocs/commercial_license_export_bloc.dart';
import '../widgets/export_license_body.dart';


class LicenseExportInitialScreen extends StatefulWidget {
  const LicenseExportInitialScreen({Key? key}) : super(key: key);

  @override
  State<LicenseExportInitialScreen> createState() =>
      _LicenseExportInitialScreenState();
}

class _LicenseExportInitialScreenState extends State<LicenseExportInitialScreen> {
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
    Map? params = ModalRoute.of(context)!.settings.arguments as Map<String, String?>?;



    int? requestId;
    if(params?["requestNumber"] != null)
      {
        requestId= int.parse(params?["requestNumber"]);
      }

    return MultiBlocProvider(
      providers: [



        BlocProvider.value(
          value: sl<CommercialLicenseExportBloc>(),
        ),
        BlocProvider(
          create: (context) => Step1ShopDataCubit(),
        ),


        // BlocProvider(
        //   create: (context) => WorkTimesCubit(),
        // ),


        // BlocProvider(
        //   create: (context) => CRStep5AttachmentCubit(),
        // ),
        // BlocProvider(
        //   create: (context) => CRStep6EstablishmentCubit(),
        // ),
        // BlocProvider(
        //   create: (context) => CRStep11AttachmentCubit(),
        // ),
        // BlocProvider(create: (context) => CRStep10AddetionalDataCubit()),

        // BlocProvider(
        //   create: (context) => CrStep13ReviewDataCubit(),
        // ),
      ],
      child: ExportLicenseBody(
        requestId: requestId,
      ),
    );
  }
}
