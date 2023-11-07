import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/favourites/widgets/search/favourite_text_field.dart';

class SearchScreen extends ConsumerWidget {
  final VoidCallback onBackTap;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  const SearchScreen({
    required this.itemBuilder,
    required this.itemCount,
    required this.onBackTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: onBackTap,
                    child: const SizedBox(
                      height: 40,
                      width: 40,
                      child: Icon(CupertinoIcons.forward),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: itemCount,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: itemBuilder,
            ),
          ),
        ],
      ),
    );
  }
}
