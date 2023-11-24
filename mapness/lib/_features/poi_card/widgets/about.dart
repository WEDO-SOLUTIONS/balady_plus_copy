import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/shared/config/package_fonts.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/make_address.dart';

class About extends StatefulWidget {
  final DirectoryObjectMessage? data;

  const About(this.data, {super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  int? exits;

  @override
  void initState() {
    exits = widget.data?.entrances.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final entrances = data?.entrances;
    return CardContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            data?.address?.buildingName ?? data?.title ?? '',
            style: GoogleFonts.inter(
              color: colorPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            data!.makeAddress(),
            style: GoogleFonts.inter(
              color: colorPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
            maxLines: 5,
            textAlign: TextAlign.start,
          ),
          if (entrances != null && entrances.isNotEmpty) ...[
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorPrimary.withAlpha(10),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Text(
                '${context.l10n.exits}${exits ?? ''}',
                style: PackageFonts.frutigerArabic(
                  color: colorPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
