import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/pages/violation_address_select_page.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_create_widgets/violation_create_option_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_create_widgets/violation_create_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ViolationCreateListWidget extends StatelessWidget {
  const ViolationCreateListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 343,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 24,
            ),
            const ViolationCreateTitleWidget(),
            const SizedBox(
              height: 24,
            ),
            ViolationCreateOptionWidget(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ViolationAddressSelectPage()));
              },
              optionTitle: 'single'.tr(),
              color: AppColor.greenLight800,
              logoPath: IconPath.user,
            ),
            const SizedBox(
              height: 14,
            ),
            ViolationCreateOptionWidget(
              onPressed: () {},
              logoPath: IconPath.laptop,
              optionTitle: 'business_owner'.tr(),
              color: AppColor.secondary400Light,
            ),
            const SizedBox(
              height: 24,
            ),
          ]),
        ),
      ],
    );
  }
}
