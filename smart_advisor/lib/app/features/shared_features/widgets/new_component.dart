import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';

class CustomCardWithIconItem extends StatelessWidget {
  final String title;
  final String image;

  const CustomCardWithIconItem(
      {super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(134, 223, 231, 235),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: AppStyle.textRegularRomanStyle
                .copyWith(color: Color(0xFF17263D)),
          ),
        ],
      ),
    );
  }
}
