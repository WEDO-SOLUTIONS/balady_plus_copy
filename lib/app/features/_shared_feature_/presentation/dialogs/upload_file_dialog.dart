import 'dart:convert';
import 'dart:io';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../data/entities/file_data_item.dart';
import '../widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class UploadFileDialog extends StatelessWidget {
  final Function(FileDataItem file) onConfirm;
  final Function? onCancel;
  final bool imagesOnly;
  final bool filesOnly;

  const UploadFileDialog({
    super.key,
    required this.onConfirm,
    this.onCancel,
    this.imagesOnly = false,
    this.filesOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        color: Colors.white,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              /*  DialogHeader(
                title: Helpers.translatingWord("choose_file"),
                withDivider: false,
              ),*/
              if (filesOnly == false)
                CustomTextButtonWidget(
                  text: ("lbl_Camera").tr(),
                  btnTextColor: AppColor.black,
                  btnTextSize: 17,
                  btnTextWeight: AppFontWeight.medium,
                  btnAlignment: Alignment.center,
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.camera);

                    if (image != null) {
                      int imageSize = await image.length();
                      if (imageSize > 25000000) {
                        CommonFunctions.showError(('file_size_error').tr());
                      } else {
                        String path = image.path;
                        String fileName = path.isNotEmpty ? path.split('/').last : ('attachment_name').tr();
                        final fileBytes = await File(path).readAsBytes();
                        String base64File = base64Encode(fileBytes);
                        FileDataItem file = FileDataItem(
                          fileBase64: base64File,
                          fileName: fileName,
                          filePath: path,
                          bytes: fileBytes,
                          // sizeInMB: CommonFunctions.convertBytesToMB(imageSize),
                        );
                        onConfirm(file);
                      }
                    }
                  },
                ),
              // const DrawLineWidget(
              //   verticalMargin: 10,
              //   ),
              if (Platform.isIOS && (filesOnly == false))
                CustomTextButtonWidget(
                  text: ("images").tr(),
                  btnTextColor: AppColor.black,
                  btnTextSize: 17,
                  btnTextWeight: AppFontWeight.medium,
                  btnAlignment: Alignment.center,
                  onPressed: () {
                    openFilePicker(FileType.image, context);
                  },
                ),

              // if (Platform.isIOS)
              //  const DrawLineWidget(
              //      verticalMargin: 10,
              //   ),
              CustomTextButtonWidget(
                text: ("files").tr(),
                btnTextColor: AppColor.black,
                btnTextSize: 17,
                btnTextWeight: AppFontWeight.medium,
                btnAlignment: Alignment.center,
                onPressed: () {
                  openFilePicker(FileType.custom, context, allowedExtensions: filesOnly ? ["pdf"] : null);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openFilePicker(FileType fileType, BuildContext c, {List<String>? allowedExtensions}) async {
    var file = await FilePicker.platform.pickFiles(
      type: fileType,
      allowMultiple: false,
      allowedExtensions: allowedExtensions ?? (fileType == FileType.custom ? ['jpg', 'pdf', 'jpeg', 'png'] : null),
    );
    try {
      if (file != null && file.files.isNotEmpty) {
        String? path = file.files[0].path;
        if (path != null) {
          PlatformFile platformFile = file.files.first;
          if (platformFile.size > 25000000) {
            CommonFunctions.showError(('file_size_error').tr());
          } else {
            String fileName = path.isNotEmpty ? path.split('/').last : ('attachment_name').tr();
            final fileBytes = await File(path).readAsBytes();
            String base64File = base64Encode(fileBytes);
            FileDataItem file = FileDataItem(
              fileBase64: base64File,
              fileName: fileName,
              filePath: path,
              bytes: fileBytes,

              //  sizeInMB: CommonFunctions.convertBytesToMB(platformFile.size),
            );
            onConfirm(file);
          }
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
      // debugPrint("Unsupported operation" + e.toString());
    }
  }
}
