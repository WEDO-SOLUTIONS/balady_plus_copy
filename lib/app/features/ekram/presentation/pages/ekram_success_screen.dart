import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class EkramSuccessPage extends StatefulWidget {
  const EkramSuccessPage({Key? key}) : super(key: key);

  @override
  State<EkramSuccessPage> createState() => _EkramSuccessPageState();
}

class _EkramSuccessPageState extends State<EkramSuccessPage> {
  @override
  Widget build(BuildContext context) {
    String? msg = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
            right: 16,
            left: 16,
            top: MediaQuery.of(context).padding.top + 10,
            bottom: 30),
        color: AppColor.white,
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
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.black,
                    ),
                    CustomVerticalSpace(height: 12),
                    CustomTextWidget(
                      msg ?? "", //.replaceAll("_", "3276547326"),
                      fontSize: 16,
                      fontWeight: AppFontWeight.medium,
                      fontColor: AppColor.black500,
                      height: 1.4,
                    ),
                    CustomVerticalSpace(height: 32),
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
