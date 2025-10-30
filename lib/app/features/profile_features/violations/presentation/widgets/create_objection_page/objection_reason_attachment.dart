import 'dart:io';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

import '../../../../../home_page/home_exports.dart';

class ObjectionReasonAttachment extends StatelessWidget {
  final Function onDelete;
  final String fileName;
  final String filePath;

  const ObjectionReasonAttachment(
      {super.key,
      required this.fileName,
      required this.filePath,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0x80E6EFEF),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ((fileName.split(".").last.toLowerCase().contains("pdf")))
                  ? const CustomSvgIconWidget(IconPath.pdf)
                  : Image.file(
                      File(filePath),
                      width: 24,
                      height: 28,
                    ),
              CustomHorizontalSpace(width: 8),
              Flexible(
                child: CustomTextWidget(
                  fileName,
                  fontColor: AppColor.blackModern700Light,
                  fontSize: 12,
                  maxLines: 1,
                  fontWeight: AppFontWeight.semiBold,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => onDelete(),
          child: CircleIcon(
            icon: Icons.close,
            iconColor: AppColor.primary600Light,
            backgroundColor: AppColor.geyser.withOpacity(0.4),
            iconSize: 18,
          ),
        ),
      ]),
    );
  }
}
