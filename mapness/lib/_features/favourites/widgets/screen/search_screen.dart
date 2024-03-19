import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/widgets/search/favourite_text_field.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/ui/search_history.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SearchScreen extends ConsumerWidget {

  const SearchScreen({
    required this.itemBuilder,
    required this.itemCount,
    required this.onBackTap,
    this.hintText,
    super.key,
    this.onHistoryItemTap,
  });
  final VoidCallback onBackTap;
  final int itemCount;
  final String? hintText;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final void Function(SearchHistoryItem? item)? onHistoryItemTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        backgroundColor: context.color.surface_base_primary,
        body: Column(
          children: [
            Container(
              color: context.color.surface_base_primary,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: MediaQuery.of(context).padding.top + 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FavouriteTextField(hintText: hintText),
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
            SearchHistory(
              skipEmptyObjects: true,
              onTap: (item) {
                onHistoryItemTap?.call(item);
              },
            ),
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                itemCount: itemCount,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: itemBuilder,
              ),
            ),
          ],
        ),
      );
}
