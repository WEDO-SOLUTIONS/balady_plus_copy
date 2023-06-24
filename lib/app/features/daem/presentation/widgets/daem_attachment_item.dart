import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../data/models/daem_details_response.dart';

class DaemAttachmenntList extends StatelessWidget {
  final List<AttachmentList> files;
  final Function onPress;
  const DaemAttachmenntList(
      {Key? key, required this.files, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*  CustomSectionHeaderWithImg(
          title: Helpers.translatingWord('lbl_attachments'),
          img: "photo@3x.png",
        ),*/
        const CustomVerticalSpace(height: 16),
        Column(
            children: List<Widget>.from(files.map((e) {
          return AttachmentItem(
            file: e,
            onPress: onPress,
          );
        }).toList())),
      ],
    );
  }
}

class AttachmentItem extends StatefulWidget {
  AttachmentList file;
  final Function onPress;

  AttachmentItem({Key? key, required this.file, required this.onPress})
      : super(key: key);

  @override
  _AttachmentItemState createState() => _AttachmentItemState();
}

class _AttachmentItemState extends State<AttachmentItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPress(widget.file);
        //showFile(widget.file);
      },
      child: Container(
          height: 56,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
          color: AppColor.white4,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Image.asset("assets/images/attachmentIcon@3x.png",
                    height: 32, width: 32),
              ),
              Constants.horizontalSpaceSmall,
              // attachment name
              Expanded(
                child: CustomTextWidget(
                  widget.file.pyLabel ?? "",
                  fontColor: AppColor.black,
                  textAlign: TextAlign.start,
                  fontSize: 13.0,
                  maxLines: 1,
                ),
              ),
            ],
          )),
    );
  }
}
