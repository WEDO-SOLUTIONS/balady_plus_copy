import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../../../../core/dependency_injection/dependency_injection_exports.dart';
import '../../../../../core/services/services_exports.dart';
import '../../../../../core/utils/utils_exports.dart' show AppColor, CommonFunctions, ContextConversion;
import '../../../shared_feature_exports.dart'
    show CustomTextWidget, CustomVerticalSpace, DrawLineWidget, DropDownComponent, FileInfo, IconButtonWidget;

class PickImageComponent extends StatelessWidget {
  final int allowedLimit;
  final void Function(FileInfo) onPickedImage;
  final VoidCallback? onCancel;

  final VoidCallback onLimitExceeded;
  const PickImageComponent({
    super.key,
    this.allowedLimit = 2,
    required this.onPickedImage,
    this.onCancel,
    required this.onLimitExceeded,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget("uploadImage".tr()),
              const CustomVerticalSpace(height: 12.0),
              DrawLineWidget(lineColor: AppColor.black.withValues(alpha: 0.3)),
              const CustomVerticalSpace(height: 12.0),
              //
              for (int index = 0; index < length; index++)
                DropDownComponent(dropDownText: texts[index].tr(), onPressed: callbacks[index]),
            ],
          ),
        ),
        //
        PositionedDirectional(end: 12.0, top: 4.0, child: IconButtonWidget.close(onPressed: context.popDialog)),
      ],
    );
  }

  BuildContext get context => NavigationService.navigatorKey.currentContext!;

  int get length => texts.length;
  List<String> get texts => ["camera", "gallery"];
  List<VoidCallback> get callbacks => [() async => onPick(ImageSource.camera), () async => onPick(ImageSource.gallery)];

  Future<void> onPick(ImageSource source, [bool mounted = true]) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      int sizeInBytes = await image.length();
      final sizeInMB = CommonFunctions.convertBytesToMB(sizeInBytes);
      if (_checkFileSize(sizeInMB)) {
        String path = image.path;
        final fileName = image.name;

        final base64File = await CommonFunctions.fileToBase64(path, mimeType: image.mimeType);
        // final fileBytes = await File(path).readAsBytes();
        // String base64File = base64Encode(fileBytes);
        final file = sl<FileInfo>().copyWith(
          fileBase64: base64File,
          fileName: fileName,
          filePath: path,
          sizeInMB: sizeInMB,
        );
        // close bottom sheet
        if (context.mounted) {
          context.popDialog();
        }
        onPickedImage(file);
      } else {
        onLimitExceeded();
      }
    }
  }

  bool _checkFileSize(int size) => size <= allowedLimit;
}
