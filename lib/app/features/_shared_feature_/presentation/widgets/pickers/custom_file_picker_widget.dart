import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../../../../core/services/services_exports.dart' show NavigationService;
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, CommonFunctions, FileSelectorStatus, UIHelper;
import '../../../shared_feature_exports.dart'
    show
        BottomSheetDialog,
        CustomElevatedIconButtonWidget,
        CustomIconButtonWidget,
        CustomTextWidget,
        ErrorUnderWidget,
        FileInfo,
        MessageDialog,
        PickImageComponent,
        WidgetLabel;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class CustomFilePickerWidget extends StatelessWidget {
  final bool isRequired;
  final bool readOnly;
  final bool uploaded;

  final String? label;
  final TextStyle? labelStyle;

  final double? btnWidth;
  final double btnHeight;
  final Color? filledColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry? btnPadding;

  final String? noFileChosenWord;
  final String? fileName;
  final TextStyle? fileNameStyle;

  final String? errorText;

  final FileType fileType;
  final int allowedLimit;
  final List<String> allowedExtensions;

  final void Function(FileInfo) onUploadAttachment;
  final VoidCallback? onRemoveAttachment;
  final VoidCallback? onDownloadAttachment;
  final VoidCallback? onDeleteAttachment;

  final VoidCallback? onDisabledTapped;
  final VoidCallback? onLimitExceeded;
  const CustomFilePickerWidget({
    super.key,
    this.isRequired = true,
    this.readOnly = false,
    this.uploaded = false,
    //
    this.label,
    this.labelStyle,
    //
    this.btnWidth,
    this.btnHeight = 55.0,
    this.filledColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = 8.0,
    this.btnPadding,
    //
    this.noFileChosenWord,
    this.fileName,
    this.fileNameStyle,
    //
    this.errorText,
    //
    this.fileType = FileType.custom,
    this.allowedLimit = 2,
    this.allowedExtensions = const [],
    //
    required this.onUploadAttachment,
    this.onDownloadAttachment,
    this.onDeleteAttachment,
    this.onRemoveAttachment,
    //
    this.onDisabledTapped,
    this.onLimitExceeded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label word
        WidgetLabel(isRequired: isRequired, label: label, labelStyle: labelStyle),
        // Button
        LayoutBuilder(
          builder: (_, constraints) {
            return Row(
              children: [
                // Button
                CustomElevatedIconButtonWidget(
                  btnAlignment: MainAxisAlignment.spaceBetween,
                  btnPadding: _btnPadding,
                  btnElevation: 0.0,
                  btnWidth: constraints.maxWidth - btnCalculatedWidth,
                  btnHeight: btnHeight,
                  btnColor: btnColor,
                  btnBorderColor: btnBorderColor,
                  btnBorderWidth: borderWidth,
                  btnRadius: borderRadius,
                  text: _FileNameWidget(status: fileStatus, fileName: fileName ?? noChosenFile),
                  textStyle: btnTextStyle,
                  icon: const Icon(Icons.upload_rounded, size: 22.0),
                  iconAlignment: AlignmentDirectional.centerEnd,
                  onPressed: readOnly ? onDisabledTapped : () async => await _onPickFile(context),
                ),
                //! Actions
                if (!uploaded && onRemoveAttachment != null)
                  _FileIconButton(
                    startPadding: 12.0,
                    icon: Icons.remove_circle_outline,
                    onPressed: onRemoveAttachment!,
                  ),
                if (uploaded && onDownloadAttachment != null)
                  _FileIconButton(startPadding: 12.0, icon: Icons.download_rounded, onPressed: onDownloadAttachment!),
                if (uploaded && onDeleteAttachment != null)
                  _FileIconButton(
                    startPadding: 8.0,
                    icon: Icons.delete_forever_rounded,
                    onPressed: onDeleteAttachment!,
                  ),
              ],
            );
          },
        ),

        // Error
        ErrorUnderWidget(errorText: errorText),
      ],
    );
  }

  FileSelectorStatus get fileStatus => fileName == null ? FileSelectorStatus.unselected : FileSelectorStatus.selected;

  String get noChosenFile => noFileChosenWord ?? "attachFileButton".tr();

  TextStyle get btnTextStyle => fileNameStyle ?? AppStyle.textButtonStyle;

  Color get btnColor => filledColor ?? AppColor.gray.withValues(alpha: 0.65);
  Color get btnBorderColor => borderColor ?? AppColor.gray;
  EdgeInsetsGeometry get _btnPadding => btnPadding ?? const EdgeInsets.symmetric(horizontal: UIHelper.middlePadding);

  double get btnCalculatedWidth => uploaded && onDeleteAttachment != null && onDownloadAttachment != null
      // 12.0: space between button and first icon
      // 22.0 * 2: size of two icons (Download&Delete Attachment)
      // 8.0 * 1: space between icon and other icon
      ? 12.0 + (22.0 * 2) + (8.0 * 1)
      : !uploaded && onRemoveAttachment != null
      ? 12.0 + 22.0
      : 0.0;

  Future<void> _onPickFile(BuildContext context) async {
    final type = (fileType == FileType.custom && allowedExtensions.isEmpty) ? FileType.any : fileType;

    if (type == FileType.image) {
      await BottomSheetDialog.showSheet<dynamic>(
        context,
        child: PickImageComponent(
          onPickedImage: onUploadAttachment,
          onLimitExceeded: onLimitExceeded ?? _showExceedsMsg,
        ),
      );
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: type, allowedExtensions: allowedExtensions);
      await _checkResult(result, onSelectedAttachment: onUploadAttachment);
    }
  }

  Future<void> _checkResult(FilePickerResult? result, {required void Function(FileInfo) onSelectedAttachment}) async {
    try {
      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        final sizeInBytes = file.size;
        // The Megabyte is the equivalent of 1024 kilobytes or 1,048,576 bytes
        // final sizeInMB = (sizeInBytes / 1048576).round();
        final sizeInMB = CommonFunctions.convertBytesToMB(sizeInBytes);

        if (_checkFileSize(sizeInMB)) {
          final fileInfo = await CommonFunctions.getFileInfo(file);
          onSelectedAttachment(fileInfo);
        } else {
          onLimitExceeded != null ? onLimitExceeded!() : _showExceedsMsg();
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
    }
  }

  bool _checkFileSize(int size) => size <= allowedLimit;

  void _showExceedsMsg() async {
    final context = NavigationService.navigatorKey.currentContext!;
    final msg = "popUpUploadFileLimitExceedsMessage".tr().replaceAll("{}", allowedLimit.toString());
    await MessageDialog.showWarning(context, msg);
  }
}

class _FileNameWidget extends StatelessWidget {
  final FileSelectorStatus status;
  final String fileName;
  const _FileNameWidget({required this.status, required this.fileName});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case FileSelectorStatus.unselected:
        return CustomTextWidget(
          fileName,
          textStyle: AppStyle.mainTextThirdStyle.copyWith(fontSize: 14.0, color: AppColor.black),
        );
      case FileSelectorStatus.selected:
        return Container(
          // width: 110.0,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: AppColor.white,
            border: Border.all(color: AppColor.blue),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: CustomTextWidget(
            fileName,
            textStyle: AppStyle.mainTextThirdStyle.copyWith(fontSize: 11.0, color: AppColor.black),
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
        );
    }
  }
}

class _FileIconButton extends StatelessWidget {
  final double startPadding;
  final IconData icon;
  final VoidCallback onPressed;
  const _FileIconButton({required this.startPadding, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: startPadding),
      child: CustomIconButtonWidget(
        btnWidth: 22.0,
        btnHeight: 22.0,
        icon: icon,
        iconColor: icon == Icons.remove_circle_outline ? AppColor.error : null,
        iconSize: 22.0,
        onPressed: onPressed,
      ),
    );
  }
}
