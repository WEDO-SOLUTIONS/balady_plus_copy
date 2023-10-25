import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SuggestList extends StatelessWidget {
  const SuggestList({
    required this.items,
    required this.onItemTap,
    super.key,
  });

  final List<SuggestMessage> items;
  final Function(SuggestMessage) onItemTap;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          return InkWell(
            onTap: () => onItemTap(items[index]),
            child: Padding(
              padding: EdgeInsets.only(
                top: index == 0 ? 18 : 0,
                left: 18.0,
                right: 18.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              items[index].title.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                height: 1.33,
                              ),
                            ),
                            Text(
                              items[index].subtitle.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Color(0xff929292),
                                height: 1.23,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      SvgPicture.asset(
                        "assets/icons/svg/routing/ic_arrow_rising.svg",
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(height: 1, color: Colors.black12),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: items.length,
      ),
    );
  }
}
