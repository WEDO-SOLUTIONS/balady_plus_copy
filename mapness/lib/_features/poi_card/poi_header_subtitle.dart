import 'package:flutter/material.dart';

class PoiHeaderSubtitle extends StatefulWidget {
  const PoiHeaderSubtitle({
    required this.subTitle,
    required this.subTitleTextStyle,
    required this.tabController,
    Key? key,
  }) : super(key: key);

  final String subTitle;
  final TextStyle subTitleTextStyle;
  final TabController tabController;

  @override
  State<PoiHeaderSubtitle> createState() => _PoiHeaderSubtitleState();
}

class _PoiHeaderSubtitleState extends State<PoiHeaderSubtitle> {
  var _isShowSubTitle = true;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      if (!widget.tabController.indexIsChanging) {
        setState(() {
          _isShowSubTitle = widget.tabController.index == 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: _isShowSubTitle ? 1 : 0,
        child: Text(
          widget.subTitle,
          style: widget.subTitleTextStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.start,
        ),
      );
}
