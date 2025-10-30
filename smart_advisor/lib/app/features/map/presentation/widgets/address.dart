import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/local/navigation_services.dart';
import '/app/features/map/presentation/widgets/region.dart';
import '/app/features/shared_features/widgets/custom_button.dart';

class Address extends StatelessWidget {
  const Address({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الرياض",
            style: GoogleFonts.cairo(
              color: const Color(0xFF000000),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            " طريق الملك عبدالعزيز7236, حي الغدير ",
            style: GoogleFonts.cairo(
              color: const Color(0xFF8E8E93),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          CustomButton(
              onPress: () {
                NavigationService.navigatorKey.currentState!
                    .push(MaterialPageRoute(builder: (ctx) {
                  return const Region();
                }));
              },
              text: "تأكيد الموقع")
        ],
      ),
    );
  }
}
