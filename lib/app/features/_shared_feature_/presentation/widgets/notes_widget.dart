import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/utils_exports.dart';
import 'package:flutter_html/flutter_html.dart';

class NotesWidget extends StatelessWidget {
  const NotesWidget({
    super.key,
    required this.notes,
    this.showText,
    this.marginBottom,
    this.padding,
    this.separatorHeight,
    this.BgColor,
  });

  final List<String> notes;
  final bool? showText;
  final double? marginBottom;
  final double? padding;
  final double? separatorHeight;
  final Color? BgColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: padding ?? 12, horizontal: padding ?? 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: BgColor ?? AppColor.primary50Light,
          ),
          child: ListView.separated(
            separatorBuilder: (_, _) => SizedBox(height: separatorHeight ?? 8),
            itemCount: notes.length,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, index) => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Icon(Icons.circle, size: 5, color: AppColor.primary500Light),
                ),
                const SizedBox(width: 6),
                if (showText == true)
                  Flexible(
                    child: Linkify(
                      onOpen: (link) => CommonFunctions.openBaladyWebView(link.url),
                      text: notes[index],
                      softWrap: true,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color: AppColor.primary500Light,
                        fontFamily: Constants.appFontType,
                      ),
                    ),
                  ),
                if (showText != true)
                  Flexible(
                    child: Html(
                      data: notes[index],
                      onLinkTap: (url, attributes, element) {
                        CommonFunctions.openBaladyWebView(url);
                      },
                      style: {
                        "body": Style(
                          fontSize: FontSize(14.0),
                          fontWeight: FontWeight.w600,
                          lineHeight: const LineHeight(1.4),
                          textAlign: TextAlign.start,
                          color: AppColor.primary500Light,
                          fontFamily: Constants.appFontType,
                        ),
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: marginBottom ?? 24),
      ],
    );
  }
}
