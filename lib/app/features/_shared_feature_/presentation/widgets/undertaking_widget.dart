import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart';
import '../../shared_feature_exports.dart';

class UndertakingWidget extends StatelessWidget {
  const UndertakingWidget({
    super.key,
    required this.desc,
    required this.text,
    required this.onChange,
    required this.initialValue,
  });

  final String desc;
  final String text;
  final Function(bool?) onChange;
  final bool initialValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CustomSvgIconWidget(
                IconPath.undertaking,
                iconSize: 20,
              ),
              const SizedBox(width: 4),
              CustomTextWidget(
                "pledges".tr(),
                fontSize: 16,
                fontColor: AppColor.blackModern600Light,
                fontWeight: AppFontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Html(
            data: desc,
            onLinkTap: (url, attributes, element) {
              CommonFunctions.externalLaunch(url);
            },
            /*  fontSize: 12,
            maxLines: null,
            height: 2,
            textAlign: TextAlign.start,
            fontColor: AppColor.blackModern600Light,
            fontWeight: AppFontWeight.semiBold,*/
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: AppColor.primary50Light,
            ),
            child: CheckBoxWithTitle(
              initialValue: initialValue,
              title: text,
              onChanged: onChange,
            ),
          )
        ],
      ),
    );
  }
}
