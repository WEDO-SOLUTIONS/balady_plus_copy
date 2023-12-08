import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../reply_retrieve_vehicles_bloc/retrieve_vehicles_bloc.dart';

class ReplyAttachmentSection extends StatefulWidget {
  const ReplyAttachmentSection({super.key});

  @override
  State<ReplyAttachmentSection> createState() => _ReplyAttachmentSectionState();
}

class _ReplyAttachmentSectionState extends State<ReplyAttachmentSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReplyRetrieveVehiclesBloc, ReplyRetrieveVehiclesState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.file != null)
              GestureDetector(
                onTap: () async {
                  FileDataItem? file = await CommonFunctions.pickFile(context);
                  if (file != null)
                    context
                        .read<ReplyRetrieveVehiclesBloc>()
                        .add(UploadFileEvent(params: file));
                },
                child: Row(
                  children: [
                    CustomSvgIconWidget(
                      "assets/icons/customer_pdf.svg",
                      iconHeight: 20,
                      iconWidth: 20,
                      iconColor: AppColor.black,
                    ),
                    CustomHorizontalSpace(width: 8),
                    Flexible(
                      child: CustomTextWidget(
                        state.file?.fileName ?? "",
                        fontSize: 16,
                        textAlign: TextAlign.start,
                        fontWeight: AppFontWeight.medium,
                        fontColor: AppColor.black,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              ),
            if (state.file == null)
              ElevatedButtonWidget.attachFile(
                onPressed: () async {
                  FileDataItem? file = await CommonFunctions.pickFile(context);
                  if (file != null)
                    context
                        .read<ReplyRetrieveVehiclesBloc>()
                        .add(UploadFileEvent(params: file));
                },
              )
          ],
        );
      },
    );
  }
}
