import '../../../../../core/services/local/navigation_services.dart';
import '../../../../shared_features/widgets/text_item_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class GeneralItemsDialog extends StatelessWidget {
  final String title;
  final List<String> items;
  const GeneralItemsDialog(
      {super.key, required this.items, required this.title});

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
        child: SingleChildScrollView(
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
                        NavigationService.navigatorKey.currentState!
                            .pop(context);
                      },
                      child: SvgPicture.asset(
                          'packages/smart_advisor/smart_advisor_assets/images/close.svg')),
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
                    return TextItemComponent(description: items[index]);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
