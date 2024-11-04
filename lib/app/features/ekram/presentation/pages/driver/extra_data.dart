import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';

import 'package:balady_plus/app/features/ekram/presentation/blocs/driver_extra_data_bloc/extra_data_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';

import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';

import '../../../../_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../_shared_feature_/presentation/dialogs/dialog_header.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../blocs/driver_identical_bloc/identical_list_bloc.dart';
import '../../widgets/driver/extra_data_card_widget.dart';


class DriverExtraDataPage extends StatefulWidget {

  ExtraDataBloc bloc;
   DriverExtraDataPage({Key? key,required this.bloc}) : super(key: key);

  @override
  State<DriverExtraDataPage> createState() =>
      _DriverExtraDataPageState();
}

class _DriverExtraDataPageState
    extends State<DriverExtraDataPage> {

  IdenticalListBloc? identicalListBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.detailsServiceFuneralCarDriver);
  }

  @override
  Widget build(BuildContext context) {

    identicalListBloc ??= sl();


    return    Scaffold(
      backgroundColor: AppColor.white2,

      body: Padding(
        padding: const EdgeInsets.only(top: 16.0,right: 16,left: 16,bottom: 30),
        child:
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CustomVerticalSpace(height: 10),
                    DialogHeader(
                      title: "extra_data".tr(),
                    ),


                    ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount:
                      identicalListBloc?.state.details?.length ??
                          0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return ExpandableCard(
                            title: "${("cemetry_deceassed_info").tr()} ${index+1}",
                            icon: null,
                            children:
                            [


                              ExtraDataCardWidget(
                                bloc: widget.bloc,
                                item: identicalListBloc!.state.details![index],


                              ),
                            ]);
                      },
                    ),

                    Constants.verticalSpaceSmall,
                  ],
                ),
              ),
            ),

          ],
        ),



      ),
    );



  }
}
