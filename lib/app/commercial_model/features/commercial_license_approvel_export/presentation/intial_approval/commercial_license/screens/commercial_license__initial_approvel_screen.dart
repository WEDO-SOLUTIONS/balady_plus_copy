import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/pages/check_debts/commercial_debts_screen.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step1/bloc/step1_applicant_data_export_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step2/bloc/step2_activity_data_export_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import '../../step3/bloc/step3_conclusion_cubit.dart';
import '../blocs/commercial_license_initial_Approval_bloc.dart';
import '../widgets/commercial_license_body.dart';


class CommercialLicenseInitialApprovelScreen extends StatefulWidget {
  const CommercialLicenseInitialApprovelScreen({Key? key}) : super(key: key);

  @override
  State<CommercialLicenseInitialApprovelScreen> createState() =>
      _CommercialLicenseInitialApprovelScreenState();
}

class _CommercialLicenseInitialApprovelScreenState extends State<CommercialLicenseInitialApprovelScreen> {
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
    int? requestId = ModalRoute.of(context)!.settings.arguments as int?;





    return MultiBlocProvider(
      providers: [

        BlocProvider(
          lazy: false,
          create: (context) => Step1ApplicantDataExportCubit()..initialApprovalApply(requestId),
        ),
        BlocProvider(
          create: (context) => Step2ActivityDataExportCubit(),
        ),


        BlocProvider.value(
          value: sl<CommercialLicenseInitialAprrovalBloc>(),
        ),
        BlocProvider(
          create: (context) => Step3ConclusionCubit(),
        ),

        // BlocProvider(
        //   create: (context) => WorkTimesCubit(),
        // ),

        // BlocProvider(
        //   create: (context) => CrStep4ShopDataCubit(),
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
      child: InitialApprovalLicenseBody(
        requestId: requestId,
      ),
    );
  }
}
