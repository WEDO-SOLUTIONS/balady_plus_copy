import 'dart:convert';
import 'dart:io';

import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../app/core/utils/common_functions.dart';
import '../../../../../app/features/_shared_feature_/data/entities/file_data_item.dart';
import '../../../../../app/features/_shared_feature_/presentation/buttons/elevated_icon_button_widgets.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../../app/features/objectable_transactions/presentation/widgets/create_objection_page/objection_reason_attachment.dart';
import '../blocs/bidding_form/bidding_form_bloc.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class BidddingUploadWidget extends StatelessWidget {
  const BidddingUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BiddingFormBloc, BiddingFormState>(
      builder: (context, state) {
        if (state.uploadBidAttachmentResponse == null)
          return ElevatedIconButtonWidget.upload(
            onPressed: () async {
              FileDataItem? file = await openFilePicker(
                  FileType.custom, context,
                  allowedExtensions: ["pdf"]);
              if (file != null)
                context
                    .read<BiddingFormBloc>()
                    .add(UploadBiddingAttachmentEvent(file: file));
            },
          );
        if (state.uploadBidAttachmentResponse != null &&
            state.attachmentPath != null)
          return ObjectionReasonAttachment(
            onDelete: () {
              context
                  .read<BiddingFormBloc>()
                  .add(RemoveBiddingAttachmentEvent());
            },
            fileName: state.attachmentName ?? "",
            filePath: state.attachmentPath ?? "",
          );

        return Container();
      },
    );
  }

  Future<FileDataItem>? openFilePicker(FileType fileType, BuildContext c,
      {List<String>? allowedExtensions}) async {
    var file = await FilePicker.platform.pickFiles(
      type: fileType,
      allowMultiple: false,
      allowedExtensions: allowedExtensions != null
          ? allowedExtensions
          : fileType == FileType.custom
              ? ['jpg', 'pdf', 'jpeg', 'png']
              : null,
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
            FileDataItem file = FileDataItem(
              fileBase64: base64File,
              fileName: fileName,
              filePath: path,
              bytes: fileBytes,

              //  sizeInMB: CommonFunctions.convertBytesToMB(platformFile.size),
            );
            return file;
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
    return Future.value(null);
  }
}
