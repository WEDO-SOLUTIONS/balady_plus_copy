import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';

class OptionLicenseCard extends StatelessWidget {
  // final String idNumber;
  // final String status;
  // final String title;
  // final String? subTitle;
  // final String branchName;
  // final String city;
  // final String date;
  final bool isCommercialRegister;
  final LicenseCardModel data;
  final bool isSelected;
  final VoidCallback onTap;
  const OptionLicenseCard(
      {super.key,
      // required this.idNumber,
      // required this.status,
      // required this.title,
      required this.isCommercialRegister,
      required this.data,
      // this.subTitle,
      // required this.branchName,
      // required this.city,
      // required this.date,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(
              color: isSelected ? AppColor.primary : Colors.transparent),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.idNumber,
                      style: AppStyle.footNoteMediumStyle
                          .copyWith(color: AppColor.textSecondaryColor),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: data.isAcitve
                            ? AppColor.statusAccentColor.withOpacity(0.20)
                            : AppColor.statusAttentionColor.withOpacity(0.20),
                      ),
                      child: Text(
                        data.status,
                        style: AppStyle.captionRomanStyle.copyWith(
                            color: data.isAcitve
                                ? AppColor.statusAccentColor
                                : AppColor.statusAttentionColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  data.title,
                  style: AppStyle.textRegularRomanStyle,
                ),
                const SizedBox(height: 8),
                data.subTitle != null
                    ? Text(
                        "${data.subTitle}",
                        style: AppStyle.textRegularRomanStyle,
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 12),
                isCommercialRegister
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: SvgPicture.asset(
                                    IconPath.locationIcon,
                                    width: 16,
                                    height: 16,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Flexible(
                                  child: Text(
                                    "${data.branchName}، ${data.city}",
                                    style: AppStyle.footNoteMediumStyle
                                        .copyWith(
                                            color: AppColor.textSecondaryColor),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 32,
                          ),
                          Row(
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: SvgPicture.asset(
                                  IconPath
                                      .calenderIcon, // locationIcon, //calenderIcon,
                                  width: 16,
                                  height: 16,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                "تنتهي ${data.date}",
                                style: AppStyle.footNoteMediumStyle.copyWith(
                                    color: AppColor.textSecondaryColor),
                              ),
                            ],
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LicenseCardModel {
  final String idNumber;
  final String status;
  final bool isAcitve;
  final String title;
  final String? subTitle;
  final String branchName;
  final String city;
  final String date;

  const LicenseCardModel({
    required this.idNumber,
    required this.status,
    required this.isAcitve,
    required this.title,
    this.subTitle,
    required this.branchName,
    required this.city,
    required this.date,
  });
}
