import 'package:flutter/material.dart';

import '../../../transaction_inquiry/customer_voice_exports.dart';

class DaemAttachmentList extends StatefulWidget {
  final List<AttachmentData> attachments;
  final Function(int index, String filePath, String fileName, String base64)
      saveFile;
  final Function(int index) deleteFile;

  DaemAttachmentList(
      {Key? key,
      required this.attachments,
      required this.saveFile,
      required this.deleteFile})
      : super(key: key);
  @override
  _DaemAttachmentListState createState() => _DaemAttachmentListState();
}

class _DaemAttachmentListState extends State<DaemAttachmentList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /* CustomSectionHeaderWithImg(
            title: Helpers.translatingWord('bookNewAppointmentAttachmentsWord'),
            img: "attachment@3x.png"),*/
        DaemAttachmentListWidget(
          attachments: widget.attachments,
          deleteFile: (int index) {
            widget.deleteFile(index);
          },
          saveFile:
              (int index, String filePath, String fileName, String base64) {
            widget.saveFile(index, filePath, fileName, base64);
          },
        ),
      ],
    );
  }
}

class DaemAttachmentListWidget extends StatefulWidget {
  final List<AttachmentData> attachments;
  final Function(int index, String filePath, String fileName, String base64)
      saveFile;
  final Function(int index) deleteFile;

  const DaemAttachmentListWidget(
      {Key? key,
      required this.attachments,
      required this.saveFile,
      required this.deleteFile})
      : super(key: key);

  @override
  State<DaemAttachmentListWidget> createState() =>
      _DaemAttachmentListWidgetState();
}

class _DaemAttachmentListWidgetState extends State<DaemAttachmentListWidget> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: widget.attachments.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: AttachmentWidget(
              fileIndex: index,
              title: widget.attachments[index].title,
              isRequired: widget.attachments[index].isRequired,
              path: widget.attachments[index].filePath,
              fileName: widget.attachments[index].fileName,
              onPress: () {},
              hint: widget.attachments[index].hint,
              enableButton: (status) {},
              saveFile: widget.saveFile,
              deleteFile: widget.deleteFile,
            ),
          );
        },
      ),
    );
  }
}
