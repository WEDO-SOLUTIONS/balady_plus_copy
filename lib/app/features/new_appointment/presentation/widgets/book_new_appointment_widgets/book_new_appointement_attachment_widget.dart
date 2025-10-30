import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class AppintmentAttachmentViewWidget extends StatelessWidget {
  final Function deleteFile;
  final String? path;
  final String? fileName;
  const AppintmentAttachmentViewWidget({
    this.path,
    this.fileName,
    required this.deleteFile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 5),
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
              /*   Image.asset("assets/images/attachmentIcon@3x.png",
                  height: 32, width: 32),
              const SizedBox(width: 10),*/
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
                deleteFile();
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
