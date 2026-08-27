import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class DashboardButton extends StatelessWidget {
  final MiniApp dashboardMinApp;

  const DashboardButton({super.key, required this.dashboardMinApp});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<NewMiniAppLogicCubit>().openMiniApp(dashboardMinApp);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18.5)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0XFFE5EBED), borderRadius: BorderRadius.circular(13.5)),
              child: CustomNetworkImageWidget(
                dashboardMinApp.iconPath,
                isVerifyingKey: true,
                imageWidth: context.w(24),
                imageHeight: context.h(24),
              ),
            ),
            SizedBox(width: context.w(8)),
            Text(
              "dashboard".tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'packages/balady_design_system/IBMPlexSansArabic',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: context.w(9)),
          ],
        ),
      ),
    );
  }
}
