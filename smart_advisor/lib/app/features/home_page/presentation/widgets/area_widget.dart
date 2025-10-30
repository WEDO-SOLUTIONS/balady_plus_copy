import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';

class AreaWidget extends StatefulWidget {
  final String title;
  final String? description;
  final bool isSelected;
  final bool isActive;
  final Function onSelect;
  final bool hasBorder;
  final double? height;

  const AreaWidget({
    super.key,
    required this.title, // Defining title
    this.description, // Defining description
    required this.isSelected, // Defining isSelected
    required this.isActive, // Defining isActive
    required this.onSelect,
    this.height,
    this.hasBorder = false,
  });

  @override
  State<AreaWidget> createState() => _AreaWidgetState();
}

class _AreaWidgetState extends State<AreaWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isActive) {
          widget.onSelect();
        }
      },
      child: Container(
        height: widget.height ?? 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isActive ? Colors.white : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: widget.hasBorder && widget.isSelected
                  ? const Color(0xff568F64)
                  : const Color(0xffE9EEF5)),
        ),
        child: Row(
          children: [
            FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                height: 22,
                width: 22,
                child: SvgPicture.asset(
                  widget.isSelected
                      ? 'packages/smart_advisor/smart_advisor_assets/icons/svg/Radio.svg'
                      : 'packages/smart_advisor/smart_advisor_assets/icons/svg/Radionotselected.svg',
                  height: 22,
                  width: 22,
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: AppStyle.textRegularRomanStyle.copyWith(
                      color: widget.isActive
                          ? AppColor.textPrimaryColor
                          : const Color(0xFFC2C5C9),
                    ),
                  ),
                  const SizedBox(height: 2),
                  widget.description != null
                      ? Flexible(
                          child: AutoSizeText(
                            widget.description!,
                            style: AppStyle.footNoteRomanStyle.copyWith(
                              color: widget.isActive
                                  ? AppColor.textSecondaryColor
                                  : const Color(0xffD9DBDD),
                              height: 1.6,
                            ),
                            maxLines: 10,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
