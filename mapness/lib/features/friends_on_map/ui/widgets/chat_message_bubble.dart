import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/friends_on_map/models/chat_message.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// One message in the thread (S-21). Own messages sit on the end side
/// (mirrors in RTL), received ones on the start side. R-102/N-12: delivery
/// state is an icon plus a screen-reader label, never colour alone.
class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onOpenPlace;

  const ChatMessageBubble({required this.message, this.onTap, this.onLongPress, this.onOpenPlace, super.key});

  @override
  Widget build(BuildContext context) {
    final mine = message.mine;
    final background = mine ? context.colors.accentSecondaryContainerDefault : context.colors.backgroundSurface1;
    final foreground = mine ? context.colors.accentSecondaryOnContainer : context.colors.foregroundDefault;

    return Align(
      alignment: mine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$1x),
          child: GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            child: DecoratedBox(
              decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(RadiusBorder.xl)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x, vertical: Spacing.$2x),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _content(context, foreground),
                    const SizedBox(height: Spacing.$1x),
                    _footer(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, Color foreground) {
    if (message.deleted) {
      return Text(
        context.l10n.chatMessageDeleted,
        style: context.textStyles.bodyLargeRegular.copyWith(
          color: context.colors.foregroundMuted,
          fontStyle: FontStyle.italic,
        ),
      );
    }
    if (message.kind == ChatMessageKind.placeCard && message.place != null) {
      final label = message.place!.label;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(GeneralIcons.location, color: foreground, size: 20),
              const SizedBox(width: Spacing.$2x),
              Flexible(
                child: Text(
                  label == null || label.isEmpty ? context.l10n.chatPreviewPlace : label,
                  style: context.textStyles.bodyLargeMedium.copyWith(color: foreground),
                ),
              ),
            ],
          ),
          if (onOpenPlace != null)
            GestureDetector(
              onTap: onOpenPlace,
              child: Padding(
                padding: const EdgeInsets.only(top: Spacing.$2x),
                child: Text(
                  context.l10n.chatPlaceOpenOnMap,
                  style: context.textStyles.bodySmallSemiBold.copyWith(color: context.colors.accentDefault),
                ),
              ),
            ),
        ],
      );
    }
    return Text(message.body ?? '', style: context.textStyles.bodyLargeRegular.copyWith(color: foreground));
  }

  Widget _footer(BuildContext context) {
    final time = TimeOfDay.fromDateTime(message.displayTime.toLocal()).format(context);
    final muted = context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft);
    if (!message.mine || message.deleted) {
      return Text(time, style: muted);
    }

    final (icon, label, color) = switch (message.status) {
      ChatMessageStatus.pending => (Icons.schedule, context.l10n.chatStatusSending, context.colors.foregroundSoft),
      ChatMessageStatus.failed => (Icons.error_outline, context.l10n.chatStatusNotSent, context.colors.errorDefault),
      ChatMessageStatus.sent => (Icons.check, context.l10n.chatStatusSent, context.colors.foregroundSoft),
      ChatMessageStatus.delivered => (Icons.done_all, context.l10n.chatStatusDelivered, context.colors.foregroundSoft),
      ChatMessageStatus.read => (Icons.done_all, context.l10n.chatStatusRead, context.colors.accentDefault),
    };
    return Semantics(
      label: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(time, style: muted),
          const SizedBox(width: Spacing.$1x),
          Icon(icon, size: 14, color: color),
          if (message.status == ChatMessageStatus.failed) ...[
            const SizedBox(width: Spacing.$1x),
            Flexible(
              child: Text(label, style: muted.copyWith(color: color)),
            ),
          ],
        ],
      ),
    );
  }
}
