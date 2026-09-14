import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../shared_feature_exports.dart' show CustomTextWidget, DrawIconBasedTypeWidget;

class ExpandableCard extends StatefulWidget {
  final String title;
  final String? icon;
  final String? badgeTitle;
  final List<Widget> children;
  final bool isExpandedByDefault;
  final Color? bgColor;

  const ExpandableCard({
    super.key,
    required this.title,
    this.icon,
    required this.children,
    this.isExpandedByDefault = false,
    this.badgeTitle,
    this.bgColor,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpandedByDefault;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: widget.bgColor ?? AppColor.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      widget.icon != null
                          ? DrawIconBasedTypeWidget(icon: widget.icon!, iconSize: 20)
                          : const SizedBox(),
                      const SizedBox(width: 4),
                      Flexible(
                        child: CustomTextWidget(widget.title, textStyle: AppStyle.cardTitleTextStle, maxLines: 2),
                      ),
                      widget.badgeTitle != null
                          ? Chip(
                              label: Text(
                                widget.badgeTitle!,
                                style: AppStyle.requestParamterTitleTextStle.copyWith(color: Colors.white),
                              ),
                              backgroundColor: const Color(0xfff1b074),
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),

                // const Spacer(),
                Container(
                  decoration: const BoxDecoration(color: AppColor.primary300Light, shape: BoxShape.circle),
                  child: Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColor.white),
                ),
              ],
            ),
          ),
          if (_isExpanded) ...widget.children,
        ],
      ),
    );
  }
}
