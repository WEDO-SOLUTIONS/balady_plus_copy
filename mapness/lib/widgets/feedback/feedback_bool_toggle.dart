import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/widgets/feedback/feedback_balady_business.dart';

class FeedbackBoolToggle extends HookConsumerWidget {
  final FeedbackBoolToggleEntity field;

  const FeedbackBoolToggle({required this.field, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final border = BorderSide(color: context.colors.borderMuted);
    final isSelected = useState(false);
    final showBusinessAuthPrompt = useState(false);
    final isAuthorized = ref.watch(authProvider).value != null;
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
              Expanded(
                child: Text(
                  field.label,
                  style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
                ),
              ),
              FormBuilderField<bool>(
                name: field.id,
                initialValue: false,
                valueTransformer: (value) {
                  if (!field.baladyBusiness) {
                    return value;
                  }
                  if (value != true) {
                    return false;
                  }
                  // Keep toggle interactive, but prevent LK Balady tag when auth is incomplete.
                  return isAuthorized;
                },
                builder: (fieldState) => Toggle(
                  value: fieldState.value ?? false,
                  onChanged: (v) {
                    fieldState.didChange(v);
                    isSelected.value = v;
                    showBusinessAuthPrompt.value = field.baladyBusiness && v && !isAuthorized;
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
              valueListenable: showBusinessAuthPrompt,
              builder: (context, isSelectedValue, _) =>
                  isSelectedValue ? FeedbackBaladyBusiness(key: bannerKey) : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}
