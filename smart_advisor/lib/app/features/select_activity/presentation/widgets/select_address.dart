import '/app/core/utils/constants/language.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/features/details/presentation/pages/entity_details.dart';
import '/app/features/shared_features/widgets/custom_button.dart';

class SelectAddress extends StatefulWidget {
  const SelectAddress({super.key});

  @override
  State<SelectAddress> createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  bool isConfirmed = false;
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
          if (isConfirmed == true)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "اضف مساحه منشآتك",
                  style: GoogleFonts.cairo(
                    color: const Color(0xFF1A1A1A),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffEAEAEE), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff155F75), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffEAEAEE), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                    ),
                    suffixText: "متر مربع",
                    hintText: '30',

                    // You can add more InputDecoration properties as needed
                  ),
                )
              ],
            ),
          const SizedBox(
            height: 16,
          ),
          CustomButton(
            onPress: () {
              if (isConfirmed == false) {
                setState(() {
                  isConfirmed = true;
                });
              } else {
                /* Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return  EntityDetails();
                }));*/
              }
            },
            text: isConfirmed ? ("continue").tr() : ("confirm_location").tr(),
          )
        ],
      ),
    );
  }
}
