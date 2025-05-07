import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/free_roam/free_roam_autostart_settings.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

@RoutePage()
class AutostartSettingsSheetPage extends ConsumerStatefulWidget {
  const AutostartSettingsSheetPage({super.key});

  @override
  ConsumerState<AutostartSettingsSheetPage> createState() => AutostartSettingsSheetState();
}

class AutostartSettingsSheetState extends ConsumerState<AutostartSettingsSheetPage> with SingleTickerProviderStateMixin {
  static const duration = Duration(milliseconds: 250);
  static const showHideDuration = Duration(milliseconds: 150);

  static const curve = Curves.easeIn;

  late final DraggableScrollableController sheetController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showBottomSheet(MediaQuery.of(context).size.height));
  }

  @override
  void dispose() {
    super.dispose();
    sheetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final direction = ref.watch(uiDirectionProvider);

    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: DraggableScrollableSheet(
        controller: sheetController,
        minChildSize: .0,
        initialChildSize: .0,
        maxChildSize: 240 / screenHeight,
        snapSizes: [.0, 240 / screenHeight],
        snap: true,
        builder: (context, scrollController) {
          final l10n = context.l10n;
          final colorsV2 = context.colorsV2;

          final textStyleV3 = context.textStyleV3;
          return Directionality(
            textDirection: direction,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(RadiusBorder.xl),
              ),
              child: ColoredBox(
                color: colorsV2.backgroundSurface1,
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$4x),
                        child: Column(
                          children: [
                            const SheetDragger(),
                            Spacing.$3x.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(context.l10n.autostartNavigator, style: textStyleV3.h4SemiBold),
                                      Spacing.$1x.heightBox,
                                      Text(
                                        context.l10n.disableStartingTheNavigator,
                                        style: textStyleV3.bodySmallRegular.copyWith(color: colorsV2.foregroundSoft),
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                AppButton.close(
                                  onTap: () {
                                    _hideLayersPanel();
                                  },
                                  padding: EdgeInsets.zero,
                                  innerPadding: const EdgeInsets.all(Spacing.$2x),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Spacing.$4x.heightBox,
                            AppButton(
                              buttonColorScheme: ButtonColorScheme.primary,
                              primaryLabel: l10n.switchOff,
                              onTap: switchOff,
                            ),
                            Spacing.$3x.heightBox,
                            AppButton(
                              buttonColorScheme: ButtonColorScheme.tertiary,
                              textColor: colorsV2.foregroundSoft,
                              primaryLabel: l10n.continueAutorun,
                              onTap: continueAutorun,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _hideLayersPanel() {
    sheetController.animateTo(
      .0,
      duration: showHideDuration,
      curve: curve,
    );
  }

  void _showBottomSheet(double screenHeight) {
    sheetController
        .animateTo(
      240 / screenHeight,
      duration: showHideDuration,
      curve: curve,
    )
        .then((_) {
      sheetController.addListener(() {
        if (sheetController.isAttached && sheetController.size < .1 && context.router.canPop()) {
          ref.read(freeRoamStarterProvider.notifier).setShown();
          context.router.popForced();
        }
      });
    });
  }

  void switchOff() {
    ref.read(freeRoamAutostartSettingsProvider.notifier).setState(isAutostart: false);
    ref.read(freeRoamStarterProvider.notifier).setShown();
    if (context.mounted) {
      context.router.popUntilRouteWithName(BottomMenuRoute.name);
    }

    ToastOverlay.of(context).show(
      title: context.l10n.activateAutostartNavigator,
      iconAsset: Assets.icons.svg.icActionsContainer.keyName
    );
  }

  void continueAutorun() {
    ref.read(freeRoamAutostartSettingsProvider.notifier).setState(isAutostart: true);
    if (context.mounted) {
      context.router.popUntilRouteWithName(BottomMenuRoute.name);
    }
  }
}

class ContentContainer extends StatelessWidget {
  final Widget child;

  const ContentContainer({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorsV2.backgroundSurface1,
          borderRadius: BorderRadius.circular(RadiusBorder.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: child,
        ),
      );
}
