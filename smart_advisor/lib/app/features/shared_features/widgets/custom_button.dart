import '/app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  final Function onPress;
  final String text;
  final Color? btnColor;
  final Color? textColor;
  final Color? btnShadowColor;
  final Color? btnEffectColor;
  final double btnHeight;
  final double? btnWidth;
  final double btnRadius;
  final Color? btnBorderColor;
  final double btnElevation;
  final AlignmentGeometry? btnAlignment;
  final EdgeInsetsGeometry? btnPadding;
  final EdgeInsetsGeometry? btnMargin;
  final double btnBorderWidth;
  final bool isDisabled;

  const CustomButton(
      {super.key,
      required this.onPress,
      required this.text,
      this.btnColor,
      this.btnShadowColor,
      this.btnEffectColor,
      this.textColor,
      this.btnHeight = 55.0,
      this.btnWidth,
      this.btnRadius = 8.0,
      this.btnBorderColor,
      this.btnBorderWidth = 1.0,
      this.btnElevation = 2.0,
      this.btnAlignment,
      this.btnPadding,
      this.btnMargin,
      this.isDisabled = false});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.btnMargin,
      child: ElevatedButton(
          onPressed: () => widget.onPress(),
          style: ElevatedButton.styleFrom(
            foregroundColor: widget.isDisabled
                ? const Color.fromRGBO(202, 211, 218, 1)
                : widget.btnEffectColor ??
                    widget.btnColor ??
                    AppColor.statusAccentColor,
            padding: widget.btnPadding ?? EdgeInsets.zero,
            backgroundColor: widget.isDisabled
                ? const Color.fromRGBO(202, 211, 218, 1)
                : widget.btnColor ?? AppColor.statusAccentColor,
            // shadowColor: Colors.pink,
            shadowColor: widget.btnShadowColor ?? widget.btnColor,
            alignment: widget.btnAlignment ?? Alignment.center,
            elevation: widget.btnElevation,
            minimumSize:
                Size(widget.btnWidth ?? double.infinity, widget.btnHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.btnRadius),
            ),
            side: BorderSide(
              width: widget.btnBorderWidth,
              color: widget.btnBorderColor ?? Colors.transparent,
            ),
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.cairo(
                color: widget.textColor ?? Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15),
          )),
    );
  }
}
