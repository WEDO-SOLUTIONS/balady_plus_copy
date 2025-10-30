import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/features/_shared_feature_/presentation/models/license_issuance_model.dart';

class LicenseIssuanceList extends StatelessWidget {
  final List<LicenseIssuanceModel> item;

  LicenseIssuanceList({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: item.length,
          itemBuilder: (context, index) => Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item[index].title!,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.cairo(fontSize: 14),
                      ),
                      Image.asset(
                        item[index].icon!,
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (index != item.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      endIndent: 0,
                      color: Color(0xFFECEEEE),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
