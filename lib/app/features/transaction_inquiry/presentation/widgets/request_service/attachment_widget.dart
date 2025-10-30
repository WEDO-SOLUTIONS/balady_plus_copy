import 'dart:convert';
import 'dart:io';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/objectable_transactions/presentation/widgets/create_objection_page/objection_reason_attachment.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/dialogs/upload_file_dialog.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../customer_voice_exports.dart' show ChooseFileDialog;

class AttachmentWidget extends StatelessWidget {
  final int fileIndex;
  final String title;
  final Function onPress;
  final String? path;
  final String? fileName;

  final Function(bool) enableButton;
  final Function(int index, String filePath, String fileName, String stream)
      saveFile;
  final Function(int index) deleteFile;
  final bool isRequired;
  final String hint;
  final bool showDelete;

  const AttachmentWidget({
    required this.fileIndex,
    required this.title,
    this.path,
    this.fileName,
    required this.onPress,
    required this.enableButton,
    required this.saveFile,
    required this.deleteFile,
    this.isRequired = false,
    this.showDelete = true,
    this.hint = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: CustomTextWidget(
                title,
                fontColor: const Color(0xff006665),
                fontSize: 13,
                maxLines: 4,
              ),
            ),
            if (!isRequired)
              CustomTextWidget(
                ('optional').tr(),
                fontColor: const Color(0xffbabbbb),
                fontSize: 13,
              ),
          ],
        ),
        const CustomVerticalSpace(height: 20),
        if (path == null || (path != null && path.toString().isEmpty))
          ElevatedButtonWidget.attachFile(
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();

              FileDataItem? item = await CommonFunctions.pickFile(context);
              if (item != null)
                saveFile(
                    fileIndex, item.filePath, item.fileName, item.fileBase64);
            },
          )
        else
          photoInfo(context, showDelete: showDelete),
      ],
    );
  }

  void openFilePicker(FileType fileType, BuildContext c) async {
    var file = await FilePicker.platform.pickFiles(
      type: fileType,
      allowMultiple: false,
      allowedExtensions:
          fileType == FileType.custom ? ['jpg', 'pdf', 'jpeg', 'png'] : null,
      /* onFileLoading: (status) {
                      setState(() {
                        if (status == FilePickerStatus.picking) {
                          _isProgressFinished = false;
                          widget.enableButton!(false);
                        } else if (status == FilePickerStatus.done) {
                          Timer(const Duration(seconds: 5), () {
                            _isProgressFinished = true;
                            widget.onPress!();
                            widget.enableButton!(true);
                          });
                        }
                      });
                    }, */
    );
    try {
      if (file != null && file.files.isNotEmpty) {
        String? path = file.files[0].path;
        if (path != null) {
          PlatformFile platformFile = file.files.first;
          if (platformFile.size > 25000000) {
            CommonFunctions.showError(('file_size_error').tr());
          } else {
            String fileName = path.isNotEmpty
                ? path.split('/').last
                : ('attachment_name').tr();
            final fileBytes = await File(path).readAsBytes();
            String base64File = base64Encode(fileBytes);
            saveFile(fileIndex, path, fileName, base64File);
          }
          // });
        }
      }
    } on PlatformException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      debugPrint("Unsupported operation" + error.toString());
    }
  }

  Widget photoInfo(BuildContext context, {bool showDelete = true}) {
    return GestureDetector(
      onTap: () => onPress(),
      child: ObjectionReasonAttachment(
          fileName: fileName ?? "",
          filePath: path ?? "",
          showDelete: showDelete,
          onDelete: () => deleteFile(fileIndex)),
    );
  }
}
