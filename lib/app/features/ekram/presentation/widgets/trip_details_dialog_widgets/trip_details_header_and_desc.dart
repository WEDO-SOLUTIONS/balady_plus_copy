import 'package:flutter/material.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class TripDetailsHeaderAndDesc extends StatelessWidget {
  final String header;
  final String desc;

  const TripDetailsHeaderAndDesc(
      {Key? key, required this.header, required this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          header,
          maxLines: 1,
          fontSize: 16,
          fontColor: AppColor.black,
          textAlign: TextAlign.start,
          textOverflow: TextOverflow.ellipsis,
        ),
        CustomVerticalSpace(height: 14),
        CustomTextWidget(
          desc,
          maxLines: 1,
          fontSize: 13,
          fontColor: AppColor.black400,
          fontWeight: AppFontWeight.medium,
          textAlign: TextAlign.start,
          textOverflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class TripDetailsDateTime extends StatelessWidget {
  final String date;
  final String time;

  const TripDetailsDateTime({Key? key, required this.date, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          date,
          maxLines: 1,
          fontSize: 11,
          fontColor: AppColor.black400,
          textAlign: TextAlign.start,
          textOverflow: TextOverflow.ellipsis,
          fontFamily: Constants.lucidaGrandFontType,
        ),
        CustomVerticalSpace(height: 8),
        CustomTextWidget(
          time,
          maxLines: 1,
          fontSize: 11,
          fontColor: AppColor.black400,
          textAlign: TextAlign.start,
          textOverflow: TextOverflow.ellipsis,
          fontFamily: Constants.lucidaGrandFontType,
        ),
      ],
    );
  }
}

class TripDetailsCreatedDateWidget extends StatelessWidget {
  final String date;

  const TripDetailsCreatedDateWidget({Key? key, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomTextWidget(
          Helpers.translatingWord('ekram_created_at'),
          maxLines: 1,
          fontSize: 13,
          fontColor: AppColor.black400,
          textAlign: TextAlign.start,
          fontWeight: AppFontWeight.medium,
          textOverflow: TextOverflow.ellipsis,
        ),
        CustomHorizontalSpace(width: 8),
        CustomTextWidget(
          date,
          maxLines: 1,
          fontSize: 11,
          fontColor: AppColor.black400,
          textAlign: TextAlign.start,
          textOverflow: TextOverflow.ellipsis,
          fontFamily: Constants.lucidaGrandFontType,
        ),
      ],
    );
  }
}
