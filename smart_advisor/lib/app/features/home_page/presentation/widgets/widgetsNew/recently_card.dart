import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../select_activity/domain/entities/activity_details_page_params.dart';

class RecentlyCard extends StatelessWidget {
  final ActivityDetailsPageParams item;
  const RecentlyCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService.navigatorKey.currentState!.pushNamed(
            RouteName.newDetails,
            arguments: item.copyWith(isFromHome: true));
      },
      child: Container(
        height: 131,
        width: 312,
        margin: const EdgeInsetsDirectional.only(end: 16),
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'packages/smart_advisor/smart_advisor_assets/images/storeN.png',
                height: 45,
                width: 45,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'المنشآت والرخص التجارية',
                      style: AppStyle.textMediumStyle
                          .copyWith(color: AppColor.textSecondaryColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.activityId?.name ?? "",
                      maxLines: 2,
                      style: AppStyle.captionRomanStyle.copyWith(
                        color: AppColor.textPrimaryColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تفاصيل اكثر',
                          style: AppStyle.footNoteBoldStyle.copyWith(
                            color: AppColor.primary,
                          ),
                        ),
                        SvgPicture.asset(
                            'packages/smart_advisor/smart_advisor_assets/icons/svg/arrowup.svg')
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
