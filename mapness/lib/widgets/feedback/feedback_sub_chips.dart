import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/widgets/dragger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/fields_entity/feedback_text_type_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_input.dart';
import 'package:provider/provider.dart';

class FeedbackSubChips extends StatefulWidget {
  final FeedbackSubChipsEntity field;

  const FeedbackSubChips({required this.field, super.key});

  @override
  State<FeedbackSubChips> createState() => _FeedbackSubChipsState();
}

class _FeedbackSubChipsState extends State<FeedbackSubChips> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) => FormBuilderField<int>(
    name: widget.field.id,
    validator: (value) => !widget.field.isRequired || value != null ? null : '',
    builder: (fieldState) => FeedbackTextInput(
      labelText: widget.field.label,
      hintText: widget.field.hint,
      readonly: true,
      onChanged: (value) {
        if (value.isEmpty) {
          fieldState.didChange(null);
        }
      },
      isRequired: widget.field.isRequired,
      controller: controller,
      maxLength: 500,
      type: FeedbackTextType.text,
      onTap: () async {
        final item = await _FeedbackSubChipsSelector.show(context: context, field: widget.field);

        if (item == null || !mounted) {
          return;
        }

        fieldState.didChange(item.id);
        controller.text = item.label;
      },
    ),
  );
}

class _FeedbackSubChipsSelector extends StatefulWidget {
  final FeedbackSubChipsEntity field;

  const _FeedbackSubChipsSelector({required this.field});

  static Future<FeedbackChipsItemEntity?> show({required BuildContext context, required FeedbackSubChipsEntity field}) {
    final colors = Provider.of<ThemeController>(context, listen: false).colors;
    return showModalBottomSheet(
      backgroundColor: colors.backgroundSurface2,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: colors.screenOverlayDimming40,
      builder: (context) => _FeedbackSubChipsSelector(field: field),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(RadiusBorder.xl))),
    );
  }

  @override
  State<_FeedbackSubChipsSelector> createState() => _FeedbackSubChipsSelectorState();
}

class _FeedbackSubChipsSelectorState extends State<_FeedbackSubChipsSelector> {
  final controller = TextEditingController();
  String search = '';
  String? errorText;

  @override
  void initState() {
    controller.addListener(() {
      if (search != controller.text) {
        setState(() {
          search = controller.text;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Backend occasionally sends empty or invalid icon URLs; SvgPicture.network
  // throws on those ("No host specified in URI" / "Invalid SVG data"), so fall
  // back to a blank placeholder of the same size instead of crashing the sheet.
  Widget _categoryIcon(String url, Color color) {
    final uri = Uri.tryParse(url.trim());
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return const SizedBox.square(dimension: 24);
    }
    return SvgPicture.network(
      uri.toString(),
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      errorBuilder: (_, __, ___) => const SizedBox.square(dimension: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    final variants = widget.field.variants.map(
      (key, value) =>
          MapEntry(key, value.where((element) => element.label.toLowerCase().contains(search.toLowerCase()))),
    )..removeWhere((key, value) => value.isEmpty);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(padding: EdgeInsets.all(Spacing.$1_5x), child: Dragger()),
          Padding(
            padding: const EdgeInsets.only(right: Spacing.$4x, left: Spacing.$4x, bottom: Spacing.$4x),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.field.label,
                    style: context.textStyles.h2SemiBold.copyWith(color: context.colors.foregroundDefault),
                  ),
                ),
                AppButton.close(padding: EdgeInsets.zero, onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: BaladyTextInput(
              controller: controller,
              supportingText: variants.isEmpty
                  ? BaladySupportingText(
                      text: context.l10n.feedbackSubcategoryEmptyError,
                      style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.errorDefault),
                    )
                  : null,
              inputState: variants.isEmpty ? BaladyInputState.error : BaladyInputState.defaultValue,
              config: BaladyInputConfig(
                isDisposed: false,
                hintText: widget.field.hint,
                background: BaladyInputBackground.color,
                fillColor: context.colors.neutralContainerDefault,
              ),
            ),
          ),
          Spacing.px.heightBox,
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$2x),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (search.isNotEmpty && variants.isNotEmpty)
                    for (final entry in variants.entries)
                      for (final item in entry.value)
                        ContentRow(
                          onTap: () => Navigator.pop(context, item),
                          leadingPadding: const EdgeInsetsDirectional.symmetric(vertical: Spacing.$3x),
                          leading: _categoryIcon(entry.key.icon, context.colors.foregroundDefault),
                          text: ContentRowTextOptions(title: item.label),
                        )
                  else
                    for (final entry in variants.isEmpty ? widget.field.variants.entries : variants.entries) ...[
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(vertical: Spacing.$2x),
                        child: Row(
                          children: [
                            _categoryIcon(entry.key.icon, context.colors.foregroundMuted),
                            Spacing.$1_5x.widthBox,
                            Expanded(
                              child: Text(
                                entry.key.name,
                                style: context.textStyles.bodySmallMedium.copyWith(
                                  color: context.colors.foregroundMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          for (final item in entry.value)
                            InkWell(
                              onTap: () => Navigator.pop(context, item),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: Spacing.$1_5x),
                                child: Row(
                                  children: [
                                    _categoryIcon(entry.key.icon, context.colors.foregroundDefault),
                                    Spacing.$1_5x.widthBox,
                                    Expanded(
                                      child: Text(
                                        item.label,
                                        style: context.textStyles.bodySmallRegular.copyWith(
                                          color: context.colors.foregroundDefault,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: Spacing.$1_5x + 24, top: Spacing.$4x, bottom: Spacing.$2x),
                        child: Divider(color: context.colors.borderSoft, height: 0.5),
                      ),
                    ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
