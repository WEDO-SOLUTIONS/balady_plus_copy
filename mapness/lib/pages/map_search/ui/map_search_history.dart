import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/pages/map_search/ui/map_search_history_collapsible.dart';
import 'package:mapness/pages/map_search/ui/map_search_history_empty.dart';

class MapSearchHistory extends ConsumerWidget {
  const MapSearchHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchHistoryProvider).reversed.toList();

    return Column(
      children: [
        results.isEmpty
            ? const MapSearchHistoryEmpty()
            : MapSearchHistoryCollapsible(history: results),
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Container(
            height: 145,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Important events",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E2A36),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      "20 days ago",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                        color: const Color(0x801E2A36),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
