import 'package:flutter/material.dart';

import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../shared_feature_exports.dart';
import 'package:flutter_html/flutter_html.dart';

class NotesWidget extends StatelessWidget {
  const NotesWidget({
    super.key,
    required this.notes,
  });

  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: AppColor.primary50Light,
          ),
          child: ListView.separated(
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: notes.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, index) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Icon(Icons.circle,
                      size: 5, color: AppColor.primary500Light),
                ),
                const SizedBox(width: 6),
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
                          fontFamily: Constants.appFontType),
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
