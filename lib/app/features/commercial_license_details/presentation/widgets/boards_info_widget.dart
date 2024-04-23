import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../commercial_license_details/data/models/commercial_licence_details.dart';

class BoardsInfoWidget extends StatelessWidget {
  final List<BoardsInfomation>? boardsInfo;

  const BoardsInfoWidget({super.key, required this.boardsInfo});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'issue_commercial_board_data'.tr(),
      icon: IconPath.editIcon,
      children: [
        boardsInfo != null ?
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: boardsInfo!.length,
          itemBuilder: (_, index) {
            BoardsInfomation boardInfo = boardsInfo![index];
            return Card(
              margin: const EdgeInsets.only(top: 16),
              color: AppColor.primary100Light,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${'board'.tr()} ${++index}',
                      style: AppStyle.signInFullTextStyle.copyWith(
                        color: AppColor.primary700Light,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "boardTypeName".tr(),
                      style: AppStyle.tagTextStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      boardInfo.typeName ?? "",
                      style: AppStyle.costTextStyle.copyWith(
                        color: const Color(0xff52525B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "boardArea".tr(),
                      style: AppStyle.tagTextStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      boardInfo.area.toString() + 'm2'.tr(),
                      style: AppStyle.costTextStyle.copyWith(
                        color: const Color(0xff52525B),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ) : const SizedBox(),
      ],
    );
  }
}
