import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/features/path_nav/providers/path_nav_sound_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_bottom_sheet.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_end_trip_button.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_eta_widget.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_icon_button.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_setting_toggle.dart';

class EtaSheet extends ConsumerStatefulWidget {
  final VoidCallback onEndTripPressed;
  final VoidCallback onRoutePressed;
  final double minExtent;
  final double maxExtent;

  final ValueListenable<PathNavState> navigationState;

  final void Function(double opacity) onBgOpacityChanged;

  const EtaSheet({
    required this.minExtent,
    required this.maxExtent,
    required this.onBgOpacityChanged,
    required this.onEndTripPressed,
    required this.onRoutePressed,
    required this.navigationState,
    super.key,
  });

  @override
  ConsumerState<EtaSheet> createState() => _EtaSheetState();
}

class _EtaSheetState extends ConsumerState<EtaSheet> {
  final _dragController = DraggableScrollableController();
  double get _minExtent => widget.minExtent;
  double get _maxExtent => widget.maxExtent;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _dragController.addListener(_onSizeChanged);
    widget.navigationState.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    widget.navigationState.removeListener(_onStateChanged);
    super.dispose();
  }

  Future<void> _onStateChanged() async {
    if (widget.navigationState.value == PathNavState.finished) {
      await _dragController.animateTo(
        _maxExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else if (widget.navigationState.value == PathNavState.paused) {
      _dragController.jumpTo(
        _minExtent,
      );
    }
  }

  void _onSizeChanged() {
    final extent = _dragController.size;
    final progress = (extent - _minExtent) / (_maxExtent - _minExtent);
    final isExpanded = progress > 0.1;
    if (isExpanded != _isExpanded) {
      setState(() => _isExpanded = isExpanded);
    }
    widget.onBgOpacityChanged(
      Curves.easeIn.transform(progress),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eta = ref.watch(pathNavEtaProvider);
    final sound = ref.watch(pathNavSoundProviderProvider);

    return Material(
      color: Colors.transparent,
      child: PathNavBottomSheet(
        maxSize: _maxExtent,
        minSize: _minExtent,
        header: ValueListenableBuilder(
          valueListenable: widget.navigationState,
          builder: (context, state, child) => state == PathNavState.paused
              ? const SizedBox.shrink()
              : Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    ///
                    PathNavIconButton(
                      onPressed: () async {
                        await _dragController.animateTo(
                          _isExpanded ? _minExtent : _maxExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                      iconPath: _isExpanded
                          ? 'assets/icons/svg/ic_arrow_corner_down_l.svg'
                          : 'assets/icons/svg/ic_dashboard_menu.svg',
                    ),
                    const Spacer(),

                    if (state == PathNavState.finished)
                      Text(
                        context.l10n.youArrived,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .headingS
                            .copyWith(color: context.color.text_and_icons_base_primary),
                      )
                    else
                      PathNavEtaWidget(eta: eta),

                    const Spacer(),

                    if (state == PathNavState.finished)
                      const SizedBox(
                        width: 40,
                      )
                    else
                      PathNavIconButton(
                        onPressed: widget.onRoutePressed,
                        iconPath: 'assets/icons/svg/ic_nav_route.svg',
                      ),
                  ],
                ),
        ),
        body: ValueListenableBuilder(
          valueListenable: widget.navigationState,
          builder: (context, state, child) => Column(
            children: [
              if (state != PathNavState.finished) ...[
                PathNavSettingToggle(
                  title: context.l10n.darkMap,
                  state: ref.watch(darkModeProvider),
                  onChanged: (_) =>
                      ref.read(darkModeProvider.notifier).toggle(),
                ),
                const SizedBox(height: 12),
                PathNavSettingToggle(
                  title: context.l10n.soundSettings,
                  subtitle: context.l10n.maneuvers,
                  state: sound,
                  onChanged: (_) =>
                      ref.read(pathNavSoundProviderProvider.notifier).toggle(),
                ),
                const SizedBox(height: 12),
              ],

              /// end trip button
              PathNavEndTripButton(onPressed: widget.onEndTripPressed),
            ],
          ),
        ),
        controller: _dragController,
      ),
    );
  }
}
