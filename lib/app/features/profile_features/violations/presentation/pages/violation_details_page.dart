import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../violations_exports.dart';

class ViolationsDetailsPage extends StatefulWidget {
  const ViolationsDetailsPage({
    super.key,
  });

  @override
  State<ViolationsDetailsPage> createState() => _ViolationsDetailsPageState();
}

class _ViolationsDetailsPageState extends State<ViolationsDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(UXCamEvents.openViolationsDetails);
  }

  @override
  Widget build(BuildContext context) {
    ViolationsEntity violationsEntity =
        ModalRoute.of(context)!.settings.arguments as ViolationsEntity;

    return BlocProvider(
      create: (context) =>
          ViolationDetailsBloc(violationsEntity: violationsEntity)
            ..add(GetViolationDetailsEvent(
                id: violationsEntity.hashingViolationNumber ?? '',
                applicationId: violationsEntity.applicationId ?? "")),
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: "transaction_details_data".tr(),
        ),
        body: ViolationDetailBody(
          violationsEntity: violationsEntity,
        ),
      ),
    );
  }
}
