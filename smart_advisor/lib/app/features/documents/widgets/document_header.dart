import '../../../core/services/local/navigation_services.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/shared_features/widgets/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';
import '/app/features/start_page/startPage.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import '/app/core/utils/constants/language.dart';

class DocumentHeader extends StatelessWidget {
  final String title;
  final Function? onSubmit;
  final Function? onChanged;
  final Function? onFilter;

  const DocumentHeader(
      {super.key,
      required this.title,
      this.onSubmit,
      this.onChanged,
      this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: 281,
        decoration: BoxDecoration(
            color: AppColor.statusAccentColor,
            image: const DecorationImage(
                image: AssetImage(
                  "packages/smart_advisor/smart_advisor_assets/images/header_background.png",
                ),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),
      Padding(
        padding: const EdgeInsetsDirectional.only(top: 50, end: 16, start: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: AppColor.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    if (onFilter != null)
                      IconButton(
                        icon: Icon(Icons.sort, color: AppColor.white),
                        onPressed: () {
                          onFilter!();
                        },
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  style:
                      AppStyle.accentBoldStyle.copyWith(color: AppColor.white),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
            const SizedBox(
              height: 80,
            ),
            Textfield(
              onSubmit: onSubmit,
              title: "ابحث...",
              onChanged: onChanged,
            )
          ],
        ),
      ),
    ]);
  }
}
