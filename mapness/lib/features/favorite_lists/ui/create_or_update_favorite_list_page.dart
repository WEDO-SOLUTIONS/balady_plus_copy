import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_api_exception.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/icon_type.dart';
import 'package:mapness/features/favorite_lists/data/models/marker_color_code.dart';
import 'package:mapness/features/favorite_lists/providers/aggregated_favorite_markers.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_detail.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists.dart';
import 'package:mapness/features/favorite_lists/ui/models/favorite_list_form_params.dart';
import 'package:mapness/features/favorite_lists/ui/show_duplicate_list_name_error_sheet.dart';
import 'package:mapness/features/favorite_lists/ui/show_favorite_lists_error_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class CreateOrUpdateFavoriteListPage extends HookConsumerWidget {
  final FavoriteListFormParams params;

  const CreateOrUpdateFavoriteListPage({this.params = const CreateFavoriteListParams(), super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = this.params;
    final isEditing = params is UpdateFavoriteListParams;

    final scrollController = useToggleSheetController(onClose: (_) => context.router.pop());
    final listNameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final color = useState(MarkerColorCode.green);
    final isSubmitting = useState(false);
    final selectedIcon = useState<FavoriteIconType>(FavoriteIconType.$default);
    final isIconPickerExpanded = useState(false);
    final originalValues = useState<({String name, String description, MarkerColorCode color, FavoriteIconType icon})?>(
      null,
    );

    final editingListId = switch (params) {
      UpdateFavoriteListParams(:final listId) => listId,
      _ => null,
    };
    final listDetailAsync = editingListId != null ? ref.watch(favoriteListDetailProvider(listId: editingListId)) : null;

    useEffect(() {
      if (params is! AcceptSharedFavoriteListParams) {
        return null;
      }
      final preview = params.preview;
      listNameController.text = preview.list.name;
      descriptionController.text = preview.list.description ?? '';
      color.value = preview.list.markerColorCode;
      return null;
    }, [params]);

    useEffect(() {
      final list = listDetailAsync?.value?.list;
      if (list != null && originalValues.value == null) {
        listNameController.text = list.name;
        descriptionController.text = list.description ?? '';
        color.value = list.markerColorCode;
        selectedIcon.value = list.iconType ?? FavoriteIconType.$default;
        originalValues.value = (
          name: list.name,
          description: list.description ?? '',
          color: list.markerColorCode,
          icon: selectedIcon.value,
        );
      }
      final error = listDetailAsync?.error;
      if (error != null && context.mounted) {
        showFavoriteListsErrorSheet(context, ref, error);
      }
      return null;
    }, [listDetailAsync]);

    final value = useValueListenable(listNameController);
    final descriptionValue = useValueListenable(descriptionController);
    final isValid = value.text.trim().isNotEmpty;

    final original = originalValues.value;
    final isUnchanged =
        isEditing &&
        original != null &&
        value.text.trim() == original.name &&
        descriptionValue.text.trim() == original.description &&
        color.value == original.color &&
        selectedIcon.value == original.icon;

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
        child: Row(
          children: [
            Expanded(
              child: Text(
                isEditing ? context.l10n.favoriteListSettingsTitle : context.l10n.favoriteListNewTitle,
                style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
              ),
            ),
            IconButton(
              onPressed: () => context.router.pop(),
              icon: Icon(SystemIcons.close, color: context.colors.foregroundDefault),
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.all(Spacing.$4x),
      content: [
        Row(
          spacing: Spacing.$3x,
          children: [
            Expanded(
              child: BaladyTextInput(
                controller: listNameController,
                config: BaladyInputConfig(
                  hintText: context.l10n.favoriteListName,
                  fillColor: context.colors.backgroundSurface1,
                  hintColor: context.colors.foregroundSoft,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                isIconPickerExpanded.value = !isIconPickerExpanded.value;
              },
              child: Container(
                padding: const EdgeInsets.all(Spacing.$3x),
                decoration: BoxDecoration(
                  color: context.colors.backgroundSurface1,
                  borderRadius: BorderRadius.circular(Spacing.$2x),
                ),
                child: selectedIcon.value.getIcon().svg(
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(color.value.color, BlendMode.srcIn),
                ),
              ),
            ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: isIconPickerExpanded.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Spacing.$4x),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.$3x, horizontal: Spacing.$4x),
                      decoration: BoxDecoration(
                        color: context.colors.backgroundSurface1,
                        borderRadius: BorderRadius.circular(Spacing.$2x),
                      ),
                      child: Wrap(
                        spacing: Spacing.$3x,
                        children: FavoriteIconType.validValues
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  selectedIcon.value = e == selectedIcon.value ? FavoriteIconType.$default : e;
                                  isIconPickerExpanded.value = false;
                                },
                                child: e.getIcon().svg(
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                    e == selectedIcon.value ? color.value.color : context.colors.foregroundSoft,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: Spacing.$4x),
        BaladyTextInput(
          controller: descriptionController,
          config: BaladyInputConfig(
            hintText: context.l10n.favoriteListDescription,
            fillColor: context.colors.backgroundSurface1,
            hintColor: context.colors.foregroundSoft,
          ),
        ),
        const SizedBox(height: Spacing.$4x),
        ContentWrapper(
          color: context.colors.backgroundSurface1,
          children: [
            ContentRow(
              trailing: ContentRowCustomTrailingOptions(
                builder: (context) => Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsetsDirectional.only(end: Spacing.$4x),
                  decoration: BoxDecoration(
                    color: color.value.color,
                    borderRadius: BorderRadius.circular(Spacing.$1x),
                  ),
                ),
              ),
              text: ContentRowTextOptions(
                title: context.l10n.favoriteListMarkerColor,
                subtitle: context.l10n.favoriteListMarkerColorCustomizable,
              ),
              onTap: () async {
                final picked = await context.router.push<MarkerColorCode>(
                  MarkerColorPickerRoute(selectedColor: color.value),
                );
                if (picked != null) {
                  color.value = picked;
                }
              },
            ),
          ],
        ),
      ],
      footer: Padding(
        padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: 0),
        child: SizedBox(
          width: double.infinity,
          child: BaladyAppButton(
            primaryLabel: isUnchanged
                ? context.l10n.favoriteListCloseWithoutSaving
                : isEditing
                ? context.l10n.save
                : context.l10n.favoriteListCreateButton,
            buttonColorScheme: isUnchanged ? ButtonColorScheme.accentSecondary : ButtonColorScheme.accent,
            buttonType: isUnchanged ? ButtonType.secondary : ButtonType.primary,
            buttonState: isSubmitting.value || (listDetailAsync?.isLoading ?? false)
                ? ButtonState.loading
                : (isValid ? ButtonState.defaultState : ButtonState.disabled),
            onTap: isUnchanged
                ? () => context.router.pop()
                : () async {
                    final listName = listNameController.value.text.trim();
                    final description = descriptionController.value.text.trim();

                    isSubmitting.value = true;
                    try {
                      final dataSource = await ref.read(favoriteListsRemoteDataSourceProvider.future);
                      final request = FavoriteListRequestDto(
                        name: listName,
                        description: description.isEmpty ? null : description,
                        markerColorCode: color.value,
                        iconType: selectedIcon.value,
                      );
                      switch (params) {
                        case CreateFavoriteListParams():
                          await dataSource.createFavoriteList(request);
                        case UpdateFavoriteListParams(:final listId):
                          await dataSource.updateFavoriteList(listId, request);
                          ref.invalidate(favoriteListDetailProvider(listId: listId));
                        case AcceptSharedFavoriteListParams(:final shareToken):
                          final acceptResult = await dataSource.acceptShareLink(shareToken);
                          final listId = acceptResult.list.id;
                          await dataSource.updateFavoriteList(listId, request);
                          ref.invalidate(favoriteListDetailProvider(listId: listId));
                      }
                      ref
                        ..invalidate(favoriteListsResponseProvider)
                        ..invalidate(aggregatedFavoriteMarkersProvider);
                      if (context.mounted) {
                        context.router.pop(true);
                      }
                    } catch (e) {
                      isSubmitting.value = false;
                      if (context.mounted) {
                        if (e is FavoriteListsApiException && e.code == 'DUPLICATE_LIST_NAME') {
                          final shouldCloseForm = await showDuplicateListNameErrorSheet(context, ref, e);
                          if (shouldCloseForm == true && context.mounted) {
                            context.router.pop();
                          }
                        } else {
                          showFavoriteListsErrorSheet(context, ref, e);
                        }
                      }
                    }
                  },
          ),
        ),
      ),
    );
  }
}
