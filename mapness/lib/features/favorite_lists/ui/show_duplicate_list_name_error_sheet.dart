import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_api_exception.dart';
import 'package:mapness/features/favorite_lists/ui/models/sheet_action_button.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

/// Shows the "List name already exists" ([FavoriteListsApiException] with `code`
/// `DUPLICATE_LIST_NAME`) sheet with a "Cancel" and a "Rename" button.
///
/// Returns `true` if the caller should also close the underlying create/edit form
/// (user tapped "Cancel"), or `false`/`null` if the form should stay open so the
/// user can pick a different name (user tapped "Rename" or dismissed the sheet).
Future<bool?> showDuplicateListNameErrorSheet(BuildContext context, WidgetRef ref, FavoriteListsApiException error) {
  final language = ref.read(appLanguageProvider);
  return context.router.push<bool>(
    ConfirmationSheetRoute(
      title: error.title(language) ?? context.l10n.favoriteListErrorTitle,
      message: error.localizedMessage(language),
      buttons: [
        SheetActionButton(
          label: context.l10n.cancel,
          onTap: () async => context.router.pop(true),
        ),
        SheetActionButton(
          label: context.l10n.favoriteListRenameButton,
          buttonColorScheme: ButtonColorScheme.accent,
          buttonType: ButtonType.primary,
          onTap: () async => context.router.pop(false),
        ),
      ],
    ),
  );
}
