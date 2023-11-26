import 'package:balady_new_app/app/core/core_exports.dart';
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:balady_new_app/shared/core/services/local/navigation_services.dart';
import 'package:flutter/material.dart';

import '../../../../../etmam_app/core/utils/utils_exports.dart';

class EkramTypeCardWidget extends StatelessWidget {
  final EkramTypes ekramTypes;
  final EkramRequestsBloc ekramBloc;
  const EkramTypeCardWidget(
      {Key? key, required this.ekramTypes, required this.ekramBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ekramTypes.type == "transport") {
          NavigationService.navigatorKey.currentState!.pushReplacementNamed(
              RoutesNames.ekramRequestTransportationScreen,
              arguments: ekramBloc);
        }
      },
      child: Container(
        height: 202,
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
                ekramTypes.icon ?? "",
                iconHeight: 52,
                iconWidth: 52,
              ),
              CustomVerticalSpace(height: 10),
              CustomTextWidget(
                trans(ekramTypes.title ?? ""),
                fontSize: 14,
                fontWeight: FONT_WEIGHT.bold,
                fontColor: AppColors.black,
                maxLines: 2,
              ),
              CustomVerticalSpace(height: 12),
              CustomTextWidget(
                trans(ekramTypes.desc ?? ""),
                fontSize: 13,
                fontWeight: FONT_WEIGHT.medium,
                fontColor: AppColors.black400,
                height: 1.4,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
