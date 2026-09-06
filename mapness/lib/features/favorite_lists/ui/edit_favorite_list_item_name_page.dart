import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_place_dto.dart';
import 'package:mapness/features/favorite_lists/providers/aggregated_favorite_markers.dart';
import 'package:mapness/features/favorite_lists/providers/custom_place_nickname.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_detail.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists.dart';
import 'package:mapness/features/favorite_lists/ui/show_favorite_lists_error_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class EditFavoriteListItemNamePage extends HookConsumerWidget {
  final String listId;
  final FavoriteListPlaceDto place;

  const EditFavoriteListItemNamePage({required this.listId, required this.place, super.key});

  static const _customNameMaxLength = 64;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(favoriteListDetailProvider(listId: listId)).value?.list;
    final place = list?.places?.firstWhereOrNull((e) => e.placeId == this.place.placeId) ?? this.place;
    final scrollController = useToggleSheetController(onClose: (_) => context.router.pop());

    final nameController = useTextEditingController(text: place.customName);
    final isSubmitting = useState(false);

    final value = useValueListenable(nameController);
    final trimmedLength = value.text.trim().length;
    final isTooLong = trimmedLength > _customNameMaxLength;
    final isValid = trimmedLength > 0 && !isTooLong;

    return ToggleSheet(
      scrollController: scrollController,
      backgroundColor: context.colors.backgroundSurface4,
      safeAreaColor: context.colors.backgroundSurface4,
      dragger: SheetDragger(draggerColor: context.colors.backgroundSurface5),
      outside: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.router.pop(),
        child: const SizedBox.expand(),
      ),
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            Text(
              context.l10n.name,
              style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                iconSize: 24,
                visualDensity: VisualDensity.compact,
                icon: Icon(SystemIcons.arrowCornerLeftLarge, color: context.colors.foregroundDefault),
                onPressed: context.router.pop,
              ),
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.all(Spacing.$4x),
      content: [
        BaladyTextInput(
          controller: nameController,
          inputState: isTooLong ? BaladyInputState.error : BaladyInputState.defaultValue,
          config: BaladyInputConfig(
            hintText: context.l10n.favoriteListCustomName,
            fillColor: context.colors.backgroundSurface1,
            hintColor: context.colors.foregroundSoft,
          ),
          supportingText: BaladySupportingText(
            text:
                '     ${isTooLong ? context.l10n.favoriteListNameTooLongError : context.l10n.favoriteListCustomNameHelperText}',
          ),
        ),
      ],
      footer: Padding(
        padding: const EdgeInsets.all(Spacing.$4x),
        child: SizedBox(
          width: double.infinity,
          child: BaladyAppButton(
            primaryLabel: context.l10n.favoriteListConfirmButton,
            buttonColorScheme: ButtonColorScheme.accentSecondary,
            buttonState: isSubmitting.value
                ? ButtonState.loading
                : (isValid ? ButtonState.defaultState : ButtonState.disabled),
            onTap: () async {
              if (isSubmitting.value) {
                return;
              }
              isSubmitting.value = true;
              try {
                final name = nameController.value.text.trim();
                final dataSource = await ref.read(favoriteListsRemoteDataSourceProvider.future);
                await dataSource.setCustomPlaceNickname(place.placeId, name, placeType: place.placeType);
                ref
                  ..invalidate(favoriteListsResponseProvider)
                  ..invalidate(favoriteListDetailProvider(listId: listId))
                  ..invalidate(customPlaceNicknameProvider(place.placeId))
                  ..invalidate(aggregatedFavoriteMarkersProvider);
                if (context.mounted) {
                  context.router.pop(true);
                }
              } catch (e) {
                isSubmitting.value = false;
                if (context.mounted) {
                  showFavoriteListsErrorSheet(context, ref, e);
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
