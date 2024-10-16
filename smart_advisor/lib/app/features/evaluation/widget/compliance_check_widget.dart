import '/app/core/utils/constants/language.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComplianceCheckWidget extends StatelessWidget {
  final String image;
  final Function(bool) onSelect;
  final String text;
  const ComplianceCheckWidget(
      {super.key,
      required this.image,
      required this.onSelect,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 31,
        right: 18.5,
        left: 18.5,
      ),
      child: Stack(
        children: [
          Container(
            height: 548,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  //
                  image: AssetImage(image),
                  fit: BoxFit.fill),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Shadow color
                  spreadRadius: 2, // Shadow spread radius
                  blurRadius: 8, // Shadow blur radius
                  offset: Offset(0, 4), // Shadow offset
                ),
              ],
            ),
          ),
          Positioned(
            top: 400,
            left: 26,
            right: 38,
            child: Text(
              text,
              style: GoogleFonts.cairo(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 520, right: 50, left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    onSelect(true);
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.5), // Shadow color
                              spreadRadius: 2, // Shadow spread radius
                              blurRadius: 8, // Shadow blur radius
                              offset: Offset(0, 4), // Shadow offset
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 32,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        ("compliant").tr(),
                        style: GoogleFonts.cairo(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    onSelect(false);
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.5), // Shadow color
                              spreadRadius: 2, // Shadow spread radius
                              blurRadius: 8, // Shadow blur radius
                              offset: Offset(0, 4), // Shadow offset
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 32,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        ("non_compliant").tr(),
                        style: GoogleFonts.cairo(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
