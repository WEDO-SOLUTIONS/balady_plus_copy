import 'dart:convert';
import 'dart:io';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/upload_file_dialog.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/objectable_transactions/presentation/widgets/create_objection_page/objection_reason_attachment.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../transaction_inquiry/presentation/core/models/attachment_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class DaemAttachmentInfoSection extends StatefulWidget {
  List<AttachmentData> uploadedFiles;
  final Function(int index, String filePath, String fileName, String base64)
      saveFile;
  final Function(int index) deleteFile;

  DaemAttachmentInfoSection(
      {required this.uploadedFiles,
      required this.saveFile,
      required this.deleteFile});
  @override
  _DaemAttachmentInfoSectionState createState() =>
      _DaemAttachmentInfoSectionState();
}

class _DaemAttachmentInfoSectionState extends State<DaemAttachmentInfoSection> {
  // List<AttachmentData> uploadedFiles = [];

  @override
  void initState() {
    super.initState();
    //uploadedFiles.clear();
    // uploadedFiles.addAll(widget.uploadedFiles);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.uploadedFiles.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (ctx, position) {
                return AttachmentWidget(
                    fileIndex: position,
                    path: widget.uploadedFiles[position].filePath,
                    deleteFile: (int index) {
                      widget.deleteFile(index);
                      setState(() {});
                    },
                    enableButton: (status) {},
                    onPress: () {},
                    fileName: widget.uploadedFiles[position].fileName);
              },
            ),
          ),
          if (widget.uploadedFiles.length < 3)
            ElevatedButtonWidget.attachFile(onPressed: () {
              uploadingImage();
            })
        ],
      ),
    );
  }

  Future uploadingImage() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await CustomPopUpsWidgets.showBottomSheet(
        NavigationService.navigatorKey.currentContext!,
        child: UploadFileDialog(onConfirm: (FileDataItem item) async {
      NavigationService.navigatorKey.currentContext!.popDialog();
      setState(() {});
      widget.saveFile(widget.uploadedFiles.length, item.filePath, item.fileName,
          item.fileBase64);
    }), isFullHeight: false);
  }

  void openFilePicker(FileType fileType, BuildContext c) async {
    var file = await FilePicker.platform.pickFiles(
      type: fileType,
      allowMultiple: false,
      allowedExtensions:
          fileType == FileType.custom ? ['jpg', 'pdf', 'jpeg', 'png'] : null,
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
            widget.saveFile(
                widget.uploadedFiles.length, path, fileName, base64File);
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
      debugPrint("Unsupported operation" + error.toString());
    }
  }
}

class AttachmentWidget extends StatelessWidget {
  final int fileIndex;
  final Function onPress;
  final String? path;
  final String? fileName;
  final Function(bool) enableButton;
  final Function(int index) deleteFile;

  const AttachmentWidget({
    required this.fileIndex,
    this.path,
    this.fileName,
    required this.onPress,
    required this.enableButton,
    required this.deleteFile,
  });

  @override
  Widget build(BuildContext context) {
    return ObjectionReasonAttachment(
        fileName: fileName ?? "",
        filePath: path ?? "",
        onDelete: () {
          deleteFile(fileIndex);
        });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomTextWidget(
                  title,
                  fontColor: const Color(0xff006665),
                  fontSize: 13,
                ),
        
              ],
            ),
          ],
        ),
        const CustomVerticalSpace(height: 20),*/
        photoInfo(context),
      ],
    );
  }

  Widget photoInfo(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.only(right: 10, left: 10),
      height: 56,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Color(0xfff2f2f2)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Row(children: <Widget>[
              Image.asset("assets/images/attachmentIcon@3x.png",
                  height: 32, width: 32),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextWidget(
                  fileName ?? "",
                  fontColor: AppColor.black,
                  fontWeight: AppFontWeight.medium,
                  fontSize: 13,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
          ),
          InkWell(
              onTap: () {
                deleteFile(fileIndex);
              },
              child: Image.asset(
                Constants.whiteCloseImg,
                height: 16,
                width: 16,
                color: AppColor.black,
              )),
        ],
      ),
    );
  }
}
