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
import 'package:mapness/features/favorite_lists/data/models/icon_code.dart';
import 'package:mapness/features/favorite_lists/data/models/marker_color_code.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_detail.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class CreateOrUpdateFavoriteListPage extends HookConsumerWidget {
  final String? listId;

  const CreateOrUpdateFavoriteListPage({this.listId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listId = this.listId;
    final isEditing = listId != null;

    final scrollController = useToggleSheetController(onClose: (_) => context.router.pop());
    final listNameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final color = useState(MarkerColorCode.blue);
    final isSubmitting = useState(false);
    final isLoadingList = useState(isEditing);
    final selectedIcon = useState<FavoriteIconCode>(FavoriteIconCode.$default);
    final isIconPickerExpanded = useState(false);

    useEffect(() {
      if (listId == null) {
        return null;
      }
      Future<void> loadList() async {
        try {
          final dataSource = await ref.read(favoriteListsRemoteDataSourceProvider.future);
          final list = (await dataSource.getFavoriteListById(listId)).list;
          listNameController.text = list.name;
          descriptionController.text = list.description ?? '';
          color.value = list.markerColorCode;

          // todo(claude): pass icon from api when available
          // selectedIcon.value = null;
        } catch (e) {
          if (context.mounted) {
            final message = e is FavoriteListsApiException
                ? e.localizedMessage(ref.read(appLanguageProvider))
                : context.l10n.somethingWentWrongPleaseTryAgainLater;
            ToastOverlay.of(context).show(title: message, isDismissible: true);
          }
        } finally {
          if (context.mounted) {
            isLoadingList.value = false;
          }
        }
      }

      loadList();
      return null;
    }, [listId]);

    final value = useValueListenable(listNameController);
    final isValid = value.text.trim().isNotEmpty;

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
                // TODO(claude): localize string
                isEditing ? 'List settings' : 'New list',
                style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
              ),
            ),
            IconButton(
              onPressed: () => context.router.pop(),
              icon: const Icon(SystemIcons.close),
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
                  // TODO(claude): localize string
                  hintText: 'List Name',
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
                  colorFilter: ColorFilter.mode(color.value.getColor(context.colors), BlendMode.srcIn),
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
                        children: FavoriteIconCode.validValues
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  selectedIcon.value = e == selectedIcon.value ? FavoriteIconCode.$default : e;
                                  isIconPickerExpanded.value = false;
                                },
                                child: e.getIcon().svg(
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                    e == selectedIcon.value
                                        ? color.value.getColor(context.colors)
                                        : context.colors.foregroundSoft,
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
            // TODO(claude): localize string
            hintText: 'Description',
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
                  margin: const EdgeInsets.only(right: Spacing.$4x),
                  decoration: BoxDecoration(
                    color: color.value.getColor(context.colors),
                    borderRadius: BorderRadius.circular(Spacing.$1x),
                  ),
                ),
              ),
              text: const ContentRowTextOptions(
                // TODO(claude): localize string
                title: 'Marker Color',
                // TODO(claude): localize string
                subtitle: 'Customizable',
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
        const SizedBox(height: Spacing.$4x),
        BaladyAppButton(
          primaryLabel: isEditing
              ? context.l10n.save
              // TODO(claude): localize string
              : 'Create list',
          buttonColorScheme: ButtonColorScheme.accent,
          buttonState: isSubmitting.value || isLoadingList.value
              ? ButtonState.loading
              : (isValid ? ButtonState.defaultState : ButtonState.disabled),
          onTap: () async {
            final listName = listNameController.value.text.trim();
            final description = descriptionController.value.text.trim();

            isSubmitting.value = true;
            try {
              final dataSource = await ref.read(favoriteListsRemoteDataSourceProvider.future);
              final request = FavoriteListRequestDto(
                name: listName,
                description: description.isEmpty ? null : description,
                markerColorCode: color.value,
              );
              if (listId != null) {
                await dataSource.updateFavoriteList(listId, request);
                ref.invalidate(favoriteListDetailProvider(listId: listId));
              } else {
                await dataSource.createFavoriteList(request);
              }
              ref.invalidate(favoriteListsProvider);
              if (context.mounted) {
                context.router.pop(true);
              }
            } catch (e) {
              isSubmitting.value = false;
              if (context.mounted) {
                final message = e is FavoriteListsApiException
                    ? e.localizedMessage(ref.read(appLanguageProvider))
                    : context.l10n.somethingWentWrongPleaseTryAgainLater;
                ToastOverlay.of(context).show(title: message, isDismissible: true);
              }
            }
          },
        ),
      ],
    );
  }
}
