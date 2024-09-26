import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';

import '/app/core/utils/constants/paths/icon_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Textfield extends StatelessWidget {
  final Function? onChanged;
  final Function? onSubmit;
  final Color? color;
  final TextEditingController? controller;

  final String? title;
  final bool? isEnabled;
  const Textfield(
      {super.key,
      this.onChanged,
      this.onSubmit,
      this.title,
      this.isEnabled = true,
      this.controller,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      //  padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white, // color ?? const Color(0xffE8EBEF),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Stack(
        children: [
          TextFormField(
            enabled: isEnabled,
            controller: controller,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsetsDirectional.only(start: 52, top: 5),
              border: InputBorder.none,

              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              hintText: title ?? 'ابحث هنا ...',

              hintStyle: AppStyle.textlargeRegularStyle
                  .copyWith(color: AppColor.textSecondaryColor),
              labelStyle: AppStyle.textlargeRegularStyle
                  .copyWith(color: AppColor.textSecondaryColor),

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
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: SvgPicture.asset(
                  IconPath.searchIcon,
                ),
              ))
        ],
      ),
    );
  }
}
