import 'package:balady_plus/app/core/utils/constants/constants.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../customer_voice_exports.dart' show InquiryViewModel;
import '../../data/general_inquiry_data.dart';

class GeneralInquiryTypeScreen extends StatefulWidget {
  const GeneralInquiryTypeScreen({Key? key}) : super(key: key);

  @override
  State<GeneralInquiryTypeScreen> createState() => _GeneralInquiryTypeDialog();
}

class _GeneralInquiryTypeDialog extends State<GeneralInquiryTypeScreen> {
  late List<CustomerVoiceReportTypeModel> _list;

  @override
  void initState() {
    super.initState();
    _list = [
      CustomerVoiceReportTypeModel(
          code: "INQC-006",
          icon: IconPath.Inq_6Icon,
          key: "",
          title: "Inq_6",
          id: 6),
      CustomerVoiceReportTypeModel(
          code: "INQC-003",
          icon: IconPath.Inq_3Icon,
          key: "",
          title: "Inq_3",
          id: 3),
      CustomerVoiceReportTypeModel(
          code: "INQC-014",
          icon: IconPath.Inq_14Icon,
          key: "",
          title: "Inq_14",
          id: 14),
      CustomerVoiceReportTypeModel(
          code: "INQC-011",
          icon: IconPath.Inq_11Icon,
          key: "",
          title: "Inq_11",
          id: 11),
      CustomerVoiceReportTypeModel(
          code: "INQC-016",
          icon: IconPath.Inq_3Icon,
          key: "",
          title: "Inq_16",
          id: 15)
    ];

    CommonFunctions.sendUXCamEvent(UXCamEvents.typeServiceGeneralInquiries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("select_category".tr()),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.only(
            bottom: Constants.mediumPadding,
            left: Constants.semiMediumPadding,
            right: Constants.semiMediumPadding,
            top: Constants.smallPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 19.0,
          mainAxisSpacing: 18.0,
        ),
        itemCount: _list.length,
        itemBuilder: (context, index) => GeneralInquiryTypeWidget(_list[index]),
      ),
    );
  }
}

class GeneralInquiryTypeWidget extends StatelessWidget {
  CustomerVoiceReportTypeModel inqTypesModel;

  GeneralInquiryTypeWidget(this.inqTypesModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          bool isSuccess = await locator<InquiryViewModel>()
              .getAllSplClassifications(inqTypesModel);

          //MM
          if (isSuccess) {
            NavigationService.navigatorKey.currentState!.pushNamed(
                RouteName.generalInquiryPage,
                arguments: inqTypesModel);
          }
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
