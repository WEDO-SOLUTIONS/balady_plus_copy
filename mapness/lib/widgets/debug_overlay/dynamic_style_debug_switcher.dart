import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/dynamic_style/dynamic_style_debug.dart';
import 'package:mapness/features/dynamic_style/dynamic_style_provider.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

class DynamicStyleDebugSwitcher extends ConsumerStatefulWidget {
  const DynamicStyleDebugSwitcher({super.key});

  @override
  ConsumerState<DynamicStyleDebugSwitcher> createState() => _DynamicStyleDebugSwitcherState();
}

class _DynamicStyleDebugSwitcherState extends ConsumerState<DynamicStyleDebugSwitcher> {
  // Visible only in car navigation — these swap the LIGHT/DARK car model.
  static const _entries = <(DynamicStyleDebugMode, String, String)>[
    (DynamicStyleDebugMode.bundled, 'Bundled', 'Default styles.2gis from assets, no overrides'),
    (
      DynamicStyleDebugMode.carBuhanka,
      'Car: buhanka',
      'car_buhanka_fixed.glb (car nav marker)',
    ),
    (
      DynamicStyleDebugMode.carSport,
      'Car: sport',
      'car_sport_fixed.glb (car nav marker)',
    ),
    (
      DynamicStyleDebugMode.carFly,
      'Car: fly',
      'car_fly_fixed.glb (car nav marker)',
    ),
    (
      DynamicStyleDebugMode.carJeep,
      'Car: jeep',
      'car_jeep_fixed.glb (car nav marker)',
    ),
    (
      DynamicStyleDebugMode.utkaDefault,
      'Utka: default',
      'utka_default_fixed.glb (car nav marker)',
    ),
    (
      DynamicStyleDebugMode.utkaBoss,
      'Utka: boss',
      'utka_boss_fixed.glb (car nav marker)',
    ),
    (
      DynamicStyleDebugMode.utkaGetpack,
      'Utka: getpack',
      'utka_getpack_fixed.glb (car nav marker)',
    ),
  ];

  bool _busy = false;
  String _lastUrl = '';

  @override
  Widget build(BuildContext context) {
    final active = ref.watch(dynamicStyleDebugControllerProvider);

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DebugSectionHeader(
            icon: Icons.threed_rotation_rounded,
            title: 'Navigation car model',
            subtitle: 'Runtime GLB swap — visible in car navigation',
          ),
          const SizedBox(height: 12),
          for (final (mode, label, subtitle) in _entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ModeRow(
                label: label,
                subtitle: subtitle,
                isActive: mode == active,
                isBusy: _busy,
                onTap: () => _apply(mode),
              ),
            ),
          // Pick a whole .2gis from device storage and apply it at runtime.
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ModeRow(
              label: 'Pick .2gis from device…',
              subtitle: 'Choose a style file from storage',
              isActive: false,
              isBusy: _busy,
              onTap: _pickFileAndLoad,
            ),
          ),
          // Network hypothesis test: download a whole .2gis from a URL and apply
          // it at runtime. Use a visibly-different style to prove the runtime
          // restyle actually re-renders the map.
          _ModeRow(
            label: 'Load .2gis from URL…',
            subtitle: _lastUrl.isEmpty ? 'Download a full style over the network' : _lastUrl,
            isActive: false,
            isBusy: _busy,
            onTap: _promptUrlAndLoad,
          ),
          if (_busy)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Repacking styles.2gis…',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _apply(DynamicStyleDebugMode mode) async {
    if (_busy) {
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(dynamicStyleDebugControllerProvider.notifier).select(mode);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Style swap failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _promptUrlAndLoad() async {
    if (_busy) {
      return;
    }
    final controller = TextEditingController(text: _lastUrl);
    final url = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: DebugTheme.surface,
        title: const Text('Load .2gis from URL', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.url,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: const InputDecoration(
            hintText: 'https://…/styles.2gis',
            hintStyle: TextStyle(color: Colors.white38),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Load'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (url == null || url.isEmpty) {
      return;
    }
    setState(() => _lastUrl = url);
    await _applyNetwork(url);
  }

  Future<void> _pickFileAndLoad() async {
    if (_busy) {
      return;
    }
    final FilePickerResult? result;
    try {
      // Default mode (no withData): file_picker returns a real filesystem path
      // (cached by the plugin on Android for content:// URIs). The SDK loads
      // it directly — no copy / no repack.
      result = await FilePicker.platform.pickFiles();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File pick failed: $e')),
        );
      }
      return;
    }
    final path = result?.files.single.path;
    if (path == null) {
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(dynamicStyleControllerProvider.notifier).applyStyleFromPath(path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File style applied')),
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File style failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _applyNetwork(String url) async {
    if (_busy) {
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(dynamicStyleControllerProvider.notifier).applyNetworkStyle(url);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network style applied')),
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network style failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }
}

class _ModeRow extends StatelessWidget {
  const _ModeRow({
    required this.label,
    required this.subtitle,
    required this.isActive,
    required this.isBusy,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool isActive;
  final bool isBusy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: isBusy ? null : onTap,
    child: Opacity(
      opacity: isBusy && !isActive ? 0.5 : 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          gradient: isActive ? DebugTheme.gradientPurple : null,
          color: isActive ? null : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? Colors.transparent : Colors.white.withOpacity(0.12),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isActive ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isActive ? Colors.white.withOpacity(0.85) : Colors.white.withOpacity(0.45),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
