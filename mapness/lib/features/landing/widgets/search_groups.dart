import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchGroups extends StatelessWidget {
  const SearchGroups({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        // reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              right: index == 0 ? 8.0 : 0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F8),
                borderRadius: BorderRadius.circular(8),
              ),
              width: 90,
              height: 90,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  left: 8.0,
                  bottom: 8.0,
                  right: 8.0,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/svg/ic_search_group.svg",
                        semanticsLabel: 'MinApps Screen',
                        package: "mapness",
                      ),
                      const Spacer(),
                      const Text(
                        "الغذاء",
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
