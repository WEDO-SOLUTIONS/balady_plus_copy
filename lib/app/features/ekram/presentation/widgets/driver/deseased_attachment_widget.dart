import 'dart:io';

import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/constants/remote_config.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../events_logs/controller/logs_controller.dart';
import '../../../../../events_logs/events_names.dart';
import '../../../../../events_logs/models/error_exception_model.dart';
import '../../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../../_shared_feature_/presentation/pages/pdf_view.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../../objectable_transactions/presentation/widgets/create_objection_page/objection_reason_attachment.dart';
import '../../../data/model/driver/deceased_attachment.dart';
import '../../../data/model/driver/deceased_identical_item.dart';
import '../../../domain/entities/deceased_request_details/deceased_request_details.dart';
import '../../blocs/driver_extra_data_bloc/extra_data_bloc.dart';
import '../ekram_status_widget.dart';

class DeceasedAttachmentCardWidget extends StatelessWidget {
  final DeceasedAttachment item;
  final ExtraDataBloc bloc;
  final int requestId;

  DeceasedAttachmentCardWidget({
    Key? key,
    required this.item,
    required this.bloc,
    required this.requestId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 20,
        ),
        CustomTextWidget(
          "${item.name!}${item.mandatory == true ? " * " : ""} (${item.allowedFilesExtension})",
          fontSize: 14,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          fontWeight: AppFontWeight.bold,
          fontColor: AppColor.blackModern700Light,
        ),

        item.attachUrl != null && item.attachUrl!.isNotEmpty
            ?
        Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColor.grey900Light.withOpacity(0.5),),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextWidget(
                    "${"attachment_text".tr()} ${item.fileName!}",
                    fontColor: AppColor.borderBlck,
                    fontSize: 12,
                    fontWeight: AppFontWeight.bold,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          String fileName = "";
                          if (item.contentType!.toLowerCase().contains("png") ||
                              item.contentType!.toLowerCase().contains("png") ||
                              item.contentType!.toLowerCase().contains("jpeg")) {
                            fileName = "${item.fileName!}.png";
                          }

                          CommonFunctions.showApigeeFile(
                              CommonFunctions.getDMSUrl(item.uuid ?? ""), fileName,
                              serviceId: 0);
                        },
                        child: const CustomSvgIconWidget(IconPath.receiveSquare,
                            iconSize: 24.0,iconColor: AppColor.greyLight,),
                      ),


                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {

                          bloc.add(DeleteDeceasedAttachmentEvent(
                            item: item,
                              requestId: requestId
                          ));

                        },
                        child: const CustomSvgIconWidget(IconPath.delete,
                            iconSize: 24.0,iconColor: AppColor.greyLight),
                      ),
                    ],
                  ),

                ],
              ),
            )

            : item.updatable == true
                ? Container(

                    margin: const EdgeInsets.only(top: 16),
                  child: ElevatedButtonWidget.attachFile(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();

                        FileDataItem? file =
                            await CommonFunctions.pickFile(context);
                        if (file != null) {
                          bloc.add(UploadDeceasedAttachmentEvent(
                              attachmentId: item.attachmentTypeId!,
                              file: file,
                              requestId: requestId));
                          // saveFile(
                          //     fileIndex, item.filePath, item.fileName,
                          //     item.fileBase64);
                        }
                      },
                    ),
                )
                : Container(),
      ],
    );
  }
}
