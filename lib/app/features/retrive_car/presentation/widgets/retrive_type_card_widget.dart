import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../data/model/dc_types.dart';
import '../../data/model/veichles_list_page_params.dart';

class RetriveTypeCardWidget extends StatelessWidget {
  final DCTypes dcTypes;
  const RetriveTypeCardWidget({Key? key, required this.dcTypes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (dcTypes.type == "OnBehalfOfMyself") {
          NavigationService.navigatorKey.currentState!.pushReplacementNamed(
              RouteName.VeichlesListPage,
              arguments: VeichlesListPageParams(type: "OnBehalfOfMyself"));
        } else {
          NavigationService.navigatorKey.currentState!.pushReplacementNamed(
              RouteName.CheckVeichlesPage,
              arguments: dcTypes.type);
        }
      },
      child: Container(
        height: 162,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(right: 16, bottom: 24, left: 16),
        decoration: new BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
                color: Color(0x19000000),
                offset: Offset(0, 1),
                blurRadius: 15,
                spreadRadius: 0)
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomSvgIconWidget(
                dcTypes.icon ?? "",
                iconHeight: 52,
                iconWidth: 52,
              ),
              CustomVerticalSpace(height: 10),
              CustomTextWidget(
                (dcTypes.title.toString().tr() ?? ""),
                fontSize: 14,
                fontWeight: AppFontWeight.bold,
                fontColor: AppColor.black,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
