import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/services/local/navigation_services.dart';

class GeneralHtmlDialog extends StatelessWidget {
  final String title;
  final String html;
  const GeneralHtmlDialog({super.key, required this.html, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 45, right: 16, left: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                InkWell(
                    onTap: () {
                      NavigationService.navigatorKey.currentState!.pop(context);
                    },
                    child: SvgPicture.asset(
                        'packages/smart_advisor/smart_advisor_assets/images/close.svg')),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Html(data: html),
          ],
        ),
      ),
    );
  }
}
