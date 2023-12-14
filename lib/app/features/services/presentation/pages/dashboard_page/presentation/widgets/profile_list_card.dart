import 'package:flutter/material.dart';

import '../../../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle;
import '../../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../dashboard_page_exports.dart' show ProfileListItem, ProfileSection;

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
        /*Padding(
          padding: const EdgeInsetsDirectional.only(start: 16, top: 16),
          child: CustomTextWidget(
            section.title,
            textStyle: AppStyle.profileSectionTitleTextStyle,
          ),
        ),*/
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: Color(0xffF5F7FA),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: section.items.length,
            itemBuilder: (context, index) =>
                ProfileListItem(item: section.items[index]),
            separatorBuilder: (context, index) => const Divider(
              color: Color(0x1f1E2A36),
            ),
          ),
        ),
      ],
    );
  }
}
