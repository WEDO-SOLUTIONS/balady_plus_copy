



import 'package:balady_plus/app/features/Commercial_license_transfer/domain/entity/transfer_license_request.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';

import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../domain/entity/permits_response_entity.dart';
import '../bloc/license_tranfer_cubit.dart';
import '../interface/step_interface.dart';

class SucessfullScreen extends StatefulWidget {
  StepInterface stepInterface;
  SucessfullScreen({Key? key,required this.stepInterface}) : super(key: key);

  @override
  State<SucessfullScreen> createState() => _SucessfullScreenState();
}

class _SucessfullScreenState extends State<SucessfullScreen> {
  LicenseTransferCubit? bloc;

  bool isAgree = false;
  List<int> lstPermits = [];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return getBody();

  }
  Widget getBody() {
    bloc= context.read<LicenseTransferCubit>();
    return
      Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15),
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const DrawIconBasedTypeWidget(
              icon:IconPath.successfullIcon,
              iconSize: 120,
            ),
            CustomTextWidget(
              "vd_request_submit".tr(),
              textStyle: AppStyle.complianceTitleStyle,
              maxLines: 4,),
            Text(
              "${"request_number".tr()} ${bloc?.state.applyRequestDataModel?.result} ${"follow_request".tr()}",
              style: AppStyle.personalInfoParameterValueTextStyle
                  .copyWith(fontSize: 12,height: 1.5),
            ),
          ],
    ),
        ),
      );


  }




}
