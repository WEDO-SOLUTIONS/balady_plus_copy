import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_icon_button_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../create_objection_bloc/create_objection_bloc.dart';
import 'note_field_widget.dart';
import 'objection_reason_attachment.dart';

class ReplyAttachmentSection extends StatefulWidget {
  const ReplyAttachmentSection({super.key});

  @override
  State<ReplyAttachmentSection> createState() => _ReplyAttachmentSectionState();
}

class _ReplyAttachmentSectionState extends State<ReplyAttachmentSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateObjectionBloc, CreateObjectionState>(
      builder: (context, state) {
        return MediaQuery.removePadding(
          removeTop: true,
          removeBottom: true,
          context: context,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: state.reasons?.length ?? 0,
            itemBuilder: ((context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  NotesFieldsSection(
                    key: ValueKey(state.reasons?[index].guid), 
                    initialDesc: state.reasons?[index].notes,
                    index: index,
                    hideDelete:(state.reasons?.length??0) < 2,
                    onDelete: () {
                      context
                          .read<CreateObjectionBloc>()
                          .add(DeleteNewReasonEvent(index: index));
                    },
                    onChanged: (String? t) {
                      context
                          .read<CreateObjectionBloc>()
                          .add(ChangeIssueDescEvent(index: index, text: t));
                    },
                  ),
                  if (state.reasons?[index].file == null)
                    ElevatedIconButtonWidget.upload(
                      onPressed: () async {
                        FileDataItem? file =
                            await CommonFunctions.pickFile(context);
                        if (file != null) {
                          context
                              .read<CreateObjectionBloc>()
                              .add(UploadFileEvent(params: file, index: index));
                        }
                      },
                    ),
                  if (state.reasons?[index].file != null)
                    ObjectionReasonAttachment(
                      onDelete: () {
                        context
                            .read<CreateObjectionBloc>()
                            .add(RemoveFileEvent(index: index));
                      },
                      fileName: state.reasons?[index].file?.fileName ?? "",
                      filePath: state.reasons?[index].file?.filePath ?? "",
                    ),
                  /* GestureDetector(
                      onTap: () async {
                        FileDataItem? file =
                            await CommonFunctions.pickFile(context);
                        if (file != null)
                          context
                              .read<CreateObjectionBloc>()
                              .add(UploadFileEvent(params: file, index: index));
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
                              state.reasons?[index].file?.fileName ?? "",
                              fontSize: 16,
                              textAlign: TextAlign.start,
                              fontWeight: AppFontWeight.medium,
                              fontColor: AppColor.black,
                              maxLines: 1,
                            ),
                          )
                        ],
                      ),
                    ),*/
                  CustomVerticalSpace(height: 32),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
