import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CleanContractWidget extends StatefulWidget {
  const CleanContractWidget({
    super.key,
  });

  @override
  State<CleanContractWidget> createState() => _CleanContractWidgetState();
}

class _CleanContractWidgetState extends State<CleanContractWidget> {
  int value = -1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("هل يوجد عقد نظافه ؟",
                textAlign: TextAlign.start,
                style: GoogleFonts.cairo(
                  color: const Color(0xFF1A1A1A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Radio<int>(
                    value: 1,
                    activeColor: const Color(0xff447F91),
                    groupValue: value,
                    onChanged: (int? v) {
                      value = v ?? -1;
                      setState(() {});
                    }),
                Text("نعم",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.cairo(
                      color: const Color(0xFF1A1A1A),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
            Row(
              children: [
                Radio<int>(
                    value: 2,
                    activeColor: const Color(0xff447F91),
                    groupValue: value,
                    onChanged: (int? v) {
                      value = v ?? -1;
                      setState(() {});
                    }),
                Text("لا",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.cairo(
                      color: const Color(0xFF1A1A1A),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ],
        )
      ],
    );
  }
}
