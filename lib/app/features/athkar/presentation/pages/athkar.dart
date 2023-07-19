import 'package:balady_plus/app/features/athkar/athkar_exports.dart'
    show AthkarAppBar, AthkarListView;
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class Athkar extends StatelessWidget {
  Athkar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColor.scaffoldBackground,
      appBar: AthkarAppBar(
        title: 'AthkarMainPageTitle'.tr(),
      ),
      body: AthkarListView(),
    );
  }
}
