import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/request_attachments_view_model.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class ApprovalSequenceAttachmentsScreen extends StatelessWidget {
  final void Function() goToNewPage;
  const ApprovalSequenceAttachmentsScreen({Key? key, required this.goToNewPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // RequestAttachmentsViewModel viewModel = context.watch<RequestAttachmentsViewModel>();

    return Consumer<RequestAttachmentsViewModel>(
      builder: (context, provider, child) {
        return !provider.isLoading
            ? Column(
                children: provider.attachments
                    .map(
                      (attachment) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          CustomTextWidget(
                            attachment.name ?? '',
                            fontColor: AppColor.blackModern700Light,
                            fontSize: 16,
                            fontWeight: AppFontWeight.bold,
                          ),
                          InkWell(
                            onTap: () async {
                              FileDataItem? file =
                                  await CommonFunctions.pickFile(context);
                              if (file != null) {
                                if ((file.sizeInMB * 1000) <=
                                    (attachment.maxSize ?? 0)) {
                                  provider
                                      .uploadCommercialLicenseCancelAttachments(
                                    file,
                                    attachment.id!,
                                  );
                                } else {
                                  CommonFunctions.showError(
                                      "file_max_size".tr());
                                }
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 6),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                border: Border.all(
                                  color: AppColor.primary800Light,
                                ),
                                color: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CustomSvgIconWidget(
                                    IconPath.add,
                                    iconSize: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  CustomTextWidget(
                                    'attachment'.tr(),
                                    fontColor: AppColor.primary800Light,
                                    fontSize: 16,
                                    fontWeight: AppFontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          CustomTextWidget(
                            '${'attachment_message_typ'.tr()} ${attachment.allowedFilesExtension ?? ''} ${'attachment_message_size'.tr()} ${(attachment.maxSize ?? 0) ~/ 1000} MB',
                            fontColor: AppColor.blackModern700Light,
                            fontSize: 16,
                            fontWeight: AppFontWeight.bold,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              )
            : const ShimmerEffectWidget(
                height: 65,
                borderRadius: 8,
              );
      },
    );
  }
}
