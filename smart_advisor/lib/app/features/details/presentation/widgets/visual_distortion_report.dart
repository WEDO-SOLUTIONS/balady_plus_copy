import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';
import '/app/core/utils/constants/language.dart';

class VisualView extends StatefulWidget {
  const VisualView({super.key});

  @override
  State<VisualView> createState() => _VisualViewState();
}

class _VisualViewState extends State<VisualView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14), color: Color(0xffFFFFFF)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 157,
                  height: 90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      color: const Color(0xffF0F4F6)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '300',
                              style: AppStyle.textRegularRomanStyle
                                  .copyWith(color: AppColor.textPrimaryColor),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            SvgPicture.asset(
                                'packages/smart_advisor/smart_advisor_assets/images/red-arrows-button-up-double.svg'),
                          ],
                        ),
                        Text(
                          ("total_violations").tr(),
                          style: AppStyle.textRegularRomanStyle
                              .copyWith(color: AppColor.textSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 157,
                  height: 90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      color: Color(0xffF0F4F6)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '%40',
                              style: AppStyle.textRegularRomanStyle
                                  .copyWith(color: AppColor.textPrimaryColor),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            SvgPicture.asset(IconPath.arrowsButtonUpDoubleSVG),
                          ],
                        ),
                        Text(
                          ("total_violations").tr(),
                          style: AppStyle.textRegularRomanStyle
                              .copyWith(color: AppColor.textSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
