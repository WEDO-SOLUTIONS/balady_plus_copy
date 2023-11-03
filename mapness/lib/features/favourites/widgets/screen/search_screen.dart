import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/favourites/providers/favourite_search.dart';
import 'package:mapness/features/favourites/widgets/search/favourite_text_field.dart';

class SearchScreen extends ConsumerWidget {
  final VoidCallback onNext;
  final Widget Function(BuildContext context, int index) itemBuilder;

  const SearchScreen({
    required this.itemBuilder,
    required this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResult = ref.watch(favouritesSearchProvider);

    return Scaffold(
      backgroundColor: const Color(0xfff4f4f5),
      body: Column(
        children: [
          Container(
            color: const Color(0xfff2f7f8),
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: MediaQuery.of(context).padding.top + 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Expanded(
                  child: FavouriteTextField(),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: onNext,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(CupertinoIcons.forward),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListView.separated(
                itemCount: searchResult.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: itemBuilder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
