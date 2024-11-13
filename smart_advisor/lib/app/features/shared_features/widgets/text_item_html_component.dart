import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:smart_advisor/app/core/utils/constants/language.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/webview_page.dart';

import '../../../core/utils/constants/app_style.dart';
import '../../../core/utils/utils_exports.dart';
import '../../documents/general_commercial_conditions.dart';
import 'package:smart_advisor/app/features/home_page/presentation/pages/pdf_viwer.dart';

class TextItemHtmlComponent extends StatelessWidget {
  final String description;
  final String? title;
  const TextItemHtmlComponent(
      {super.key, required this.description, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Html(
        data: description, // Your HTML data
        onLinkTap: (url, attributes, element) {
          if (url ==
              "https://ebalady.momra.gov.sa/activityapi/activities/attachments/3DAED66AD304490489C261CF34AAF9EA/download") {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return GeneralCommercialConditionPage();
            }));
          } else {
            /* Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return WebViewPage(
                url: url ?? "",
                title: "details".tr(),
              );
            }));*/

            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) =>
                    PDFViewer(url: url?.trim() ?? "", text: "details".tr())));
          }
        },
        style: {
          // Apply style to the body tag
          "body": Style(
            fontFamily: AppStyle.textRegularStyle.fontFamily,
            fontSize: FontSize(
                AppStyle.textRegularStyle.fontSize ?? 14), // Set font size
            color: AppColor.textPrimaryColor, // Set color
            fontWeight: AppStyle.textRegularStyle.fontWeight,
          ),
        },
      ),
    );
  }
}
