import 'package:balady_new_app/app/core/shared_local_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../core/shared_local_services/app_colors.dart';
import '../../../../core/shared_local_services/enums.dart';
import '../../../../core/shared_widgets/custom_buttons_widgets.dart';
import '../../../../core/shared_widgets/custom_text_widget.dart';

class EkramSuccessPage extends StatefulWidget {
  final String? msg;
  const EkramSuccessPage({Key? key, this.msg}) : super(key: key);

  @override
  State<EkramSuccessPage> createState() => _EkramSuccessPageState();
}

class _EkramSuccessPageState extends State<EkramSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
            right: 16,
            left: 16,
            top: MediaQuery.of(context).padding.top + 10,
            bottom: 30),
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                Constants.whiteCloseImg,
                height: 20.0,
                width: 20.0,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset("assets/icons/ekram_success.svg"),
                    CustomVerticalSpace(height: 32),
                    CustomTextWidget(
                      trans('successEkramTitle'),
                      fontSize: 22,
                      fontWeight: FONT_WEIGHT.bold,
                      fontColor: AppColors.black,
                    ),
                    CustomVerticalSpace(height: 12),
                    CustomTextWidget(
                      widget.msg ?? "", //.replaceAll("_", "3276547326"),
                      fontSize: 16,
                      fontWeight: FONT_WEIGHT.medium,
                      fontColor: AppColors.black500,
                      height: 1.4,
                    ),
                    CustomVerticalSpace(height: 32),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: CustomElevatedButtonWidget(
                btnPressed: () {
                  Navigator.of(context).pop();
                },
                btnText: trans('ekramGoToOrders'),
                btnTextSize: 16,
                btnTextWeight: FONT_WEIGHT.regular,
                btnHeight: 56,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
