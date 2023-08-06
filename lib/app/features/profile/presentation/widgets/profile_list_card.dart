import 'package:balady_plus/app/features/profile/presentation/widgets/profile_list_item.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../profile_exports.dart' show ProfileSection;

class ProfileListCard extends StatelessWidget {
  final ProfileSection section;

  const ProfileListCard({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16, top: 16),
          child: CustomTextWidget(
            section.title,
            textStyle: AppStyle.profileSectionTitleTextStyle,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            // boxShadow: [
            //   // BoxShadow(
            //   //   color: AppColor.darkSlateBlue6,
            //   //   offset: Offset(0, -4),
            //   //   blurRadius: 32,
            //   // )
            // ],
            color: AppColor.blackModern50Light,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: section.items.length,
            itemBuilder: (context, index) =>
                ProfileListItem(item: section.items[index]),
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ],
    );
  }
}
