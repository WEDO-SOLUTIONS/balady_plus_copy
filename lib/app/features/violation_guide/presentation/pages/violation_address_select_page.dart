import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_location_widgets/violation_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ViolationAddressSelectPage extends StatelessWidget {
  const ViolationAddressSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        backgroundColor: AppColor.scaffoldBackground,
        title: Text(
          'back'.tr(),
          style: AppStyle.violationCreateAppBarTitle,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: const ViolationLocationListWidget(),
      ),
    );
  }
}
