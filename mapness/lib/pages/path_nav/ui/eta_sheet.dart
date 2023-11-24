import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/features/path_nav/providers/path_nav_sound_provider.dart';
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

  final void Function(double opacity) onBgOpacityChanged;

  const EtaSheet({
    required this.minExtent,
    required this.maxExtent,
    required this.onBgOpacityChanged,
    required this.onEndTripPressed,
    required this.onRoutePressed,
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
        header: Row(
          children: [
            ///
            PathNavIconButton(
              onPressed: () async {
                _dragController.animateTo(
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

            /// eta
            PathNavEtaWidget(eta: eta),
            const Spacer(),

            ///
            PathNavIconButton(
              onPressed: widget.onRoutePressed,
              iconPath: _isExpanded
                  ? 'assets/icons/svg/ic_map.svg'
                  : 'assets/icons/svg/ic_nav_route.svg',
            ),
          ],
        ),
        body: Column(
          children: [
            PathNavSettingToggle(
              title: 'Dark Map',
              state: ref.watch(darkModeProvider),
              onChanged: (_) => ref.read(darkModeProvider.notifier).toggle(),
            ),
            const SizedBox(height: 12),
            PathNavSettingToggle(
              title: 'Sound settings',
              subtitle: 'Maneuvers enabled',
              state: sound,
              onChanged: (_) =>
                  ref.read(pathNavSoundProviderProvider.notifier).toggle(),
            ),
            const SizedBox(height: 12),

            /// end trip button
            PathNavEndTripButton(onPressed: widget.onEndTripPressed),
          ],
        ),
        controller: _dragController,
      ),
    );
  }
}
