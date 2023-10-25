import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/landing/providers/dashboard_controls.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';
import 'package:mapness/features/map/providers/search.dart';
import 'package:mapness/features/map/providers/suggest.dart';
import 'package:mapness/legacy_features/routing_page/data/directory_object_ext.dart';

class SuggestList extends ConsumerWidget {
  const SuggestList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggests = ref.watch(suggestResultsProvider).value ?? [];

    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(
        right: 16,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return SuggestItem(
          suggest: suggests[index],
        );
      },
      itemCount: suggests.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.only(right: 36.0),
          child: Divider(),
        );
      },
    );
  }
}

class SuggestItem extends ConsumerWidget {
  const SuggestItem({
    super.key,
    required this.suggest,
  });

  final SuggestMessage suggest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String icon = "";
    String? address;
    late void Function() tapHandler;
    if (suggest.handler.incompleteTextHandler != null) {
      icon = "text";
      tapHandler = () {
        ref
            .watch(suggestQueryProvider.notifier)
            .update(suggest.handler.incompleteTextHandler!.queryText);
      };
    } else if (suggest.handler.objectHandler != null) {
      icon = "object";
      tapHandler = () {
        ref.watch(mapControlsProvider.notifier).update(
            MapControlsStatePoI(suggest.handler.objectHandler!.item.id!));
      };
      address = suggest.handler.objectHandler!.item.makeAddress();
    } else if (suggest.handler.performSearchHandler != null) {
      icon = "search";
      tapHandler = () {
        ref
            .watch(dashboardControlsProvider.notifier)
            .update(DashboardControlsState.results);
        ref
            .watch(searchProvider.notifier)
            .searchByQuery(suggest.handler.performSearchHandler!.searchQuery);
      };
    }

    return GestureDetector(
      onTap: tapHandler,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/icons/svg/ic_suggest_$icon.svg",
              semanticsLabel: 'MinApps Screen',
              package: "mapness",
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      overflow: TextOverflow.ellipsis,
                      TextSpan(
                        children: _buildTitle(),
                      ),
                    ),
                    if (address != null && address.isNotEmpty)
                      Text(
                        address,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSansArabic(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                            color: Color(0x801E2A36),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<TextSpan> _buildTitle() {
    List<TextSpan> parts = [];
    final matchedParts = suggest.title.matchedParts
        .whereType<MarkedUpTextSpanMessage>()
        .toList();

    if (matchedParts.isEmpty) {
      return [
        TextSpan(
          text: suggest.title.text,
          style: GoogleFonts.notoSansArabic(
            textStyle: const TextStyle(
              fontSize: 16,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: Color(0x801E2A36),
            ),
          ),
        )
      ];
    }

    parts.add(
      TextSpan(
        text: suggest.title.text.substring(
          0,
          matchedParts[0].offset,
        ),
        style: GoogleFonts.notoSansArabic(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0x801E2A36),
          ),
        ),
      ),
    );

    for (var i = 0; i < matchedParts.length; i++) {
      parts.add(
        TextSpan(
          text: suggest.title.text.substring(
            matchedParts[i].offset,
            matchedParts[i].offset + matchedParts[i].length,
          ),
          style: GoogleFonts.notoSansArabic(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E2A36),
            ),
          ),
        ),
      );
      if (i != matchedParts.length - 1) {
        parts.add(
          TextSpan(
            text: suggest.title.text.substring(
              matchedParts[i].offset + matchedParts[i].length,
              matchedParts[i + 1].offset,
            ),
            style: GoogleFonts.notoSansArabic(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0x801E2A36),
              ),
            ),
          ),
        );
      }
    }
    parts.add(
      TextSpan(
        text: suggest.title.text.substring(
          matchedParts[matchedParts.length - 1].offset +
              matchedParts[matchedParts.length - 1].length,
        ),
        style: GoogleFonts.notoSansArabic(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0x801E2A36),
          ),
        ),
      ),
    );

    return parts;
  }
}
