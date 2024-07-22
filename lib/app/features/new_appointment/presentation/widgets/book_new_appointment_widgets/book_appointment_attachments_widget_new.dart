import 'dart:io';
import 'dart:typed_data';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/objectable_transactions/presentation/widgets/create_objection_page/objection_attachment_item.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_icon_button_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../../objectable_transactions/presentation/widgets/create_objection_page/objection_reason_attachment.dart';
import '../../core/models/attachment_item_model.dart';
import '../../core/services/view_models/new_appointment_first_step_view_model.dart';
import 'book_new_appointement_attachment_widget.dart';

class AppointmentAttachmentSection extends StatefulWidget {
  const AppointmentAttachmentSection({Key? key}) : super(key: key);

  @override
  State<AppointmentAttachmentSection> createState() =>
      _AppointmentAttachmentSectionState();
}

class _AppointmentAttachmentSectionState
    extends State<AppointmentAttachmentSection> {
  @override
  Widget build(BuildContext context) {
    NewAppointmentFirstStepViewModel model =
        Provider.of<NewAppointmentFirstStepViewModel>(context, listen: true);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // attachments
        if (model.lstAttachmentConfig != null && model.lstAttachmentConfig!.isNotEmpty )

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: model.lstAttachmentConfig!.length,
            itemBuilder: (ctx, index) {
              return  BookAppointmentAttachmentsWidgetNew(attachmentName: model.lstAttachmentConfig?[index].name,isMandatory:model.lstAttachmentConfig?[index].mandatory,
                saveFile: (String filePath, String fileName, Uint8List base64) {
                  model.saveAttachment(filePath, fileName, base64,model.lstAttachmentConfig?[index].id);
                  // setState(() {});
                },
              );
            },
          ),


          // BookAppointmentAttachmentsWidgetNew(
          //   saveFile: (String filePath, String fileName, Uint8List base64) {
          //     model.saveAttachment(filePath, fileName, base64);
          //     // setState(() {});
          //   },
          // ),
        const CustomVerticalSpace(height: 16),
        if (model.attachmentsList.isNotEmpty) ...[
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: model.attachmentsList.length,
            itemBuilder: (ctx, index) {
              return ObjectionReasonAttachment(
                showDelete: model.attachmentsList[index].updatable == true,
                onDelete: () {
                  model.deleteAttachment(index);
                  model.validateForm();
                  setState(() {});
                },
                fileName: model.attachmentsList[index].attachmentFileName ?? "",
                filePath: model.attachmentsList[index].attachmentPath ?? "",
              );
            },
          ),
          Constants.verticalSpaceSmall,
        ],
      ],
    );
  }
}

class BookAppointmentAttachmentsWidgetNew extends StatelessWidget {
  final String? attachmentName;
  final bool? isMandatory;
  //final String? fileName;
  final Function(String filePath, String fileName, Uint8List stream) saveFile;

  // final Function deleteFile;

  const BookAppointmentAttachmentsWidgetNew({
     this.attachmentName,
    required this.isMandatory,
    required this.saveFile,
  });

  @override
  Widget build(BuildContext context) {
    NewAppointmentFirstStepViewModel model =
    Provider.of<NewAppointmentFirstStepViewModel>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (path == null || (path != null && path.toString().isEmpty))

        ElevatedIconButtonWidget.upload(
          name: attachmentName,
          isMandatory:isMandatory,
          model:model,
          onPressed: () async {
            FileDataItem? file = await CommonFunctions.pickFile(context);
            if (file != null) {
              final fileBytes = await File(file.filePath).readAsBytes();
              saveFile(file.filePath, file.fileName, fileBytes);
            }
          },
        ),
        SizedBox(height: 15,)


      ],
    );
  }
}
