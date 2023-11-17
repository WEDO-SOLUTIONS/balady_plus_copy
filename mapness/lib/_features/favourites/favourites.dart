// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
import 'package:mapness/_features/favourites/widgets/delete_all/delete_all_content.dart';
import 'package:mapness/_features/favourites/widgets/empty_result_widget.dart';
import 'package:mapness/_features/favourites/widgets/favourites_header.dart';
import 'package:mapness/_features/favourites/widgets/screen/favourite_item_widget.dart';
import 'package:mapness/_features/favourites/widgets/screen/favourites_toggle.dart';
import 'package:mapness/_features/favourites/widgets/screen/pinned_place_widget.dart';
import 'package:mapness/app/routes/favourites.dart';

class Favourites extends ConsumerStatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  ConsumerState<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends ConsumerState<Favourites> {
  bool isEditing = false;
  OverlayEntry? _overlay;

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _deleteItem(FavouriteItem item) {
    ref.read(favouriteRepositoryProvider.notifier).delete(item);
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(favouriteRepositoryProvider);

    if (asyncState.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (asyncState.hasError) {
      return Center(child: Text(asyncState.error.toString()));
    }
    final state = asyncState.requireValue;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              color: Color(0x1242909B),
              child: SafeArea(
                bottom: false,
                child: FavouritesHeader(
                  isEditing: isEditing,
                  onEditTap: toggleEditing,
                  onDoneTap: toggleEditing,
                  onDeleteAllTap: () {
                    _overlay = OverlayEntry(
                      builder: (_) => DeleteAllContent(
                        onConfirm: () {
                          if (!ref.context.mounted) {
                            _overlay?.remove();
                            return;
                          }

                          ref
                              .read(favouriteRepositoryProvider.notifier)
                              .deleteAll();
                          _overlay?.remove();
                        },
                        onCancel: () => _overlay?.remove(),
                      ),
                    );
                    Overlay.of(context, rootOverlay: true).insert(_overlay!);
                  },
                ),
              ),
            ),

            /// head items
            Ink(
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                // color: const Color(0x1142909B),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FavouritesToggle(isEditing: isEditing),
                  SizedBox(height: 8),
                  PinnedPlaceWidget(
                    key: Key(state.home?.id ?? 'home'),
                    title: state.home?.title ?? 'Home',
                    address: state.home?.subtitle ?? 'Add address',
                    iconAsset: 'assets/icons/svg/ic_home.svg',
                    isEditing: isEditing,
                    isAdded: state.home != null,
                    onDelete: () => _deleteItem(state.home!),
                    onTap: state.home != null
                        ? null
                        : () => FavouritesSearchRoute(
                              markerType: FavouriteItemMarkerType.home,
                            ).push(context),
                  ),
                  SizedBox(height: 8),
                  PinnedPlaceWidget(
                    key: Key(state.work?.id ?? 'work'),
                    title: state.work?.title ?? 'Work',
                    address: state.work?.subtitle ?? 'Add address',
                    iconAsset: 'assets/icons/svg/ic_case.svg',
                    isEditing: isEditing,
                    isAdded: state.work != null,
                    onDelete: () => _deleteItem(state.work!),
                    onTap: state.work != null
                        ? null
                        : () => FavouritesSearchRoute(
                              markerType: FavouriteItemMarkerType.work,
                            ).push(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Color(0xffF4F4F5),
                child: state.items.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 63,
                        ),
                        child: EmptyResultWidget(
                          text:
                              'To save places and vacancies as favorites, open the card and tap the bookmark icon',
                        ),
                      )
                    :

                    /// items
                    ListView.separated(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                        ),
                        itemCount: state.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, index) {
                          final item = state.items[index];

                          /// item
                          return FavouriteItemWidget(
                            onDelete: () => _deleteItem(item),
                            isEditing: isEditing,
                            item: item,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
