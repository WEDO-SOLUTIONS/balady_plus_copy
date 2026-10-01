import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// Appendix B / R-100: the message length cap. Mirrors the server's
/// authoritative `LIMIT_MESSAGE_LENGTH` default; the server still enforces
/// it (and its `message_too_long` error is shown if the two ever differ).
const int kChatMessageMaxLength = 2000;

/// Compose bar: text field, "send a place" (R-117) and send. Clears itself
/// on send — the message is already in the thread as pending (R-103), so
/// there is nothing to wait for.
class ChatInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;
  final VoidCallback onSendPlace;

  const ChatInputBar({required this.onSend, required this.onSendPlace, super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }
    _controller.clear();
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: context.colors.backgroundSurface1,
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$2x, vertical: Spacing.$2x),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              tooltip: context.l10n.chatSendPlace,
              onPressed: widget.onSendPlace,
              icon: Icon(GeneralIcons.location, color: context.colors.accentDefault),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                inputFormatters: [LengthLimitingTextInputFormatter(kChatMessageMaxLength)],
                style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
                decoration: InputDecoration(
                  hintText: context.l10n.chatInputHint,
                  hintStyle: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundSoft),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              tooltip: context.l10n.chatInputHint,
              onPressed: _send,
              icon: Icon(Icons.send, color: context.colors.accentDefault),
            ),
          ],
        ),
      ),
    ),
  );
}
