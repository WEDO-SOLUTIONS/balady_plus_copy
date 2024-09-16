import 'package:flutter/material.dart';

import '../../../core/utils/constants/app_colors.dart';

class ObjectionCard extends StatefulWidget {
  final String title;
  final String details;
  const ObjectionCard({super.key, required this.title, required this.details});

  @override
  State<ObjectionCard> createState() => _ObjectionCardState();
}

class _ObjectionCardState extends State<ObjectionCard> {
  final isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: AppColor.surfaceSecondaryColor,
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: const TextStyle(
                  fontFamily: "Medium", fontSize: 20, color: Colors.black),
            ),
            /* subtitle: Text(
              widget.details,
              style: const TextStyle(
                  fontFamily: "Regular", fontSize: 18, color: Colors.black45),
            ),*/
          ),
        ],
      ),
    );
  }
}
