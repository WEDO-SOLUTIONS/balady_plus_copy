import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';

class EkramRequestAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final double currentStep;
  final VoidCallback backOnPress;

  const EkramRequestAppBar(
      {Key? key, required this.currentStep, required this.backOnPress})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(builder: (context, state) {
      return AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: backOnPress,
          child: Container(
            margin: const EdgeInsetsDirectional.only(start: 12),
            child: RotationBasedLanguageWidget(
              child: Image.asset(
                Constants.imgPath + 'arrowBack@3x.png',
                height: 24.0,
                width: 24.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
        leadingWidth: 32,
        actions: [
          CustomTextButtonWidget(
            text: Helpers.translatingWord('vd_cancel'),
            btnTextSize: 17,
            btnTextColor: AppColor.primary900Light,
            btnAlignment: AlignmentDirectional.center,
            onPressed: () {
              context.read<EkramRequestTransportationBloc>().cancelRequest();
            },
          )
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarBrightness: Brightness.light,
        ),
        flexibleSpace: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: Constants.appBarBoxShadow,
              ),
              alignment: AlignmentDirectional.topStart,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColor.primary900Light,
                ),
                value: currentStep /
                    (context
                        .read<EkramRequestTransportationBloc>()
                        .pagesList
                        .length),
              ),
            ),
          ],
        ),
      );
    });
  }
}
