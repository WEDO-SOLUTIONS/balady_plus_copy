import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../domain/entities/request_details_response.dart';
import '../details_bloc/crm_details_bloc.dart';

class AttachmentViewSection extends StatefulWidget {
  final String? incidentNumber;
  const AttachmentViewSection({Key? key, this.incidentNumber})
      : super(key: key);

  @override
  State<AttachmentViewSection> createState() => _AttachmentViewSectionState();
}

class _AttachmentViewSectionState extends State<AttachmentViewSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrmDetailsBloc, CrmDetailsState>(
      builder: (context, state) {
        List<AttachmentList> attachmentList = [];
        if (state.crmRequestType != RequestsType.DC &&
            state.crmRequestType != RequestsType.VHR) {
          attachmentList = state.details?.attachmentList ?? [];
        } else {
          attachmentList = state.requestDetails?.attachmentList ?? [];
        }

        return Visibility(
            visible: attachmentList.isNotEmpty,
            child: DaemAttachmenntList(
              files: attachmentList,
              onPress: (AttachmentList item) {
                context.read<CrmDetailsBloc>().add(DownloadFileEvent(
                    item: item, daemKey: widget.incidentNumber));
              },
            ));
      },
    );
  }
}

class DaemAttachmenntList extends StatelessWidget {
  final List<AttachmentList> files;
  final Function onPress;
  const DaemAttachmenntList(
      {Key? key, required this.files, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List<Widget>.from(files.map((e) {
      return AttachmentItem(
        file: e,
        onPress: onPress,
      );
    }).toList()));
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
      },
      child: Container(
          height: 56,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
          color: AppColor.white4,
          child: Row(
            children: [
              Constants.horizontalSpaceSmall,
              // attachment name
              Expanded(
                child: CustomTextWidget(
                  widget.file.pyMemo ?? "",
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
