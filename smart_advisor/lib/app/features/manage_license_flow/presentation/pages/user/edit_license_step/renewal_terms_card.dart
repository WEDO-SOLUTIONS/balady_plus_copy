import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/renewal_terms_card.dart';

class EditTermsCard extends StatelessWidget {
  final int number;
  final String title;
  final String subTitle;
  final String description;
  final List<TermModel> listOfCurrentTerms;
  final List<TermModel> listOfNewTerms;
  final String? iconPath;
  final String? checkIconPath;
  final bool hasIcon;
  final bool isBasicColor;
  final bool? hasEdit;
  final bool? isAdd;
  const EditTermsCard({
    super.key,
    required this.number,
    required this.description,
    required this.title,
    required this.subTitle,
    required this.listOfCurrentTerms,
    required this.listOfNewTerms,
    this.hasEdit = true,
    this.isAdd = false,
    this.iconPath,
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
                    Text("الانشطة الحالية",
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.textRegularStyle.copyWith(
                            color: AppColor.textPrimaryColor,
                            fontSize: 16,
                            height: 1.7)),
                    const SizedBox(
                      height: 16,
                    ),
                    listOfCurrentTerms.isNotEmpty
                        ? Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: listOfCurrentTerms.length,
                                itemBuilder: (context, index) => Container(
                                  padding: const EdgeInsets.all(14),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF568F64)
                                        .withOpacity(0.04),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                  child: Column(
                                    children: [
                                      listOfCurrentTerms[index].title != null
                                          ? Expanded(
                                              child: Text(
                                                listOfCurrentTerms[index]
                                                    .title!,
                                                style: AppStyle
                                                    .footNoteMediumStyle
                                                    .copyWith(
                                                        color: AppColor
                                                            .textPrimaryColor),
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          : const SizedBox(),
                                      listOfCurrentTerms[index].description !=
                                              null
                                          ? Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                listOfCurrentTerms[index]
                                                    .description!,
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppStyle
                                                    .footNoteRomanStyle
                                                    .copyWith(
                                                  color:
                                                      AppColor.textPrimaryColor,
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    const SizedBox(height: 20),
                    Text(subTitle,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.textRegularStyle.copyWith(
                            color: AppColor.textPrimaryColor,
                            fontSize: 16,
                            height: 1.7)),
                    const SizedBox(
                      height: 12,
                    ),
                    listOfNewTerms.isNotEmpty
                        ? Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: listOfNewTerms.length,
                                itemBuilder: (context, index) => Container(
                                  padding: const EdgeInsets.all(14),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF568F64)
                                        .withOpacity(0.04),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          hasEdit!
                                              ? SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: Image.asset(
                                                    isAdd!
                                                        ? IconPath.addIcon
                                                        : IconPath.stopIcon,
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          listOfNewTerms[index].description !=
                                                  null
                                              ? Expanded(
                                                  child: Text(
                                                    listOfNewTerms[index]
                                                        .description!,
                                                    style: AppStyle
                                                        .footNoteMediumStyle
                                                        .copyWith(
                                                            color: AppColor
                                                                .textPrimaryColor),
                                                    maxLines: 5,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
