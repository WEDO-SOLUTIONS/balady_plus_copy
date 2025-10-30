import 'dart:io';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/posters/presentation/widgets/steps/step2/field_data.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../../features/_shared_feature_/data/entities/file_data_item.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../../features/transaction_inquiry/presentation/widgets/request_service/attachment_widget.dart';
import '../../../../data/models/attachment_resposne_model.dart';
import '../../../../data/models/poster_request_details_model.dart';
import '../../../../data/models/posters_upload_response_model.dart';
import '../../../blocs/posters_license_bloc.dart';

class PosterViewItemWidget extends StatelessWidget {
  final Poster? item;
  final int index;
  final bool? showChangeImage;
  final bool showTitle;

  const PosterViewItemWidget({
    super.key,
    this.item,
    this.showChangeImage = true,
    this.showTitle = false,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
        builder: (context, state) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                if (showTitle) ...[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWidget(
                          "poster_index"
                              .tr()
                              .replaceAll("{}", index.toString()),
                          fontColor: AppColor.blackModern600Light,
                          fontSize: 18,
                          fontWeight: AppFontWeight.bold,
                        ),
                      ]),
                  const SizedBox(
                    height: 16,
                  )
                ],
                FieldData(
                    title: "poster_type".tr(), subTitle: item?.typeName ?? ""),
                const CustomVerticalSpace(height: 4),
                FieldData(
                    title: "poster_name".tr(),
                    subTitle: item?.posterName ?? ""),
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
                        text: item?.area.toString() ?? "",
                      ),
                      PosterText(
                        text: "poster_cm2".tr(),
                      ),
                    ],
                  ),
                ]),
                const SizedBox(
                  height: 16,
                ),
                if (item?.discountPercentage != null)
                  FieldData(
                      title: "posters_percentage_discount".tr(),
                      subTitle: item?.discountPercentage != null
                          ? item?.discountPercentage.toString() ?? ""
                          : ""),
                AttachmentListWidget(
                  attachments: item?.attachments ?? [],
                  showDelete: false,
                  showChangeImage: showChangeImage ?? true,
                  deleteFile: (int index) {},
                  saveFile: (int index, String filePath, String fileName,
                      String base64) async {
                    PermitAttachmentItem? item1 = PermitAttachmentItem(
                        base64: base64,
                        filePath: filePath,
                        fileName: fileName,
                        key: item?.attachments?[index].key,
                        id: item?.attachments?[index].typeId,
                        requestId: state.requestId,
                        posterId: item?.posterId);

                    PostersUploadResponse? uploadResponse = await context
                        .read<PostersLicenseBloc>()
                        .uploadAttachment(item1!);
                  },
                ),
              ],
            ),
            if (state.status.isSubmissionLoading)
              const CustomCircularLoadingWidget(),
          ],
        ),
      );
    });
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

class AttachmentListWidget extends StatelessWidget {
  final List<Attachment>? attachments;
  final bool showDelete;
  final bool showChangeImage;
  final Function(int index, String filePath, String fileName, String base64)
      saveFile;
  final Function(int index) deleteFile;

  const AttachmentListWidget(
      {Key? key,
      required this.attachments,
      required this.saveFile,
      this.showChangeImage = true,
      required this.deleteFile,
      this.showDelete = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: attachments?.length ?? 0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                AttachmentWidget(
                  fileIndex: index,
                  title: attachments?[index].name ?? "",
                  path: attachments?[index].attachUrl,
                  isRequired: true,
                  fileName: attachments?[index].name,
                  onPress: () {
                    if (attachments?[index].attachUrl != null &&
                        attachments![index].attachUrl!.startsWith("http")) {
                      CommonFunctions.showApigeeFile(
                          attachments?[index].attachUrl ?? "",
                          attachments?[index].originFileName ?? "");
                    }
                  },
                  hint: "",
                  enableButton: (status) {},
                  saveFile: saveFile,
                  deleteFile: deleteFile,
                  showDelete: showDelete,
                ),
                const SizedBox(
                  height: 16,
                ),
                if (showChangeImage)
                  ElevatedButtonWidget.primaryCustomBorder(
                      text: "change".tr(),
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();

                        FileDataItem? item =
                            await CommonFunctions.pickFile(context);
                        if (item != null)
                          saveFile(index, item.filePath, item.fileName,
                              item.fileBase64);
                      })
              ],
            ),
          );
        },
      ),
    );
  }
}
