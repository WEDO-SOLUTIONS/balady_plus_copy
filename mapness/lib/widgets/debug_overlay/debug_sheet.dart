import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/ai_summary/ui/ai_summary_preview_page.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/providers/uuid_provider.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/widgets/debug_overlay/app_icon_quick_actions_debug_panel.dart';
import 'package:mapness/widgets/debug_overlay/better_route_settings_widget.dart';
import 'package:mapness/widgets/debug_overlay/cityscape_debug_switcher.dart';
import 'package:mapness/widgets/debug_overlay/debug_navigation_controll.dart';
import 'package:mapness/widgets/debug_overlay/debug_server_url.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';
import 'package:mapness/widgets/debug_overlay/dynamic_style_debug_switcher.dart';
import 'package:mapness/widgets/debug_overlay/makkah_places_debug_panel.dart';
import 'package:mapness/widgets/debug_overlay/onboarding_button.dart';
import 'package:mapness/widgets/debug_overlay/satellite_debug_switcher.dart';
import 'package:mapness/widgets/debug_overlay/slider_speed.dart';
import 'package:mapness/widgets/debug_overlay/special_theme_debug_panel.dart';
import 'package:mapness/widgets/debug_overlay/sso_credential_view.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DebugSheet extends ConsumerStatefulWidget {
  const DebugSheet({
    required DraggableScrollableController draggableController,
    super.key,
  }) : _draggableController = draggableController;

  final DraggableScrollableController _draggableController;

  @override
  ConsumerState<DebugSheet> createState() => _DebugSheetState();
}

class _DebugSheetState extends ConsumerState<DebugSheet> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        _packageInfo = packageInfo;
      });
    });
  }

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
    minChildSize: 0,
    maxChildSize: 0.9,
    initialChildSize: 0,
    snapSizes: const [0, 0.9],
    controller: widget._draggableController,
    builder: (context, scrollController) => Container(
      decoration: const BoxDecoration(
        color: DebugTheme.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const ClampingScrollPhysics(),
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AppInfoCard(packageInfo: _packageInfo),
                    const SpecialThemeDebugPanel(),
                    const MakkahPlacesDebugPanel(),
                    _QuickActionsCard(
                      draggableController: widget._draggableController,
                    ),
                    const AppIconQuickActionsDebugPanel(),
                    const DebugServerUrl(),
                    const SsoCredentialView(),
                    const CityscapeDebugSwitcher(),
                    const SatelliteDebugSwitcher(),
                    const DynamicStyleDebugSwitcher(),
                    const BetterRouteSettingsWidget(),
                    const SliderSpeed(),
                    const DebugNavigationControll(),
                    const ShowOnboardingButton(),
                    const ShowSaudiDayButton(),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom + 24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildHeader(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: DebugTheme.border),
      ),
    ),
    child: Column(
      children: [
        // Handle bar
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: DebugTheme.surfaceLight,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: DebugTheme.gradientPurple,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: DebugTheme.accent.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.bug_report_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Developer Tools',
                    style: context.textStyles.h3SemiBold.copyWith(
                      color: DebugTheme.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'Debug & Configuration Panel',
                    style: context.textStyles.captionSmallRegular.copyWith(
                      color: DebugTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const DebugBadge(
              label: 'DEV',
              color: DebugTheme.warning,
            ),
          ],
        ),
      ],
    ),
  );
}

class _AppInfoCard extends ConsumerWidget {
  const _AppInfoCard({required this.packageInfo});

  final PackageInfo? packageInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uuid = ref.watch(uuidProviderProvider);

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DebugSectionHeader(
            icon: Icons.info_outline_rounded,
            title: 'App Information',
            gradient: DebugTheme.gradientBlue,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: DebugTheme.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const _InfoItem(
                  label: 'Urbi Release',
                  value: PackageConfig.releaseVersion,
                ),
                _InfoItem(
                  label: 'App Version',
                  value: '${packageInfo?.version ?? '-'}(${packageInfo?.buildNumber ?? '-'})',
                ),
                const _InfoItem(
                  label: 'CI Build',
                  value: PackageConfig.buildName,
                  isSmall: true,
                ),
                const _InfoItem(
                  label: 'Android Auto',
                  value: 'Enabled',
                  valueColor: DebugTheme.success,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Device UUID',
                      style: context.textStyles.captionSmallRegular.copyWith(
                        color: DebugTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => Clipboard.setData(ClipboardData(text: uuid)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: DebugTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: DebugTheme.border),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                uuid,
                                style: context.textStyles.captionSmallMedium.copyWith(
                                  color: DebugTheme.textSecondary,
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.copy_rounded,
                              size: 14,
                              color: DebugTheme.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              DebugOutlinedButton(
                label: 'Randomize',
                icon: Icons.shuffle_rounded,
                onPressed: () => ref.read(uuidProviderProvider.notifier).randomize(),
                isCompact: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.label,
    required this.value,
    this.valueColor,
    this.isSmall = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isSmall;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textStyles.captionSmallRegular.copyWith(
            color: DebugTheme.textMuted,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            style: context.textStyles.captionSmallMedium.copyWith(
              color: valueColor ?? DebugTheme.textPrimary,
              fontSize: isSmall ? 10 : null,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard({required this.draggableController});

  final DraggableScrollableController draggableController;

  @override
  Widget build(BuildContext context) => DebugCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DebugSectionHeader(
          icon: Icons.flash_on_rounded,
          title: 'Quick Actions',
          gradient: DebugTheme.gradientAmber,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: DebugButton(
                label: 'View Logs',
                icon: Icons.article_outlined,
                gradient: DebugTheme.gradientTeal,
                onPressed: () {
                  draggableController.animateTo(
                    0.0,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.linear,
                  );
                  logger.share();
                },
              ),
            ),
          ],
        ),
        if (kDebugMode) const SizedBox(height: 10),
        if (kDebugMode)
          Row(
            children: [
              Expanded(
                child: DebugButton(
                  label: 'AI Summary preview',
                  icon: Icons.auto_awesome_outlined,
                  onPressed: () {
                    draggableController.animateTo(
                      0.0,
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.linear,
                    );
                    rootNavigatorKey.currentState?.push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AiSummaryPreviewPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
