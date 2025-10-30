import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, trans;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';

class SearchTitleResult extends StatelessWidget {
  const SearchTitleResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.only(start: 24.0, top: 24, bottom: 16),
      child: CustomTextWidget(
        trans('Search_SearchResult'),
        fontColor: AppColor.hunterGreen,
        fontSize: 18,
      ),
    );
  }
}
