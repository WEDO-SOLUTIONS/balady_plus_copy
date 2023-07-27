import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget;

class ExpandableCard extends StatefulWidget {
  final String title;
  final String icon;
  final List<Widget> children;
  final bool isExpandedByDefault;

  const ExpandableCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.isExpandedByDefault = false,
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
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              children: [
                DrawIconBasedTypeWidget(
                  icon: widget.icon,
                  iconSize: 20,
                ),
                const SizedBox(width: 4),
                CustomTextWidget(
                  widget.title,
                  textStyle: AppStyle.cardTitleTextStle,
                ),
                const Spacer(),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColor.primary300Light,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColor.white,
                  ),
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
