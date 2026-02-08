import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/time_of_day_extension.dart';
import 'package:mapness/widgets/feedback/schedule/drum_picker_widget.dart';
import 'package:mapness/widgets/feedback/schedule/feedback_scroll_handle_widget.dart';
import 'package:mapness/widgets/feedback/schedule/gradiented_opacity_widget.dart';

class FeedbackTimeSelectSheet extends StatefulWidget {
  /// be aware that it defaults to nearest divisible by timeStep
  final TimeRangeStartEnd? initialValue;
  final void Function(TimeRangeStartEnd?) onSave;

  /// in minutes
  final int timeStep;

  const FeedbackTimeSelectSheet({
    required this.initialValue,
    required this.onSave,
    this.timeStep = 15,
    super.key,
  });

  @override
  State<FeedbackTimeSelectSheet> createState() => _FeedbackTimeSelectSheetState();
}

class _FeedbackTimeSelectSheetState extends State<FeedbackTimeSelectSheet> {
  late final IList<int> _timeValues =
      Iterable.generate(24 * 60 ~/ widget.timeStep, (i) => i * widget.timeStep).toIList();

  late int _selectedStart;
  late int _selectedEnd;
  late bool _isNoBreaksSelected;

  @override
  void initState() {
    super.initState();
    int _alignToTimeStep(int minutes) => (minutes ~/ widget.timeStep) * widget.timeStep;

    final selectedRange = widget.initialValue ?? TimeRange.standard;
    _selectedStart = _alignToTimeStep(selectedRange.start.inMinutes());
    _selectedEnd = _alignToTimeStep(selectedRange.end.inMinutes());
    _isNoBreaksSelected = widget.initialValue == null;
  }

  @override
  Widget build(BuildContext context) {
    const itemHeight = 30.0;
    final drumsLabelColor = _isNoBreaksSelected ? context.colors.foregroundMuted : context.colors.foregroundDefault;

    return Container(
      padding: const EdgeInsets.all(Spacing.$4x),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Spacing.$4x),
          topRight: Radius.circular(Spacing.$4x),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const FeedbackScrollHandle(),

          /// drums with start end select
          Expanded(
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// start break drum
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            context.l10n.feedbackBreaksSheetStartOfBreak,
                            style: context.textStyles.captionMediumRegular.copyWith(color: drumsLabelColor),
                            textAlign: TextAlign.center,
                          ),
                          Expanded(
                            child: GradientedOpacityWidget(
                              opaqueSize: itemHeight,
                              child: DrumPickerWidget<int>(
                                initialItem: _timeValues.indexOf(_selectedStart),
                                items: _timeValues,
                                itemHeight: itemHeight,
                                itemBuilder: _timeItemBuilder,
                                selectedItemBuilder: _timeSelectedItemBuilder,
                                onChanged: (minutes) => setState(() => _selectedStart = minutes),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// end break drum
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            context.l10n.feedbackBreaksSheetEndOfBreak,
                            style: context.textStyles.captionMediumRegular.copyWith(color: drumsLabelColor),
                            textAlign: TextAlign.center,
                          ),
                          Expanded(
                            child: GradientedOpacityWidget(
                              opaqueSize: itemHeight,
                              child: DrumPickerWidget<int>(
                                initialItem: _timeValues.indexOf(_selectedEnd),
                                items: _timeValues,
                                itemHeight: itemHeight,
                                itemBuilder: _timeItemBuilder,
                                selectedItemBuilder: _timeSelectedItemBuilder,
                                onChanged: (minutes) => setState(() => _selectedEnd = minutes),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                /// fade and do not allow to scroll any value
                if (_isNoBreaksSelected) const Positioned.fill(child: AbsorbPointer()),
              ],
            ),
          ),

          /// no breaks toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                context.l10n.feedbackBreaksSheetNoBreaks,
                style: context.textStyles.bodyLargeRegular,
              ),
              Toggle(
                value: _isNoBreaksSelected,
                onChanged: (value) => setState(() => _isNoBreaksSelected = value),
              )
            ]),
          ),
          const SizedBox(height: 12),

          /// buttons
          Row(
            children: [
              /// close button
              Expanded(
                child: AppButton(
                  primaryLabel: context.l10n.feedbackBreaksSheetClose,
                  buttonColorScheme: ButtonColorScheme.neutral,
                  onTap: () => context.router.popForced(),
                ),
              ),
              const SizedBox(width: 8),

              /// set button
              Expanded(
                child: AppButton(
                  primaryLabel: context.l10n.feedbackBreaksSheetSet,
                  buttonColorScheme: ButtonColorScheme.accent,
                  buttonState: _isSubmitActive ? ButtonState.normal : ButtonState.disabled,
                  onTap: _onSubmit,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _timeItemBuilder(BuildContext context, int minutes) {
    final time = _timeOfDayFromMinutes(minutes);

    return Center(
      child: Text(
        time.format(context),
        style: context.textStyles.h2Medium.copyWith(
          color: _isNoBreaksSelected ? context.colors.foregroundMuted : context.colors.foregroundSoft,
        ),
      ),
    );
  }

  Widget _timeSelectedItemBuilder(BuildContext context, int minutes) {
    final time = _timeOfDayFromMinutes(minutes);
    final colors = context.colors;

    return Container(
      color: _isNoBreaksSelected ? null : colors.backgroundSurface4,
      child: Center(
        child: Text(
          time.format(context),
          style: context.textStyles.h2Medium.copyWith(
            color: _isNoBreaksSelected ? colors.foregroundMuted : colors.foregroundDefault,
          ),
        ),
      ),
    );
  }

  bool get _isSubmitActive {
    if (_isNoBreaksSelected) {
      return true;
    }
    return _selectedStart < _selectedEnd;
  }

  void _onSubmit() {
    final selectedStartEnd = TimeRangeStartEnd(
      start: _timeOfDayFromMinutes(_selectedStart),
      end: _timeOfDayFromMinutes(_selectedEnd),
    );

    widget.onSave(
      _isNoBreaksSelected ? null : selectedStartEnd,
    );

    context.router.popForced();
  }
}

TimeOfDay _timeOfDayFromMinutes(int minutes) => TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
