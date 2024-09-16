import '/app/core/utils/constants/paths/icon_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Textfield extends StatelessWidget {
  final Function? onChanged;
  final Function? onSubmit;

  final String? title;
  final bool? isEnabled;
  const Textfield(
      {super.key,
      this.onChanged,
      this.onSubmit,
      this.title,
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xffE8EBEF),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Stack(
        children: [
          TextFormField(
            enabled: isEnabled,
            decoration: InputDecoration(
              contentPadding: EdgeInsetsDirectional.only(start: 32),
              border: InputBorder.none,
              hintText: title ?? 'ابحث',

              hintStyle: GoogleFonts.cairo(),
              labelStyle: GoogleFonts.cairo(
                color: const Color(0xFF8E8E93),
              ),

              // fontWeight: FontWeight.bold,
              //  errorText: 'Username is required',
            ),
            onChanged: (String t) {
              if (onChanged != null) onChanged!(t);
            },
            onFieldSubmitted: (String t) {
              if (onSubmit != null) onSubmit!(t);
            },
          ),
          //Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Align(
              alignment: AlignmentDirectional.centerStart,
              child: SvgPicture.asset(
                IconPath.searchIcon,
              ))
        ],
      ),
    );
  }
}
