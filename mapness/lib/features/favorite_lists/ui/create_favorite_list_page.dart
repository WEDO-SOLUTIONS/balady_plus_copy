import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_api_exception.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/marker_color_code.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class CreateFavoriteListPage extends HookConsumerWidget {
  const CreateFavoriteListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useToggleSheetController(onClose: (_) => context.router.pop());
    // TODO(claude): pass text to controller from params
    final listNameController = useTextEditingController();
    // TODO(claude): pass text to controller from params
    final descriptionController = useTextEditingController();
    final color = useState(MarkerColorCode.blue);
    final isSubmitting = useState(false);

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
                'New list',
                style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
              ),
            ),
            IconButton(
              onPressed: () => context.router.pop(),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.all(Spacing.$4x),
      content: [
        BaladyTextInput(
          controller: listNameController,
          config: BaladyInputConfig(
            // TODO(claude): localize string
            hintText: 'List Name',
            fillColor: context.colors.backgroundSurface1,
            hintColor: context.colors.foregroundSoft,
          ),
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
              onTap: () {
                // todo edit somehow
                color.value = MarkerColorCode.values[(color.value.index + 1) % MarkerColorCode.values.length];
              },
            ),
          ],
        ),
        const SizedBox(height: Spacing.$4x),
        BaladyAppButton(
          // TODO(claude): localize string
          primaryLabel: 'Create list',
          buttonColorScheme: ButtonColorScheme.accent,
          buttonState: isSubmitting.value
              ? ButtonState.loading
              : (isValid ? ButtonState.defaultState : ButtonState.disabled),
          onTap: () async {
            final listName = listNameController.value.text.trim();
            final description = descriptionController.value.text.trim();

            isSubmitting.value = true;
            try {
              final dataSource = await ref.read(favoriteListsRemoteDataSourceProvider.future);
              await dataSource.createFavoriteList(
                FavoriteListRequestDto(
                  name: listName,
                  description: description.isEmpty ? null : description,
                  markerColorCode: color.value,
                ),
              );
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
