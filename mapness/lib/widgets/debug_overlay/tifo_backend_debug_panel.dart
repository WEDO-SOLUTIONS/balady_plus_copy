import 'dart:async';
import 'dart:convert';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_debug_collider_overlay.dart';
import 'package:mapness/features/tifo/data/tifo_debug_color_override.dart';
import 'package:mapness/features/tifo/data/tifo_debug_goalkeeper_difficulty.dart';
import 'package:mapness/features/tifo/data/tifo_debug_identity.dart';
import 'package:mapness/features/tifo/penalty/penalty_game.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/features/tifo/tifo_buildings_map_layer.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

/// Debug console for the TIFO staging backend: preset requests for the main
/// read endpoints plus a free-form method/path/body row, with the raw response
/// (status, latency, body) rendered inline. Auth follows the backend
/// prototype's convention — the user id itself is the bearer token.
class TifoBackendDebugPanel extends ConsumerStatefulWidget {
  const TifoBackendDebugPanel({super.key});

  @override
  ConsumerState<TifoBackendDebugPanel> createState() => _TifoBackendDebugPanelState();
}

class _TifoBackendDebugPanelState extends ConsumerState<TifoBackendDebugPanel> {
  static const String _defaultBaseUrl = 'https://urbi-lifestyle-stg.momah.gov.sa/1.0/api/v1/tifo';

  // Central Riyadh; matches the demo web app's viewport query shape
  // (minLng,minLat,maxLng,maxLat).
  static const String _defaultBbox = '46.65,24.66,46.72,24.73';

  final TextEditingController _baseUrlController = TextEditingController(text: _defaultBaseUrl);
  final TextEditingController _pathController = TextEditingController(text: '/districts/summary');
  final TextEditingController _bodyController = TextEditingController();
  // Admin (x-api-key) auth for /api/v1/admin/tifo/* endpoints. Entered at
  // runtime only — never persisted or committed.
  final TextEditingController _adminKeyController = TextEditingController();
  bool _adminMode = false;

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      // Error bodies (401/422/...) are the whole point of a debug console —
      // surface them instead of throwing.
      validateStatus: (_) => true,
    ),
  );

  String _method = 'GET';
  bool _isBusy = false;
  String? _lastRequestLabel;
  int? _lastStatusCode;
  int? _lastLatencyMs;
  String? _lastResponseBody;

  @override
  void dispose() {
    _baseUrlController.dispose();
    _pathController.dispose();
    _bodyController.dispose();
    _adminKeyController.dispose();
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DebugCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DebugSectionHeader(
          icon: Icons.cloud_sync_rounded,
          title: 'TIFO Backend',
          subtitle: 'Staging API console',
          gradient: DebugTheme.gradientTeal,
          trailing: _lastStatusCode == null
              ? null
              : DebugBadge(
                  label: 'HTTP $_lastStatusCode',
                  color: _lastStatusCode! < 400 ? DebugTheme.success : DebugTheme.error,
                ),
        ),
        const SizedBox(height: 12),
        Consumer(
          builder: (context, ref, _) => DebugToggleRow(
            title: 'Override system config',
            subtitle: 'Off = env base URL. On = use the Base URL below (identity is separate).',
            value: ref.watch(tifoDebugModeProvider),
            gradient: DebugTheme.gradientTeal,
            onChanged: (value) => ref.read(tifoDebugModeProvider.notifier).set(value),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Base URL',
          style: context.textStyles.bodySmallMedium.copyWith(color: DebugTheme.textSecondary),
        ),
        const SizedBox(height: 4),
        DebugTextField(controller: _baseUrlController, hint: _defaultBaseUrl),
        const SizedBox(height: 12),
        const _IdentitySwitcher(),
        const SizedBox(height: 8),
        DebugToggleRow(
          title: 'Admin mode (x-api-key)',
          subtitle: 'For /api/v1/admin/tifo/* — send the admin key instead of the bearer',
          value: _adminMode,
          gradient: DebugTheme.gradientTeal,
          onChanged: (value) => setState(() => _adminMode = value),
        ),
        if (_adminMode) ...[
          const SizedBox(height: 8),
          DebugTextField(controller: _adminKeyController, hint: 'x-api-key (admin)'),
        ],
        const SizedBox(height: 12),
        Text(
          'Presets',
          style: context.textStyles.bodySmallMedium.copyWith(color: DebugTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _presetButton(label: 'config', path: '/config'),
            _presetButton(label: 'me', path: '/me'),
            _presetButton(label: 'districts', path: '/districts/summary'),
            _presetButton(label: 'buildings', path: '/buildings?bbox=$_defaultBbox'),
            _presetButton(label: 'season', path: '/season'),
            _presetButton(label: 'leaderboards', path: '/leaderboards?scope=both'),
            _presetButton(label: 'daily tokens', path: '/tokens/daily', method: 'POST'),
          ],
        ),
        const DebugDivider(),
        Text(
          'Gameplay',
          style: context.textStyles.bodySmallMedium.copyWith(color: DebugTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Consumer(
          builder: (context, ref, _) {
            final enabled = ref.watch(tifoBuildingsMapLayerProvider);
            return DebugToggleRow(
              title: 'TIFO map layer',
              subtitle: 'zoom <16 → districts (tint by leader), ≥16 → buildings (tap to play)',
              value: enabled,
              gradient: DebugTheme.gradientTeal,
              onChanged: (value) {
                // Only when the master debug switch is on does the Base URL
                // field override the env; the identity override is applied
                // separately (and persistently) by the switcher above.
                if (ref.read(tifoDebugModeProvider)) {
                  ref.read(tifoDebugConfigProvider.notifier).setBaseUrl(_baseUrlController.text);
                }
                final layer = ref.read(tifoBuildingsMapLayerProvider.notifier);
                unawaited(value ? layer.enable() : layer.disable());
              },
            );
          },
        ),
        const DebugDivider(),
        Text(
          'Goalkeeper difficulty',
          style: context.textStyles.bodySmallMedium.copyWith(color: DebugTheme.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          'Raw numbers, not named presets — dial these in per playthrough and report back '
          'which values felt easy/medium/hard.',
          style: context.textStyles.captionSmallRegular.copyWith(color: DebugTheme.textMuted),
        ),
        const SizedBox(height: 8),
        const _GoalkeeperDifficultySliders(),
        const DebugDivider(),
        Text(
          'Kit colors',
          style: context.textStyles.bodySmallMedium.copyWith(color: DebugTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        const _ColorOverrideSwitcher(),
        const SizedBox(height: 8),
        Consumer(
          builder: (context, ref, _) => DebugToggleRow(
            title: 'Collider overlay',
            subtitle: 'Draw the ball\'s touch circle and keeper\'s save reach box live in the penalty game',
            value: ref.watch(tifoDebugColliderOverlayProvider),
            gradient: DebugTheme.gradientTeal,
            onChanged: (value) => ref.read(tifoDebugColliderOverlayProvider.notifier).set(value),
          ),
        ),
        const DebugDivider(),
        Text(
          'Custom request',
          style: context.textStyles.bodySmallMedium.copyWith(color: DebugTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final method in const ['GET', 'POST'])
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _method == method
                    ? DebugButton(
                        label: method,
                        icon: Icons.check_rounded,
                        gradient: DebugTheme.gradientTeal,
                        isCompact: true,
                        onPressed: () {},
                      )
                    : DebugOutlinedButton(
                        label: method,
                        icon: Icons.circle_outlined,
                        color: DebugTheme.info,
                        isCompact: true,
                        onPressed: () => setState(() => _method = method),
                      ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        DebugTextField(controller: _pathController, hint: '/districts/summary'),
        if (_method == 'POST') ...[
          const SizedBox(height: 8),
          DebugTextField(controller: _bodyController, hint: '{"club": "..."} — optional JSON body'),
        ],
        const SizedBox(height: 8),
        DebugButton(
          label: _isBusy ? 'Sending...' : 'Send',
          icon: Icons.send_rounded,
          gradient: DebugTheme.gradientTeal,
          isCompact: true,
          onPressed: _isBusy
              ? () {}
              : () => unawaited(
                  _send(
                    label: '$_method ${_pathController.text.trim()}',
                    method: _method,
                    path: _pathController.text.trim(),
                    body: _bodyController.text.trim(),
                  ),
                ),
        ),
        if (_lastResponseBody != null) ...[
          const DebugDivider(),
          Row(
            children: [
              Expanded(
                child: Text(
                  '$_lastRequestLabel — HTTP $_lastStatusCode, $_lastLatencyMs ms',
                  style: context.textStyles.captionSmallRegular.copyWith(
                    color: (_lastStatusCode ?? 500) < 400 ? DebugTheme.success : DebugTheme.error,
                  ),
                ),
              ),
              DebugOutlinedButton(
                label: 'Copy',
                icon: Icons.copy_rounded,
                color: DebugTheme.info,
                isCompact: true,
                onPressed: () => unawaited(Clipboard.setData(ClipboardData(text: _lastResponseBody!))),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 260),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: DebugTheme.surfaceLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: DebugTheme.border),
            ),
            child: SingleChildScrollView(
              child: SelectableText(
                _preview(_lastResponseBody!),
                style: context.textStyles.captionSmallRegular.copyWith(
                  color: DebugTheme.textPrimary,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ],
    ),
  );

  Widget _presetButton({required String label, required String path, String method = 'GET'}) => DebugOutlinedButton(
    label: label,
    icon: method == 'GET' ? Icons.download_rounded : Icons.upload_rounded,
    color: DebugTheme.info,
    isCompact: true,
    onPressed: _isBusy ? () {} : () => unawaited(_send(label: '$method $path', method: method, path: path)),
  );

  Future<void> _send({
    required String label,
    required String method,
    required String path,
    String body = '',
  }) async {
    final baseUrl = _baseUrlController.text.trim();
    final adminKey = _adminKeyController.text.trim();
    if (baseUrl.isEmpty || path.isEmpty) {
      return;
    }
    // Send exactly what the app would send — including the debug identity
    // override — so a console reply matches what the game sees.
    final userId = (await ref.read(tifoApiProvider).resolveNow()).token;
    setState(() {
      _isBusy = true;
      _lastRequestLabel = label;
      _lastStatusCode = null;
      _lastLatencyMs = null;
      _lastResponseBody = null;
    });

    // Mirrors the backend demo's apiFetch: every request carries a locale.
    final separator = path.contains('?') ? '&' : '?';
    final url = '$baseUrl$path${separator}locale=en';
    final stopwatch = Stopwatch()..start();
    String responseText;
    int? statusCode;
    try {
      final response = await _dio.request<dynamic>(
        url,
        options: Options(
          method: method,
          headers: {
            'Content-Type': 'application/json',
            // Admin endpoints (/api/v1/admin/tifo/*) authenticate with
            // x-api-key; everything else uses the user id as a bearer token.
            if (_adminMode && adminKey.isNotEmpty)
              'x-api-key': adminKey
            else if (userId.isNotEmpty)
              'Authorization': 'Bearer $userId',
          },
        ),
        data: body.isEmpty ? null : body,
      );
      statusCode = response.statusCode;
      responseText = _prettyJson(response.data);
    } catch (e) {
      responseText = 'Request failed: $e';
    } finally {
      stopwatch.stop();
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _isBusy = false;
      _lastStatusCode = statusCode;
      _lastLatencyMs = stopwatch.elapsedMilliseconds;
      _lastResponseBody = responseText;
    });
  }

  String _prettyJson(Object? data) {
    try {
      final decoded = data is String ? jsonDecode(data) : data;
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return data.toString();
    }
  }

  /// The full body stays available via Copy; the inline view is capped so a
  /// large viewport query can't turn the sheet into a mile-long scroll.
  String _preview(String body) {
    const cap = 6000;
    if (body.length <= cap) {
      return body;
    }
    return '${body.substring(0, cap)}\n… truncated, ${body.length} chars total — use Copy for the full body';
  }
}

/// "Act as another user" — swaps the bearer for a manually entered TIFO user
/// id so one device can test several players, and keeps the ids that were used
/// before so switching back is one tap.
///
/// Staging identifies a player by the bearer string itself, which is exactly
/// what makes this possible; on a backend that validates tokens this panel
/// stops working and should be removed with the rest of the workaround.
class _IdentitySwitcher extends ConsumerStatefulWidget {
  const _IdentitySwitcher();

  @override
  ConsumerState<_IdentitySwitcher> createState() => _IdentitySwitcherState();
}

class _IdentitySwitcherState extends ConsumerState<_IdentitySwitcher> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Applies the change and reloads the session, so /me, the club crest and
  /// the token balance are the new player's before the panel is even closed.
  Future<void> _apply(Future<void> Function() change) async {
    await change();
    await ref.read(tifoSessionProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final identity = ref.watch(tifoDebugIdentityProvider);
    final controller = ref.read(tifoDebugIdentityProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DebugToggleRow(
          title: 'Act as another user',
          subtitle: identity.isActive
              ? 'Bearer = "${identity.userId}" (persisted across restarts)'
              : 'Off = host SSO account. On = the user id below is sent as the bearer.',
          value: identity.enabled,
          gradient: DebugTheme.gradientTeal,
          onChanged: (value) => unawaited(_apply(() => controller.setEnabled(enabled: value))),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DebugTextField(
                controller: _controller,
                hint: 'user id, e.g. tester-01',
                onSubmitted: (value) => unawaited(_useTyped(controller, value)),
              ),
            ),
            const SizedBox(width: 8),
            DebugButton(
              label: 'Use',
              icon: Icons.person_pin_circle_rounded,
              gradient: DebugTheme.gradientTeal,
              isCompact: true,
              onPressed: () => unawaited(_useTyped(controller, _controller.text)),
            ),
          ],
        ),
        if (identity.savedIds.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            'Saved ids — tap to switch',
            style: context.textStyles.bodySmallMedium.copyWith(color: DebugTheme.textSecondary),
          ),
          const SizedBox(height: 6),
          for (final id in identity.savedIds)
            _SavedIdRow(
              id: id,
              isActive: identity.isActive && identity.userId == id,
              onUse: () => unawaited(_apply(() => controller.use(id))),
              onDelete: () => unawaited(_apply(() => controller.forget(id))),
            ),
        ],
      ],
    );
  }

  Future<void> _useTyped(TifoDebugIdentityController controller, String value) async {
    if (value.trim().isEmpty) {
      return;
    }
    await _apply(() => controller.use(value));
    _controller.clear();
  }
}

/// Pins the striker/keeper kit color for testing instead of the game's own
/// club-based resolution. Off (default) leaves the game's choice untouched;
/// each side has its own "Auto" chip so one role can stay on real data while
/// the other is forced to a specific color.
class _ColorOverrideSwitcher extends ConsumerWidget {
  const _ColorOverrideSwitcher();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final override = ref.watch(tifoDebugColorOverrideProvider);
    final controller = ref.read(tifoDebugColorOverrideProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DebugToggleRow(
          title: 'Override kit colors',
          subtitle: override.enabled
              ? 'On — chosen colors below replace the game\'s own club resolution'
              : 'Off — the game picks colors from club data, as normal',
          value: override.enabled,
          gradient: DebugTheme.gradientTeal,
          onChanged: (value) => controller.setEnabled(value),
        ),
        if (override.enabled) ...[
          const SizedBox(height: 10),
          Text(
            'Striker',
            style: context.textStyles.bodySmallMedium.copyWith(color: DebugTheme.textSecondary),
          ),
          const SizedBox(height: 6),
          _colorChips(
            options: tifoStrikerColors,
            selected: override.strikerColor,
            onSelect: controller.setStrikerColor,
          ),
          const SizedBox(height: 10),
          Text(
            'Goalkeeper',
            style: context.textStyles.bodySmallMedium.copyWith(color: DebugTheme.textSecondary),
          ),
          const SizedBox(height: 6),
          _colorChips(
            options: tifoKeeperColors,
            selected: override.keeperColor,
            onSelect: controller.setKeeperColor,
          ),
        ],
      ],
    );
  }

  Widget _colorChips({
    required List<String> options,
    required String? selected,
    required ValueChanged<String?> onSelect,
  }) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      selected == null
          ? DebugButton(
              label: 'Auto',
              icon: Icons.check_rounded,
              gradient: DebugTheme.gradientTeal,
              isCompact: true,
              onPressed: () {},
            )
          : DebugOutlinedButton(
              label: 'Auto',
              icon: Icons.circle_outlined,
              color: DebugTheme.info,
              isCompact: true,
              onPressed: () => onSelect(null),
            ),
      for (final color in options)
        color == selected
            ? DebugButton(
                label: color,
                icon: Icons.check_rounded,
                gradient: DebugTheme.gradientTeal,
                isCompact: true,
                onPressed: () {},
              )
            : DebugOutlinedButton(
                label: color,
                icon: Icons.circle_outlined,
                color: DebugTheme.info,
                isCompact: true,
                onPressed: () => onSelect(color),
              ),
    ],
  );
}

/// Numeric sliders for the goalkeeper tuning knobs consumed by `PenaltyGame`
/// (see `TifoGoalkeeperDifficulty`). Deliberately raw values rather than
/// named difficulty presets — QA dials these in per playthrough and reports
/// back which combinations feel easy/medium/hard, so we can bake named
/// presets from real feedback instead of guessing.
class _GoalkeeperDifficultySliders extends ConsumerWidget {
  const _GoalkeeperDifficultySliders();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final difficulty = ref.watch(tifoDebugGoalkeeperDifficultyProvider);
    final controller = ref.read(tifoDebugGoalkeeperDifficultyProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DifficultySlider(
          label: 'Reaction delay fraction',
          subtitle: 'Higher = keeper commits to a dive later (easier)',
          value: difficulty.reactionDelayFraction,
          min: 0.05,
          max: 0.9,
          onChanged: controller.setReactionDelayFraction,
        ),
        _DifficultySlider(
          label: 'Aim error',
          subtitle: 'Higher = keeper positions himself less accurately (easier)',
          value: difficulty.aimError,
          min: 0,
          max: 4,
          onChanged: controller.setAimError,
        ),
        _DifficultySlider(
          label: 'Center dive speed factor',
          subtitle: 'Higher = center dive plays faster, keeper reaches sooner (harder)',
          value: difficulty.centerDiveSpeedFactor,
          min: 0.5,
          max: 4,
          onChanged: controller.setCenterDiveSpeedFactor,
        ),
        _DifficultySlider(
          label: 'Lateral dive speed',
          subtitle: 'Higher = keeper runs/dives to the ball\'s side sooner (harder)',
          value: difficulty.lateralDiveSpeed,
          min: 1,
          max: 10,
          onChanged: controller.setLateralDiveSpeed,
        ),
        _DifficultySlider(
          label: 'Max approach distance',
          subtitle:
              'How far he may travel from where he stood. Lower = a far ball stays out of reach (easier); above 5.4 nothing is capped',
          value: difficulty.maxApproachDistance,
          min: 0.5,
          max: 9,
          onChanged: controller.setMaxApproachDistance,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: DebugOutlinedButton(
            label: 'Reset to defaults',
            icon: Icons.restart_alt_rounded,
            color: DebugTheme.info,
            isCompact: true,
            onPressed: controller.reset,
          ),
        ),
      ],
    );
  }
}

class _DifficultySlider extends StatelessWidget {
  const _DifficultySlider({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final String subtitle;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: context.textStyles.bodySmallMedium.copyWith(color: DebugTheme.textPrimary),
              ),
            ),
            DebugBadge(label: value.toStringAsFixed(2), color: DebugTheme.info),
          ],
        ),
        Text(
          subtitle,
          style: context.textStyles.captionSmallRegular.copyWith(color: DebugTheme.textMuted),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: DebugTheme.accent,
            inactiveTrackColor: DebugTheme.surfaceLight,
            thumbColor: DebugTheme.accentLight,
            overlayColor: DebugTheme.accent.withOpacity(0.2),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: 100,
            onChanged: onChanged,
          ),
        ),
      ],
    ),
  );
}

class _SavedIdRow extends StatelessWidget {
  const _SavedIdRow({
    required this.id,
    required this.isActive,
    required this.onUse,
    required this.onDelete,
  });

  final String id;
  final bool isActive;
  final VoidCallback onUse;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onUse,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: DebugTheme.surfaceLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isActive ? DebugTheme.success : DebugTheme.border),
              ),
              child: Row(
                children: [
                  Icon(
                    isActive ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                    size: 16,
                    color: isActive ? DebugTheme.success : DebugTheme.textMuted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      id,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.bodySmallRegular.copyWith(
                        color: isActive ? DebugTheme.textPrimary : DebugTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: DebugTheme.error),
          tooltip: 'Forget this id',
          visualDensity: VisualDensity.compact,
        ),
      ],
    ),
  );
}
