import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/search/ui/search_scope.dart' as uiss;
import 'package:mapness/pages/map_search/ui/map_search_header_delegate.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'package:mapness/widgets/favourites/search/favourites_search_content.dart';

class FavouritesSearchScreen extends HookConsumerWidget {
  final VoidCallback onClose;
  final String? hintText;
  final void Function(String)? onChanged;
  final VoidCallback? onTapOfSearch;
  final DgisBottomSheetController _dgisSheetController = DgisBottomSheetController();
  final FavouriteItemMarkerType markerType;

  FavouritesSearchScreen({
    required this.onClose,
    required this.markerType,
    this.onChanged,
    this.hintText,
    super.key,
    this.onTapOfSearch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: DgisBottomSheet(
      key: const Key('MAP SEARCH SHEET KEY'),
      showBarrier: false,
      controller: _dgisSheetController,
      initialExpansion: Expansion.expanded,
      availableExpansions: const {Expansion.expanded},
      scrollableBody: (context, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(RadiusBorder.xl)),
        child: Material(
          color: context.colors.backgroundSurface4,
          child: uiss.SearchScope(
            named: uiss.SearchScopeEnum.favourites,
            child: CustomScrollView(
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  delegate: MapSearchHeaderDelegate(
                    backgroundColor: context.colors.backgroundSurface1,
                    requestFocus: true,
                    onClose: onClose,
                  ),
                  pinned: true,
                ),
                FavouritesSearchContent(scrollController: scrollController, markerType: markerType),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  const SearchHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  double get maxExtent => 72;

  @override
  double get minExtent => 72;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
