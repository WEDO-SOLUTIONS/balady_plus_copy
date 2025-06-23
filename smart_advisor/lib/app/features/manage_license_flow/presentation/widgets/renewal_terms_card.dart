import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/warning_widget.dart';

class RenewalTermsCard extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  final List<TermModel> listOfTerms;
  final String? iconPath;
  final String? checkIconPath;
  final String? warningDescrition;
  final String? warningTital;
  final bool hasIcon;
  final bool isBasicColor;
  final bool? hasEdit;
  final bool? showSwitch;
  final bool? isAdd;
  final bool? isWarning;
  const RenewalTermsCard({
    super.key,
    required this.number,
    required this.description,
    required this.title,
    required this.listOfTerms,
    this.isWarning = false,
    this.showSwitch = false,
    this.hasEdit = true,
    this.isAdd = false,
    this.iconPath,
    this.warningDescrition,
    this.warningTital,
    this.checkIconPath,
    required this.hasIcon,
    this.isBasicColor = true,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -20,
              top: -35,
              child: Container(
                height: 41,
                width: 41,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                ),
                child: FittedBox(
                  child: Container(
                    height: 31,
                    width: 31,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.textPrimaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Text(
                      "0$number",
                      textAlign: TextAlign.center,
                      style: AppStyle.footNoteBoldStyle
                          .copyWith(color: AppColor.surfacePrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 24, left: 16, right: 24, bottom: 24),
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: AppStyle.somarSemiBold.copyWith(
                              color: isBasicColor
                                  ? AppColor.textPrimaryColor
                                  : AppColor.statusAttentionColor,
                              fontSize: 16),
                        ),
                        SvgPicture.asset(iconPath ?? IconPath.issueCrIcon,
                            color: isBasicColor
                                ? null
                                : AppColor.statusAttentionColor),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(description ?? "",
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.textRegularStyle.copyWith(
                            color: AppColor.textSecondaryColor,
                            fontSize: 14,
                            height: 1.7)),
                    const SizedBox(
                      height: 16,
                    ),
                    listOfTerms.isNotEmpty
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  showSwitch!
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 50,
                                              width: 1,
                                              color: const Color(0xffCEE3D7),
                                            ),
                                            Container(
                                              width: 22,
                                              height: 22,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xffE2ECE6),
                                              ),
                                              child: Image.asset(
                                                IconPath.switchIcon,
                                                width: 18,
                                                height: 18,
                                              ),
                                            ),
                                            Container(
                                              height: 60,
                                              width: 1,
                                              color: const Color(0xffCEE3D7),
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: listOfTerms.length,
                                      itemBuilder: (context, index) =>
                                          Container(
                                        padding: const EdgeInsets.all(14),
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F7FA),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                checkIconPath != null
                                                    ? SizedBox(
                                                        width: 25,
                                                        height: 25,
                                                        child: Image.asset(
                                                          checkIconPath!,
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                listOfTerms[index].title != null
                                                    ? Expanded(
                                                        child: Text(
                                                          listOfTerms[index]
                                                              .title!,
                                                          style: AppStyle
                                                              .footNoteMediumStyle,
                                                          maxLines: 5,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                hasIcon
                                                    ? SvgPicture.asset(
                                                        IconPath.stepArrowIcon,
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                            listOfTerms[index].description !=
                                                    null
                                                ? Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      listOfTerms[index]
                                                          .description!,
                                                      maxLines: 5,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: AppStyle
                                                          .footNoteRomanStyle
                                                          .copyWith(
                                                        color: AppColor
                                                            .textSecondaryColor,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),
                            ],
                          )
                        : const SizedBox(),
                    isWarning!
                        ? Container(
                            // height: 110,
                            padding: const EdgeInsets.only(
                                top: 16, right: 16, left: 26, bottom: 16),
                            // margin: const EdgeInsets.only(
                            //   left: 16,
                            //   right: 16,
                            // ),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xffEFDDD8)),
                              color: const Color(0xffF7F3F2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(warningDescrition!,
                                    textAlign: TextAlign.start,
                                    style: AppStyle.textRegularStyle.copyWith(
                                      color: AppColor.textPrimaryColor,
                                      fontSize: 14,
                                      height: 1.6,
                                    )),
                                const SizedBox(
                                  height: 12,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            warningTital!,
                                            style: AppStyle.footNoteRomanStyle
                                                .copyWith(
                                              color:
                                                  AppColor.statusAttentionColor,
                                            ),
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SvgPicture.asset(
                                        IconPath.stepArrowIcon,
                                        color: AppColor.statusAttentionColor,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class TermModel {
  final String? title;
  final String? description;

  TermModel({this.title, this.description});
}
