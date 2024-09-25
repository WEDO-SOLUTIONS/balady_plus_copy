import 'dart:io';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/data/entities/file_data_item.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../../../../../features/home_page/home_exports.dart';

class PickFileComponent extends StatelessWidget {
  final Function onDelete;
  final Function(FileDataItem?) onPickedFile;
  final FileDataItem? file;
  final String title;

  const PickFileComponent({
    Key? key,
    required this.file,
    required this.title,
    required this.onDelete,
    required this.onPickedFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          title,
          fontSize: 16,
          fontWeight: AppFontWeight.bold,
          fontColor: AppColor.blackModern700Light,
        ),
        const SizedBox(height: 16),
        file == null
            ? PlusAddButton(
                onPressed: () async {
                  final file = await CommonFunctions.pickFile(context);
                  onPickedFile(file);
                },
                text: "compliance_image_upload".tr(),
              )
            : Container(
                padding: const EdgeInsets.only(
                    top: 16, bottom: 16, left: 8, right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0x80E6EFEF),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ((file!.fileName
                                    .split(".")
                                    .last
                                    .toLowerCase()
                                    .contains("pdf")))
                                ? const CustomSvgIconWidget(IconPath.pdf)
                                : Image.file(
                                    File(file!.filePath),
                                    width: 24,
                                    height: 28,
                                  ),
                            const CustomHorizontalSpace(width: 8),
                            Flexible(
                              child: CustomTextWidget(
                                file!.fileName,
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
              ),
        const SizedBox(height: 24),
      ],
    );
  }
}
