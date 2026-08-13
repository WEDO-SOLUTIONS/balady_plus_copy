import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/shared/providers/dark_mode.dart';

/// One action slot on a [TifoMessageCard] (button label + tap handler).
class TifoMessageAction {
  const TifoMessageAction({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;
}

/// Themed modal card shared by every TIFO game message — the Figma
/// "Messages" frame (noticeCard / Not enough tokens / Idle prompt / sheet /
/// system) renders through this one shape: an optional illustration, an
/// optional close `X`, a title + body, and zero, one or two actions.
class TifoMessageCard extends ConsumerWidget {
  const TifoMessageCard({
    required this.title,
    required this.body,
    super.key,
    this.showIllustration = false,
    this.onClose,
    this.primaryAction,
    this.secondaryAction,
  });

  final String title;
  final String body;

  /// Shows the error/empty-state illustration above the title (light / dark
  /// theme aware; TIFO-green-tinted variant of the app's shared
  /// [ErrorImageWidget] artwork) — the noticeCard / Not enough tokens /
  /// Connection lost states in the Figma frame; the confirm prompts (Still
  /// playing? / Leave challenge? / Skip tutorial) have none.
  final bool showIllustration;

  /// Top-right close button. Null hides it.
  final VoidCallback? onClose;

  /// Filled green button (right-hand / primary action, e.g. Retry, Continue,
  /// Stay, Skip).
  final TifoMessageAction? primaryAction;

  /// Neutral gray pill (left-hand / secondary action, e.g. Exit, Leave).
  final TifoMessageAction? secondaryAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: context.colors.foregroundMuted, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 12),
          if (showIllustration && onClose != null) ...[
            Row(
              children: [
                const Expanded(child: SizedBox()),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onClose,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: context.colors.foregroundMuted,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.close_rounded, size: 16, color: context.colors.foregroundDefault),
                  ),
                ),
              ],
            ),
          ],
          if (showIllustration) ...[
            Center(
              child: (isDark ? Assets.tifo.images.illustrationErrorDark : Assets.tifo.images.illustrationError).svg(
                width: 160,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  textAlign: showIllustration ? TextAlign.center : TextAlign.start,
                  style: TifoText.h3.copyWith(color: context.colors.foregroundDefault),
                ),
              ),
              if (!showIllustration && onClose != null) ...[
                const SizedBox(width: 12),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onClose,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: context.colors.foregroundMuted,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: context.colors.foregroundDefault,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            textAlign: TextAlign.start,
            style: TifoText.bodyL.copyWith(color: context.colors.foregroundSoft),
          ),
          if (primaryAction != null || secondaryAction != null) ...[
            const SizedBox(height: 24),
            if (secondaryAction != null && primaryAction != null)
              Row(
                children: [
                  Expanded(
                    child: TifoSecondaryButton(label: secondaryAction!.label, onPressed: secondaryAction!.onPressed),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TifoPrimaryButton(label: primaryAction!.label, onPressed: primaryAction!.onPressed),
                  ),
                ],
              )
            else if (primaryAction != null)
              TifoPrimaryButton(label: primaryAction!.label, onPressed: primaryAction!.onPressed)
            else
              TifoSecondaryButton(label: secondaryAction!.label, onPressed: secondaryAction!.onPressed),
          ],
        ],
      ),
    );
  }
}

/// Presents [card] as a full-width bottom sheet — the same shape as every
/// other TIFO sheet in the app (`showTifoTutorialSheet`, the guided tour's
/// coach sheet): flush to the screen edges, rounded top corners only, a
/// centered dragger. Shared shell behind every state in the Figma "Messages"
/// frame (noticeCard / Not enough tokens / Idle prompt / sheet / system).
Future<T?> showTifoMessageDialog<T>(
  BuildContext context, {
  required Widget card,
  bool barrierDismissible = true,
}) => showModalBottomSheet<T>(
  context: context,
  isDismissible: barrierDismissible,
  backgroundColor: context.themeRead.colors.foregroundSurfacePush,
  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
  builder: (_) => SafeArea(top: false, minimum: const EdgeInsets.only(bottom: 20), child: card),
);
