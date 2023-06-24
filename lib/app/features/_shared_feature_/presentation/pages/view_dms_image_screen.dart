import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../core/utils/constants/constants.dart';

class ViewDMSImageScreen extends StatefulWidget {
  final String url;
  const ViewDMSImageScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<ViewDMSImageScreen> createState() => _ViewDMSImageScreenState();
}

class _ViewDMSImageScreenState extends State<ViewDMSImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotoView(imageProvider: NetworkImage(widget.url)),
        Align(
          alignment: AlignmentDirectional.topStart,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              margin: EdgeInsetsDirectional.only(
                  top: MediaQuery.of(context).padding.top + 5, start: 12),
              child: Image.asset(
                Constants.imgPath + 'exit@3x.png',
                height: 38,
                width: 38,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
