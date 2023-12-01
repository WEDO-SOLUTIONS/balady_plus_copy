import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
import 'package:mapness/_features/favourites/widgets/delete_all/delete_all_content.dart';
import 'package:mapness/_features/favourites/widgets/empty_result_widget.dart';
import 'package:mapness/_features/favourites/widgets/favourites_header.dart';
import 'package:mapness/_features/favourites/widgets/screen/favourite_item_widget.dart';
import 'package:mapness/_features/favourites/widgets/screen/favourites_toggle.dart';
import 'package:mapness/_features/favourites/widgets/screen/pinned_place_widget.dart';
import 'package:mapness/app/routes/favourites.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';

class Favourites extends ConsumerStatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  ConsumerState<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends ConsumerState<Favourites> {
  bool isEditing = false;

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
      return const Material(
        color: Color(0xffF4F4F5),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (asyncState.hasError) {
      return ErrorSheet(
        buttonLabel: 'Reload',
        onClose: () => context.pop(),
        onRetry: () {
          ref.invalidate(favouriteRepositoryProvider);
        },
      );
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
              color: const Color(0x1242909B),
              child: SafeArea(
                bottom: false,
                child: FavouritesHeader(
                  isEditing: isEditing,
                  onEditTap: toggleEditing,
                  onDoneTap: toggleEditing,
                  onDeleteAllTap: () async {
                    // TODO(someone): rewrite with nav 2.0 when gorouter fix bug
                    final result = await showDialog(
                      barrierColor: Colors.transparent,
                      useSafeArea: false,
                      context: context,
                      builder: (contextDialog) => ProviderScope(
                        parent: ProviderScope.containerOf(context),
                        child: Theme(
                          data: Theme.of(context),
                          child: MediaQuery(
                            data: MediaQuery.of(context),
                            child: Directionality(
                              textDirection: Directionality.of(context),
                              child: Localizations.override(
                                context: context,
                                child: DeleteAllContent(
                                  onConfirm: () =>
                                      Navigator.of(contextDialog).pop(true),
                                  onCancel: () =>
                                      Navigator.of(contextDialog).pop(false),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );

                    if (result == true) {
                      if (!ref.context.mounted) {
                        return;
                      }
                      ref
                          .read(favouriteRepositoryProvider.notifier)
                          .deleteAll();
                    }
                  },
                ),
              ),
            ),

            /// head items
            Ink(
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FavouritesToggle(isEditing: isEditing),
                  const SizedBox(height: 8),
                  PinnedPlaceWidget(
                    key: Key(state.home?.id ?? 'home'),
                    title: state.home?.title ?? context.l10n.home,
                    address: state.home?.subtitle ?? context.l10n.addAddress,
                    iconAsset: 'assets/icons/svg/ic_home.svg',
                    isEditing: isEditing && state.home != null,
                    isAdded: state.home != null,
                    onDelete: () => _deleteItem(state.home!),
                    onTap: state.home == null
                        ? () => const FavouritesSearchRoute(
                              markerType: FavouriteItemMarkerType.home,
                            ).push(context)
                        : () => PoiMapRoute(
                              dgisObjectId: int.parse(state.home!.entity!.id),
                            ).replace(context),
                  ),
                  const SizedBox(height: 8),
                  PinnedPlaceWidget(
                    key: Key(state.work?.id ?? 'work'),
                    title: state.work?.title ?? context.l10n.work,
                    address: state.work?.subtitle ?? context.l10n.addAddress,
                    iconAsset: 'assets/icons/svg/ic_case.svg',
                    isEditing: isEditing && state.work != null,
                    isAdded: state.work != null,
                    onDelete: () => _deleteItem(state.work!),
                    onTap: state.work == null
                        ? () => const FavouritesSearchRoute(
                              markerType: FavouriteItemMarkerType.work,
                            ).push(context)
                        : () => PoiMapRoute(
                              dgisObjectId: int.parse(state.work!.entity!.id),
                            ).replace(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xffF4F4F5),
                child: state.items.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 63,
                        ),
                        child: EmptyResultWidget(
                          text: context.l10n
                              .toSavePlacesAsFavoritesOpenTheCardAndTapTheBookmarkIcon,
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
