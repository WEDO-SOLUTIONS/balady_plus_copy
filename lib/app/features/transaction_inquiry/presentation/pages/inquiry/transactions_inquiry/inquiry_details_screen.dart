import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/app_analytics_events.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/constants.dart';
import '../../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../core/models/inquiry_transaction_response.dart';
import '../../../widgets/inquiry/inquiry_result_body.dart';

class InquiryDetailsScreen extends StatefulWidget {
  const InquiryDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _InquiryDetailsScreenState createState() => _InquiryDetailsScreenState();
}

class _InquiryDetailsScreenState extends State<InquiryDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.TransactionInquiry);
  }

  @override
  Widget build(BuildContext context) {
    InquiryTransactionResponse result = ModalRoute.of(context)!
        .settings
        .arguments as InquiryTransactionResponse;
    return Scaffold(
        body: Container(
      color: AppColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // header

          Container(
            margin: EdgeInsetsDirectional.only(
                top: MediaQuery.of(context).padding.top + 10, start: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                IconPath.qrWhiteCloseIcon,
                height: 20.0,
                width: 20.0,
                color: Colors.black,
              ),
            ),
          ),
          // body
          InquiryBody(
            result: result,
          ),
          // button
          const InquiryButton(),
        ],
      ),
    ));
  }
}

class InquiryButton extends StatelessWidget {
  const InquiryButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            EnhancedCustomElevatedButtonWidget(
              btnPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                  context,
                  RouteName.newTransactionInquiryScreen,
                );
              },
              btnText: ('inquiry_new').tr(),
              btnTextSize: 16,
              btnTextWeight: AppFontWeight.medium,
              btnHeight: 56,
            ),
            Constants.verticalSpaceSmall,
          ],
        ),
      ),
    );
  }
}
