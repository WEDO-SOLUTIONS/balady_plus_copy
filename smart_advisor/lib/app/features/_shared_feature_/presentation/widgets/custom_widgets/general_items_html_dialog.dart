import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../shared_features/widgets/text_item_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared_features/widgets/text_item_html_component.dart';

class GeneralItemsHtmlDialog extends StatelessWidget {
  final String title;
  final List<String> items;
  const GeneralItemsHtmlDialog(
      {super.key, required this.items, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620,
      decoration: const BoxDecoration(
        color: Color(0xffF7F7F7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 16, left: 26),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                  ),
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColor.textPrimaryColor.withOpacity(.10),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                      )),
                ),
              ),
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
                        NavigationService.navigatorKey.currentState!
                            .pop(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColor.textPrimaryColor.withOpacity(0.70),
                        ),
                      ))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length ?? 0,
                  itemBuilder: (ctx, index) {
                    return TextItemHtmlComponent(description: items[index]);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
