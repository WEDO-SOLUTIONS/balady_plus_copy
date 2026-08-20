import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_api_exception.dart';
import 'package:mapness/features/favorite_lists/ui/models/sheet_action_button.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

/// Shows the favorite-lists error sheet (a [ConfirmationSheetRoute] with a single "OK" button)
/// with [error]'s localized message if it's a [FavoriteListsApiException], or a generic
/// fallback otherwise. Replaces the previous `ToastOverlay`-based error display.
void showFavoriteListsErrorSheet(BuildContext context, WidgetRef ref, Object error) {
  final message = error is FavoriteListsApiException
      ? error.localizedMessage(ref.read(appLanguageProvider))
      : context.l10n.somethingWentWrongPleaseTryAgainLater;
  final title = error is FavoriteListsApiException ? error.title : null;
  context.router.push(
    ConfirmationSheetRoute(
      // TODO(claude): localize string
      title: title ?? 'Something went wrong!',
      message: message,
      buttons: [
        SheetActionButton(
          // TODO(claude): localize string
          label: 'OK',
          buttonColorScheme: ButtonColorScheme.accent,
          buttonType: ButtonType.primary,
          onTap: () async => context.router.pop(),
        ),
      ],
    ),
  );
}
