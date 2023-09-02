import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_icon_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_bloc.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/previous_next_buttons.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../transaction_inquiry/customer_voice_exports.dart';

class FifthComplianceSubmitStep extends StatelessWidget {
  const FifthComplianceSubmitStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ComplianceSubmitTitle(
                  title: 'compliance_complain_title'.tr(),
                  subtitle: '',
                ),
                if (state.attachments != null)
                  AttachmentListWidget(
                    attachments: state.attachments ?? [],
                    deleteFile: (int index) {
                      context
                          .read<ComplianceBloc>()
                          .add(DeleteFileEvent(index: index));

                      //  model.attachments[index].fileName = null;
                      //   model.attachments[index].filePath = null;
                      //    model.attachments[index].base64 = null;
                      //     model.validateForm();
                    },
                    saveFile: (int index, String filePath, String fileName,
                        String base64) {
                      context.read<ComplianceBloc>().add(SaveFileEvent(
                          index: index,
                          fileName: fileName,
                          base64: base64,
                          filePath: filePath));
                      //   model.attachments[index].fileName = fileName;
                      //    model.attachments[index].filePath = filePath;
                      //    model.attachments[index].base64 = base64;
                      ///     model.validateForm();
                      //     setState(() {});
                      // model.notifyListeners();
                    },
                  ),
                SizedBox(
                  height: 16,
                ),
                /* SizedBox(
                  height: 32,
                ),
                CustomTextWidget(
                  'compliance_notes_title'.tr(),
                  textStyle: AppStyle.complianceDocumentTitleStyle,
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        width: 2,
                        color: AppColor.blueSkyLight800,
                      )),
                  child: CustomTextWidget(
                    'comliance_message_hint'.tr(),
                    textStyle: AppStyle.complianceSubtitleStyle,
                    textAlign: TextAlign.right,
                    maxLines: 4,
                  ),
                ),*/
                SizedBox(
                  height: 32,
                ),
                PreviousNextButtons()
              ],
            ),
          ),
        );
      },
    );
  }
}

class AttachmentListWidget extends StatelessWidget {
  final List<AttachmentData> attachments;
  final bool showDelete;
  final Function(int index, String filePath, String fileName, String base64)
      saveFile;
  final Function(int index) deleteFile;

  const AttachmentListWidget(
      {Key? key,
      required this.attachments,
      required this.saveFile,
      required this.deleteFile,
      this.showDelete = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: attachments.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: AttachmentWidget(
              fileIndex: index,
              title: attachments[index].title,
              isRequired: attachments[index].isRequired,
              path: attachments[index].filePath,
              fileName: attachments[index].fileName,
              onPress: () {},
              hint: attachments[index].hint,
              enableButton: (status) {},
              saveFile: saveFile,
              deleteFile: deleteFile,
              showDelete: showDelete,
            ),
          );
        },
      ),
    );
  }
}
