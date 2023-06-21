import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../../core/utils/utils_exports.dart' show ContextConversion;

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../home_page/home_exports.dart' show CircleIcon;

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
    return BlocBuilder<CreateVDBloc, CreateVDState>(builder: (context, state) {
      return AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: backOnPress,
          child: Container(
            margin: const EdgeInsetsDirectional.only(start: 12),
            child: Row(
              children: [
                CustomTextButtonWidget(
                  text: ('السابق').tr(),
                  btnTextSize: 20,
                  btnTextColor: AppColor.blackModern700Light,
                  btnAlignment: AlignmentDirectional.center,
                  onPressed: backOnPress,
                ),
              ],
            ),
          ),
        ),
        // leadingWidth: 32,
        actions: [
          InkWell(
            onTap: context.read<CreateVDBloc>().cancelIncident,
            child: CircleIcon(
              icon: Icons.close,
              iconColor: AppColor.primary600Light,
              backgroundColor: AppColor.geyser.withOpacity(0.4),
              iconSize: 18,
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
              child: LinearProgressIndicator(
                backgroundColor: AppColor.primary100Light,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColor.baladyDarkGreen2,
                ),
                value: currentStep / (getPageList().length + 1),
              ),
            ),
          ],
        ),
      );
    });
  }
}
