import 'package:balady_plus/app/features/athkar/athkar_exports.dart'
    show AthkarEntity, AthkarEntityContentParams;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, IconPath, RouteName;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget;

class AthkarEntityCard extends StatelessWidget {
  const AthkarEntityCard({
    super.key,
    required this.athkarEntity,
  });

  final AthkarEntity athkarEntity;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
          context, RouteName.athkarEntityContentPage,
          arguments:
              AthkarEntityContentParams(athkarEntity.name, athkarEntity)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        height: 64,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                athkarEntity.name,
                fontColor: Colors.black,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(IconPath.muslimNumberFrame),
                  CustomTextWidget(
                    '${athkarEntity.quantity}',
                    fontColor: AppColor.primary800Light,
                    fontWeight: AppFontWeight.semiBold,
                    fontSize: 14,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
