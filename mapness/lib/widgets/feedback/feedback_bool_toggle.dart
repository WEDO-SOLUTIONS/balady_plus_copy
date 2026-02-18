import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/widgets/feedback/feedback_balady_business.dart';

class FeedbackBoolToggle extends HookWidget {
  final FeedbackBoolToggleEntity field;

  const FeedbackBoolToggle({required this.field, super.key});

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(color: context.colors.borderMuted);
    final isSelected = useState(false);
    final bannerKey = useMemoized(() => GlobalKey());

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.$4x),
      decoration: BoxDecoration(
        border: Border(bottom: isSelected.value ? BorderSide.none : border, top: border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(field.label, style: context.textStyles.bodyLargeRegular)),
              FormBuilderField<bool>(
                name: field.id,
                initialValue: false,
                valueTransformer: (value) => value,
                builder: (fieldState) => Toggle(
                  value: fieldState.value ?? false,
                  onChanged: (v) {
                    fieldState.didChange(v);
                    isSelected.value = v;
                    if (v && field.baladyBusiness) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final bannerContext = bannerKey.currentContext;
                        if (bannerContext != null) {
                          Scrollable.ensureVisible(
                            bannerContext,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          if (field.baladyBusiness)
            ValueListenableBuilder(
              valueListenable: isSelected,
              builder: (context, isSelectedValue, _) =>
                  isSelectedValue ? FeedbackBaladyBusiness(key: bannerKey) : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}
