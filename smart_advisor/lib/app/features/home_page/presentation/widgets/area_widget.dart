import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';

class AreaWidget extends StatefulWidget {
  final String title;
  final String description;
  final bool isSelected;
  final bool isActive;
  final Function onSelect;

  const AreaWidget(
      {super.key,
      required this.title, // Defining title
      required this.description, // Defining description
      required this.isSelected, // Defining isSelected
      required this.isActive, // Defining isActive
      required this.onSelect});

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
        height: 105,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isActive ? Colors.white : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            FittedBox(
              fit: BoxFit.fill,
              child: Container(
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
                  Flexible(
                    child: Text(
                      widget.description,
                      style: AppStyle.footNoteRomanStyle.copyWith(
                        color: widget.isActive
                            ? AppColor.textSecondaryColor
                            : const Color(0xffD9DBDD),
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
