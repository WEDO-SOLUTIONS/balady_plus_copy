// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/favourites/domain/favourite_item.dart';
import 'package:mapness/features/favourites/providers/favourite_repository.dart';
import 'package:mapness/features/favourites/widgets/delete_all/delete_all_content.dart';
import 'package:mapness/features/favourites/widgets/empty_result_widget.dart';
import 'package:mapness/features/favourites/widgets/favourites_header.dart';
import 'package:mapness/features/favourites/widgets/screen/delete_icon.dart';
import 'package:mapness/features/favourites/widgets/screen/favourites_toggle.dart';
import 'package:mapness/features/favourites/widgets/screen/pinned_place_widget.dart';
import 'package:mapness/features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/routing/providers/app_router.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(favouriteRepositoryProvider.notifier).addItem(
                FavouriteItem(
                  coordinates: Coordinates(
                    latitude: 24.712301,
                    longitude: 46.674175,
                  ),
                  id: 'id',
                  subtitle: 'subtitle',
                  title: 'title',
                  entity: FavouriteItemEntity(
                    id: "70030076201324251",
                    sourceType: EntitySourceType.urbi,
                  ),
                ),
              );
        },
      ),
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
                    title: 'Home',
                    address: '137, Al Ittihad Road, Al Khabaisi, Deira, Dubai',
                    iconAsset: 'assets/icons/svg/ic_home.svg',
                    isEditing: isEditing,
                    isAddressHighlighted: false,
                    onDelete: () {},
                    onTap: () =>
                        context.pushNamed(AppRoute.favouritesSearch.name),
                  ),
                  SizedBox(height: 8),
                  PinnedPlaceWidget(
                    title: 'Work',
                    address: 'Add address',
                    iconAsset: 'assets/icons/svg/ic_case.svg',
                    isEditing: isEditing,
                    isAddressHighlighted: true,
                    onDelete: () {},
                    onTap: () =>
                        context.pushNamed(AppRoute.favouritesSearch.name),
                  ),
                ],
              ),
            ),
            Expanded(
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
                        return Dismissible(
                          onDismissed: (_) => ref
                              .read(favouriteRepositoryProvider.notifier)
                              .delete(item),
                          background: Ink(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xfff4383c),
                            ),
                          ),
                          key: Key(item.id),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(8),
                              child: Row(
                                children: [
                                  if (isEditing) ...[
                                    DeleteIcon(
                                      onPressed: () => ref
                                          .read(favouriteRepositoryProvider
                                              .notifier)
                                          .delete(item),
                                    ),
                                    SizedBox(width: 16),
                                  ],
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          item.title,
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff1e2936),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.subtitle,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: const Color(0xff346263),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
