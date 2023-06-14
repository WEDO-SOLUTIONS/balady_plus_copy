import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget;
import '../../../home_exports.dart' show ServiceArgs, HomeTag;

class ServiceCard extends StatelessWidget {
  final ServiceArgs args;
  final bool fullWidth;

  const ServiceCard({
    super.key,
    required this.args,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - (fullWidth ? 32 : 80);
    return Container(
      width: width,
      height: 100,
      margin: const EdgeInsetsDirectional.only(top: 16, start: 16),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: AppColor.darkSlateBlue6,
            offset: Offset(0, -4),
            blurRadius: 32,
          )
        ],
        color: AppColor.blackModern50Light,
      ),
      child: Stack(
        children: [
          if (args.tag != null)
            Positioned.directional(
              top: 0,
              end: 0,
              textDirection: TextDirection.rtl,
              child: HomeTag(
                title: args.tag!,
                backgroundColor: AppColor.iceBlue,
                textColor: AppColor.greyishBrown,
                fontSize: 8.0,
              ),
            ),
          Row(
            children: [
              const DrawIconBasedTypeWidget(
                icon: IconPath.nearby, //args.image,
                iconSize: 68,
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    args.title,
                    textStyle: AppStyle.serviceTitleStyle,
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: width - 110,
                    child: Row(
                      children: [
                        CustomTextWidget(
                          args.description,
                          textStyle: AppStyle.semiBoldTextStyle,
                        ),
                        const Spacer(),
                        const DrawIconBasedTypeWidget(
                          icon: Icons.arrow_forward,
                          iconSize: 16,
                          iconColor: AppColor.primary900Light,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
