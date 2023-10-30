import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/common/config/package_fonts.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';
import 'package:mapness/features/map/providers/search.dart';
import 'package:mapness/legacy_features/routing_page/data/directory_object_ext.dart';

class SearchResults extends ConsumerWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchProvider);

    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return SearchResult(
          result: results[index],
        );
      },
      itemCount: results.length,
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
                color: Color(0xFF1E2A36),
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
                color: Color(0xB21E2A36),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
