import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../blocs/new_health_certificate_bloc/new_health_certificate_bloc.dart';

class DetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double currentStep;
  final VoidCallback backOnPress;

  const DetailsAppBar(
      {Key? key, required this.currentStep, required this.backOnPress})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewHealthCertificateBloc, NewHealthCertificateState>(
        builder: (context, state) {
      return AppBar(
        elevation: 0,
        leadingWidth: 200,
        leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: backOnPress,
          child: Container(
            margin: const EdgeInsetsDirectional.only(start: 10),
            child: Row(
              children: [
                CustomTextIconButtonWidget(
                  text: ('back').tr(),
                  icon: SvgPicture.asset(IconPath.vdAppBarBack),
                  iconTextTweenSpace: 5,
                  textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.blackModern700Light,
                      fontFamily: Constants.appFontType),
                  onPressed: backOnPress,
                ),
              ],
            ),
          ),
        ),
        // leadingWidth: 32,
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 10),
            child: InkWell(
              onTap: () =>
                  context.read<NewHealthCertificateBloc>().cancelIncident(),
              child: CircleIcon(
                icon: Icons.close,
                iconColor: AppColor.primary600Light,
                backgroundColor: AppColor.geyser.withOpacity(0.4),
                iconSize: 18,
              ),
            ),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarBrightness: Brightness.light,
        ),

        flexibleSpace: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 40, left: 16, right: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(ImagePath.appBarBackground),
                  fit: BoxFit.fill,
                ),
                boxShadow: Constants.appBarBoxShadow,
              ),
              alignment: AlignmentDirectional.bottomCenter,
              child: LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 32,
                addAutomaticKeepAlive: false,
                lineHeight: 6.7,
                isRTL: CommonFunctions.isAppAR ? true : false,
                animationDuration: 0,
                restartAnimation: false,
                percent: currentStep /
                    (context.read<NewHealthCertificateBloc>().pagesList.length),
                barRadius: Radius.circular(33),
                backgroundColor: AppColor.primary100Light,
                linearGradient: LinearGradient(colors: [
                  AppColor.primary900Light,
                  Color(0xff159EBB),
                ]),
              ),
            ),
          ],
        ),
      );
    });
  }
}
