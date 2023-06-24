import 'dart:convert';
import 'dart:io';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
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
    this.hint = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomTextWidget(
                  title,
                  fontColor: const Color(0xff006665),
                  fontSize: 13,
                ),
                // required attachment
/*            if (widget.isRequired)
              Text(" * ",
                  style: appBarTextStyle.copyWith(
                      color: Colors.red, fontSize: 13)),*/
                // optional attachment
                if (!isRequired)
                  CustomTextWidget(
                    ('optional').tr(),
                    fontColor: const Color(0xffbabbbb),
                    fontSize: 13,
                  ),
              ],
            ),
          ],
        ),
        const CustomVerticalSpace(height: 20),
        if (path == null || (path != null && path.toString().isEmpty))
          GestureDetector(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              await CustomPopUpsWidgets.showBottomSheet(
                  NavigationService.navigatorKey.currentContext!,
                  child: UploadFileDialog(
                onConfirm: (FileDataItem item) {
                  saveFile(
                      fileIndex, item.filePath, item.fileName, item.fileBase64);
                },
              ), isFullHeight: false);
            },
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                boxShadow: Constants.boxShadow,
                color: AppColor.white4,
              ),
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomHorizontalSpace(width: 18),
                  Image.asset(
                    Constants.imgPath + 'attachmentIcon@3x.png',
                    height: 32,
                    width: 32,
                  ),
                  const CustomHorizontalSpace(width: 8),
                  Expanded(
                    child: CustomTextWidget(('attach_file').tr(),
                        fontColor: const Color(0xff006665),
                        fontWeight: AppFontWeight.medium),
                  ),
                  Image.asset(
                    Constants.imgPath + 'addAttachment@3x.png',
                    height: 18,
                    width: 18,
                  ),
                  const CustomHorizontalSpace(width: 18),
                ],
              ),
            ),
          )
        else
          photoInfo(context),
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
    } on PlatformException catch (e) {
      debugPrint("Unsupported operation" + e.toString());
    }
  }

  Widget photoInfo(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
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
              /*!_isProgressFinished
                  ? SizedBox(
                      height: 3,
                      width: MediaQuery.of(context).size.width / 1.55,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(3)),
                        child: LinearProgressIndicator(
                          backgroundColor: const Color(0xffe6e6e6),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xff389492),
                          ),
                          value: progressNumber,
                        ),
                      ),
                    )
                  :*/

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
