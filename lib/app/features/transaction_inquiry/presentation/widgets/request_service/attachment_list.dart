import 'package:flutter/material.dart';

import '../../../customer_voice_exports.dart'
    show AttachmentData, AttachmentWidget;

class AttachmentList extends StatefulWidget {
  final List<AttachmentData> attachments;
  final Function(int index, String filePath, String fileName, String base64)
      saveFile;
  final Function(int index) deleteFile;

  AttachmentList(
      {Key? key,
      required this.attachments,
      required this.saveFile,
      required this.deleteFile})
      : super(key: key);
  @override
  _AttachmentListState createState() => _AttachmentListState();
}

class _AttachmentListState extends State<AttachmentList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //MM
        /*CustomSectionHeaderWithImg(
            title: Helpers.translatingWord('bookNewAppointmentAttachmentsWord'),
            img: "attachment@3x.png"),*/
        AttachmentListWidget(
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

class AttachmentListWidget extends StatefulWidget {
  final List<AttachmentData> attachments;
  final Function(int index, String filePath, String fileName, String base64)
      saveFile;
  final Function(int index) deleteFile;

  const AttachmentListWidget(
      {Key? key,
      required this.attachments,
      required this.saveFile,
      required this.deleteFile})
      : super(key: key);

  @override
  State<AttachmentListWidget> createState() => _AttachmentListWidgetState();
}

class _AttachmentListWidgetState extends State<AttachmentListWidget> {
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
