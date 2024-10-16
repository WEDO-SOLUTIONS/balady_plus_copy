// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import '/app/core/utils/constants/language.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/tag.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Tag(
                text: "معلومات النشاط ",
                index: 0,
                currentIndex: currentIndex,
                onPress: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
              ),
              Tag(
                text: "التقييم الذاتي ",
                index: 1,
                currentIndex: currentIndex,
                onPress: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
              ),
              Tag(
                text: ("violations").tr(),
                index: 2,
                currentIndex: currentIndex,
                onPress: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
              ),
              Tag(
                text: " تقرير التشوه البصري ",
                index: 3,
                currentIndex: currentIndex,
                onPress: () {
                  setState(() {
                    currentIndex = 3;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
