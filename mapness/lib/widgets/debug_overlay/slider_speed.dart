import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/free_roam/simulation_speed_controller.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

class SliderSpeed extends ConsumerWidget {
  const SliderSpeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speed = ref.watch(simulationSpeedProvider);

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DebugSectionHeader(
            icon: Icons.speed_rounded,
            title: 'Simulation Speed',
            subtitle: 'Adjust navigation simulation speed',
            gradient: DebugTheme.gradientAmber,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Speed',
                      style: context.textStyles.captionSmallRegular.copyWith(
                        color: DebugTheme.textMuted,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: DebugTheme.gradientAmber,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${speed.toInt()} km/h',
                        style: context.textStyles.captionSmallMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: DebugTheme.warning,
                    inactiveTrackColor: DebugTheme.border,
                    thumbColor: Colors.white,
                    overlayColor: DebugTheme.warning.withOpacity(0.2),
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                      elevation: 4,
                    ),
                  ),
                  child: Slider(
                    value: speed.clamp(5, 230).toDouble(),
                    min: 5,
                    max: 230,
                    divisions: 45,
                    onChanged: (val) => ref.read(simulationSpeedProvider.notifier).setKmh(val),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '5 km/h',
                      style: context.textStyles.captionSmallRegular.copyWith(
                        color: DebugTheme.textMuted,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '230 km/h',
                      style: context.textStyles.captionSmallRegular.copyWith(
                        color: DebugTheme.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const SpeedInputField(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Numeric text entry for the simulation speed (km/h). Reads/writes the shared
/// [simulationSpeedProvider], so it stays in sync with the slider (and the on-map
/// HUD) both ways. Lets you set a precise value or one beyond the slider's range.
class SpeedInputField extends ConsumerStatefulWidget {
  const SpeedInputField({super.key});

  @override
  ConsumerState<SpeedInputField> createState() => _SpeedInputFieldState();
}

class _SpeedInputFieldState extends ConsumerState<SpeedInputField> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  static const double _minKmh = 0;
  static const double _maxKmh = 400;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(simulationSpeedProvider).round().toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _apply([String? raw]) {
    final text = (raw ?? _controller.text).trim().replaceAll(',', '.');
    final parsed = double.tryParse(text);
    final current = ref.read(simulationSpeedProvider);
    if (parsed == null) {
      _controller.text = current.round().toString();
      return;
    }
    final clamped = parsed.clamp(_minKmh, _maxKmh).toDouble();
    ref.read(simulationSpeedProvider.notifier).setKmh(clamped);
    _controller
      ..text = clamped.round().toString()
      ..selection = TextSelection.collapsed(offset: _controller.text.length);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // Keep the field in sync when the value changes elsewhere (slider/HUD) and
    // the user is not actively typing here.
    ref.listen<double>(simulationSpeedProvider, (_, next) {
      if (!_focusNode.hasFocus) {
        final t = next.round().toString();
        if (_controller.text != t) {
          _controller.text = t;
        }
      }
    });

    return Row(
      children: [
        SizedBox(
          width: 88,
          child: Text(
            'Set km/h',
            style: context.textStyles.captionSmallRegular.copyWith(color: DebugTheme.textSecondary),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 36,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              onSubmitted: _apply,
              onTapOutside: (_) => _apply(),
              style: context.textStyles.bodySmallSemiBold.copyWith(color: DebugTheme.textPrimary),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: DebugTheme.surfaceLight,
                hintText: 'km/h',
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: DebugTheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: DebugTheme.warning),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _apply,
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: DebugTheme.gradientAmber,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Set',
              style: context.textStyles.captionSmallMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
