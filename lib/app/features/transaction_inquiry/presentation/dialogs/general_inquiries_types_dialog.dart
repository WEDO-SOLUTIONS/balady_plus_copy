import 'package:balady_plus/app/core/utils/constants/constants.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../customer_voice_exports.dart' show InquiryViewModel;
import '../../data/general_inquiry_data.dart';

class GeneralInquiryTypeDialog extends StatefulWidget {
  const GeneralInquiryTypeDialog({Key? key}) : super(key: key);

  @override
  State<GeneralInquiryTypeDialog> createState() => _GeneralInquiryTypeDialog();
}

class _GeneralInquiryTypeDialog extends State<GeneralInquiryTypeDialog> {
  late List<CustomerVoiceReportTypeModel> _list;

  @override
  void initState() {
    super.initState();
    _list = [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // button, title,
        Padding(
          padding: const EdgeInsets.only(
            top: Constants.semiMediumPadding,
            left: Constants.semiMediumPadding,
            right: Constants.semiMediumPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // close button
              CustomTextButtonWidget(
                onPressed: () => Navigator.of(context).pop(),
                text: ("customerVoiceBackButtonWord").tr(),
                btnTextColor: AppColor.grey1000,
                btnTextSize: 17.0,
                btnTextWeight: AppFontWeight.medium,
              ),
              Constants.verticalSpaceMedium,
              // title
              CustomTextWidget(
                ("lbl_choose_inq_type").tr(),
                fontColor: AppColor.black,
                fontSize: 24.0,
              ),
              Constants.verticalSpaceSmall,
            ],
          ),
        ),
        // types
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
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
            itemBuilder: (context, index) =>
                GeneralInquiryTypeWidget(_list[index]),
          ),
        )
      ],
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
        /*  if (isSuccess) {
          NavigationService.navigatorKey.currentState!.pushNamed(
              RouteName.newGeneralInquiryRoute,
              arguments: inqTypesModel);
        }*/
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border:
                Border.all(color: AppColor.black200, width: 0.5775000000000001),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x1a000000),
                  offset: Offset(0, 1),
                  blurRadius: 15,
                  spreadRadius: 0)
            ],
            color: Colors.white),
        padding: const EdgeInsets.all(Constants.semiMediumPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon
            SvgPicture.asset(
              inqTypesModel.icon,
              height: 50,
              width: 50,
            ),
            Constants.verticalSpaceSmall,
            // service name
            CustomTextWidget(
              (inqTypesModel.title).tr(),
              fontColor: AppColor.black,
              fontSize: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}
