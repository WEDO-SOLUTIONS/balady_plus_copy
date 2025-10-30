import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/pages/check_debts/commercial_debts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import '../../../renew_commercial_license_exports.dart';

class RenewCommercialLicenseScreen extends StatefulWidget {
  const RenewCommercialLicenseScreen({Key? key}) : super(key: key);

  @override
  State<RenewCommercialLicenseScreen> createState() =>
      _RenewCommercialLicenseScreenState();
}

class _RenewCommercialLicenseScreenState
    extends State<RenewCommercialLicenseScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.RenewCommercialLicense_Open_Create_Details_Event);
  }

  @override
  Widget build(BuildContext context) {
    int requestId = ModalRoute.of(context)!.settings.arguments as int;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RenewCommercialLicenseBloc(
            requestId: requestId,
          )..add(const GetRenewYearsEvent()),
        ),
      ],
      child: const CommercialLicenseBody(),
    );
  }
}
