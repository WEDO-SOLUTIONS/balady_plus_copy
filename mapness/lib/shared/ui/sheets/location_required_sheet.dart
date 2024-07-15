import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/routing/transculent_page.dart';
import 'package:mapness/shared/ui/sheets/error_sheet_v2.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

part 'location_required_sheet.g.dart';

@TypedGoRoute<LocationErrorSheet>(
  path: '/request_location',
)
class LocationErrorSheet extends GoRouteData {
  const LocationErrorSheet({this.routeOnClose});
  final String? routeOnClose;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  // ignore: prefer_expression_function_bodies
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return TransculentPage(
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black54,
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ErrorSheetV2(
                onClose: () => routeOnClose != null ? context.go(routeOnClose!) : context.pop(),
                errorTitle: context.l10n.locationDialogErrorTitle,
                errorContent: context.l10n.locationDialogErrorContent,
                buttonLabel: context.l10n.locationDialogButtonLabel,
                assetImage: 'assets/images_svg/lost_location.svg',
                package: PackageConfig.packageName,
                onRetry: () async {
                  if (context.mounted) {
                    context.pop();
                  }
                  await perm.openAppSettings();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final $locationErrorBoundaryRoute = $appRoutes;
