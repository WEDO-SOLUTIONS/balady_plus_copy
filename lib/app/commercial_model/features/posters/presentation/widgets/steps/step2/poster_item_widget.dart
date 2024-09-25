import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/posters/presentation/widgets/steps/step2/field_data.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../domain/entities/poster_item.dart';
import 'add_poster_dialog.dart';

class PosterItemWidget extends StatelessWidget {
  final PosterItem? item;
  final int index;
  final Function onDelete;
  final Function onEdit;

  const PosterItemWidget(
      {super.key,
      this.item,
      required this.index,
      required this.onDelete,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CustomTextWidget(
              "poster_index".tr().replaceAll("{}", index.toString()),
              fontColor: AppColor.blackModern600Light,
              fontSize: 18,
              fontWeight: AppFontWeight.bold,
            ),
            Row(
              children: [
                IconButton(
                  iconSize: 23,
                  icon: Icon(
                    Icons.edit,
                    color: AppColor.primary800Light,
                  ),
                  onPressed: () {
                    onEdit();
                  },
                ),
                IconButton(
                  iconSize: 23,
                  icon: Icon(
                    Icons.delete,
                    color: Color(0xffD86581),
                  ),
                  onPressed: () {
                    onDelete();
                  },
                ),
              ],
            )
          ]),
          const SizedBox(
            height: 16,
          ),
          FieldData(
              title: "poster_type".tr(),
              subTitle: item?.posterType?.name ?? ""),
          const CustomVerticalSpace(height: 4),
          FieldData(title: "poster_name".tr(), subTitle: item?.name ?? ""),
          const CustomVerticalSpace(height: 4),
          FieldDataCustomData(title: "poster_dim".tr(), sub: [
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                PosterText(
                  text: "poster_length".tr(),
                ),
                PosterText(
                  text: item?.length.toString() ?? "",
                ),
                PosterText(
                  text: "poster_cm".tr(),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                PosterText(
                  text: "poster_width".tr(),
                ),
                PosterText(
                  text: item?.width.toString() ?? "",
                ),
                PosterText(
                  text: "poster_cm".tr(),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                PosterText(
                  text: "poster_area".tr(),
                ),
                PosterText(
                  text: ((item?.width ?? 0) * (item?.length ?? 0)).toString(),
                ),
                PosterText(
                  text: "poster_cm2".tr(),
                ),
              ],
            ),
          ]),
          const SizedBox(
            height: 8,
          ),
          if (item?.discountPercentage != null)
            FieldData(
                title: "posters_percentage_discount".tr(),
                subTitle: item?.discountPercentage != null
                    ? item?.discountPercentage.toString() ?? ""
                    : ""),
          AttachmentListWidget(
            attachments: item?.attachedDocuments ?? [],
            showDelete: false,
            deleteFile: (int index) {},
            saveFile: (int index, String filePath, String fileName,
                String base64) async {},
          ),
        ],
      ),
    );
  }
}

class PosterText extends StatelessWidget {
  final String text;
  const PosterText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      text,
      fontSize: 16,
      fontWeight: AppFontWeight.bold,
      fontColor: AppColor.blackModern600Light,
    );
  }
}
