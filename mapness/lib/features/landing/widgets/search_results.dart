import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/common/config/package_fonts.dart';
import 'package:mapness/features/landing/providers/dashboard_scroll.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';
import 'package:mapness/features/landing/providers/search_history.dart';
import 'package:mapness/features/map/providers/search.dart';
import 'package:mapness/legacy_features/routing_page/data/directory_object_ext.dart';

class SearchResults extends ConsumerStatefulWidget {
  const SearchResults({super.key});

  @override
  ConsumerState<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends ConsumerState<SearchResults> {
  bool hasNext = true;

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchProvider);
    final searchController = ref.watch(searchProvider.notifier);

    ref.listen(
      dashboardScrollProvider,
      (previous, next) {
        if (next == null) return;

        double delta = MediaQuery.of(context).size.height * 0.2;

        if (next.max - next.current <= delta) {
          searchController.fetchNext().then(
            (hasNext) {
              setState(() {
                this.hasNext = hasNext;
              });
            },
          );
        }
      },
    );

    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(
        left: 16,
        bottom: 16,
        right: 16,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == results.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
        }

        return SearchResult(
          result: results[index],
        );
      },
      itemCount: results.length + (hasNext ? 1 : 0),
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 16,
        );
      },
    );
  }
}

class SearchResult extends ConsumerWidget {
  const SearchResult({
    super.key,
    required this.result,
  });

  final DirectoryObjectMessage result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref
            .read(mapControlsProvider.notifier)
            .update(MapControlsStatePoI(result.id!));
        ref.watch(searchHistoryProvider.notifier).put(
              HistoryItem.fromDirectoryObject(result),
            );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.title,
              overflow: TextOverflow.ellipsis,
              style: PackageFonts.frutigerArabic(
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E2A36),
              ),
            ),
            Row(
              children: [
                Text(
                  result.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: PackageFonts.frutigerArabic(
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xB21E2A36),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                const Spacer(),
                Text(
                  "1.3 km",
                  overflow: TextOverflow.ellipsis,
                  style: PackageFonts.frutigerArabic(
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xB21E2A36),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              result.makeAddress(),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: PackageFonts.frutigerArabic(
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: const Color(0xB21E2A36),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
