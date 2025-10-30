import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show IconPath, trans;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show EmptyStateWidget;
import 'package:flutter/cupertino.dart';

class SearchNoResult extends StatelessWidget {
  const SearchNoResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: EmptyStateWidget(
      img: IconPath.error404,
      title: trans('Search_NoResultTitle'),
      // desc: "Search_NoResultDesc".tr(),
    ));
  }
}
