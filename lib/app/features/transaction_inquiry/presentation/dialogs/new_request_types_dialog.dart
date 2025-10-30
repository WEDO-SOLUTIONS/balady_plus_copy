import 'package:balady_plus/app/core/utils/constants/constants.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../data/general_inquiry_data.dart';

class MSRTypeScreen extends StatefulWidget {
  const MSRTypeScreen({Key? key}) : super(key: key);

  @override
  State<MSRTypeScreen> createState() => _MSRTypeDialog();
}

class _MSRTypeDialog extends State<MSRTypeScreen> {
  late List<CustomerVoiceReportTypeModel> _list;

  @override
  void initState() {
    super.initState();
    _list = [
      CustomerVoiceReportTypeModel(
          code: "MSRC-001",
          icon: IconPath.msrRoadsIcon,
          key: "",
          title: "msr_roads",
          id: 1),
      CustomerVoiceReportTypeModel(
          code: "MSRC-002",
          icon: IconPath.msrLightsIcon,
          key: "",
          title: "msr_lights",
          id: 3),
      CustomerVoiceReportTypeModel(
          code: "MSRC-003",
          icon: IconPath.msrParksIcon,
          key: "",
          title: "msr_parks",
          id: 4),
      CustomerVoiceReportTypeModel(
          code: "MSRC-004",
          icon: IconPath.msrCleanIcon,
          key: "",
          title: "msr_clean",
          id: 5),
      CustomerVoiceReportTypeModel(
          code: "MSRC-006",
          icon: IconPath.msrWasteIcon,
          key: "",
          title: "msr_waste",
          id: 6),
    ];

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.typeServiceMunicipalServiceRequest);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.MunicipalServiceRequest_Open_Types_Event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("select_category".tr()),
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height - 50,
        child: GridView.builder(
          padding: const EdgeInsets.only(
            bottom: Constants.mediumPadding,
            left: Constants.semiMediumPadding,
            right: Constants.semiMediumPadding,
            top: Constants.smallPadding,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 19.0,
            mainAxisSpacing: 18.0,
          ),
          itemCount: _list.length,
          itemBuilder: (context, index) => MSRTypeWidget(_list[index]),
        ),
      ),
    );
  }
}

class MSRTypeWidget extends StatelessWidget {
  CustomerVoiceReportTypeModel inqTypesModel;

  MSRTypeWidget(this.inqTypesModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          NavigationService.navigatorKey.currentState!
              .pushNamed(RouteName.newMSRMapPage, arguments: inqTypesModel);
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Container(
            height: 144,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.blackModern100Light,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                SvgPicture.asset(
                  inqTypesModel.icon,
                  width: 46,
                  height: 46,
                ),
                CustomVerticalSpace(height: 16),
                CustomTextWidget(
                  inqTypesModel.title.tr(),
                  fontColor: AppColor.blackModern600Light,
                  fontSize: 14,
                  maxLines: 2,
                  height: 1.3,
                  textAlign: TextAlign.center,
                  fontWeight: AppFontWeight.bold,
                )
              ],
            )));
  }
}
