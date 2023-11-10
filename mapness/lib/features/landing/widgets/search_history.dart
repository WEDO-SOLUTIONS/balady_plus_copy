import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/features/common/config/package_fonts.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';
import 'package:mapness/features/landing/providers/search_history.dart';

class SearchHistory extends ConsumerWidget {
  const SearchHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchHistoryProvider).reversed.toList();

    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: index == 0
                ? const Radius.circular(8)
                : const Radius.circular(0),
            topRight: index == 0
                ? const Radius.circular(8)
                : const Radius.circular(0),
            bottomLeft: index == results.length - 1
                ? const Radius.circular(8)
                : const Radius.circular(0),
            bottomRight: index == results.length - 1
                ? const Radius.circular(8)
                : const Radius.circular(0),
          ),
          child: InkWell(
            onTap: () {
              ref.watch(mapControlsProvider.notifier).update(
                    MapControlsStatePoI(
                      DgisObjectIdMessage(
                        objectId: results[index].objectId!,
                        entranceId: results[index].entranceId!,
                      ),
                    ),
                  );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SearchHistoryRow(
                result: results[index],
              ),
            ),
          ),
        );
      },
      itemCount: results.length,
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.white,
          child: const Padding(
            padding: EdgeInsets.only(right: 56),
            child: Divider(
              thickness: 1,
              height: 2,
              color: Color(0x17022224),
            ),
          ),
        );
      },
    );
  }
}

class SearchHistoryRow extends StatelessWidget {
  const SearchHistoryRow({
    super.key,
    required this.result,
  });

  final HistoryItem result;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/icons/svg/ic_history.svg",
            semanticsLabel: 'MinApps Screen',
            package: "mapness",
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
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
                if (result.address.isNotEmpty)
                  Text(
                    result.address,
                    overflow: TextOverflow.ellipsis,
                    style: PackageFonts.frutigerArabic(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                      color: const Color(0x801E2A36),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
