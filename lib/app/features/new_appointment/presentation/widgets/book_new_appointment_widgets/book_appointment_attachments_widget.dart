import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/pickers/custom_file_picker_widget.dart';
import 'book_appointment_details_header_section_card_widget.dart';

class BookAppointmentAttachmentsWidget extends StatefulWidget {
  final Function(dynamic) onUploadedFile;
  const BookAppointmentAttachmentsWidget({
    Key? key,
    required this.onUploadedFile,
  }) : super(key: key);

  @override
  State<BookAppointmentAttachmentsWidget> createState() =>
      _BookAppointmentAttachmentsWidgetState();
}

class _BookAppointmentAttachmentsWidgetState
    extends State<BookAppointmentAttachmentsWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookAppointmentDetailsHeaderSectionCardWidget(
          icon: Constants.attachmentIcon,
          title: ("bookNewAppointmentAttachmentsWord").tr(),
          subTitle: ("bookNewAppointmentUnreadableContentWord").tr(),
        ),
        Constants.verticalSpaceMedium,
        //MM

        /*  CustomFilePickerWidget(
          label: "",
          errorText: "",
          noFileChosenWord: (
            "bookNewAppointmentAttachmentFileButtonWord",
          ),
          listOfFileExtensions: const [],
          noticeWord: "",
          allowedLimit: 10,
          onSavedFile: widget.onUploadedFile,
          onDeleteFile: () => widget.onUploadedFile(null),
        ),*/
      ],
    );
  }
}
