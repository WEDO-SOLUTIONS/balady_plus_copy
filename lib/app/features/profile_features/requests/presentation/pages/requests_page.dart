import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show IconPath, AppColor;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show DefaultAppBarWidget;
import '../../../../home_page/home_exports.dart' show CircleIcon;
import '../../requests_exports.dart' show AppBarSeachBar;

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: 'requests'.tr(),
        bottom: const AppBarSeachBar(),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: CircleIcon(
              backgroundColor: AppColor.primary50Light,
              icon: IconPath.filter,
              circleSize: 48.0,
              iconSize: 30.0,
            ),
          ),
        ],
      ),
    );
  }
}
