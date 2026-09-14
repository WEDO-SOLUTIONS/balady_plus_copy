import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/sso_credential_info.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

class SsoCredentialView extends ConsumerWidget {
  const SsoCredentialView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credential = ref.watch(ssoCredentialProvider);

    if (credential == null) {
      return const SizedBox.shrink();
    }

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DebugSectionHeader(
            icon: Icons.key_rounded,
            title: 'SSO Credentials',
            subtitle: 'Authentication information',
            gradient: DebugTheme.gradientPink,
          ),
          const SizedBox(height: 12),
          _CredentialItem(
            label: 'Username',
            value: credential.username ?? '',
          ),
          _CredentialItem(
            label: 'Password',
            value: credential.password ?? '',
            isSecret: true,
          ),
          _CredentialItem(
            label: 'OTP',
            value: credential.otp ?? '',
          ),
        ],
      ),
    );
  }
}

class _CredentialItem extends StatefulWidget {
  const _CredentialItem({
    required this.label,
    required this.value,
    this.isSecret = false,
  });

  final String label;
  final String value;
  final bool isSecret;

  @override
  State<_CredentialItem> createState() => _CredentialItemState();
}

class _CredentialItemState extends State<_CredentialItem> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    final displayValue = widget.isSecret && _isHidden ? '••••••••' : widget.value;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: DebugTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              widget.label,
              style: context.textStyles.captionSmallRegular.copyWith(
                color: DebugTheme.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              style: context.textStyles.captionSmallMedium.copyWith(
                color: DebugTheme.textPrimary,
                fontFamily: widget.isSecret ? null : 'monospace',
              ),
            ),
          ),
          if (widget.isSecret)
            GestureDetector(
              onTap: () => setState(() => _isHidden = !_isHidden),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  _isHidden ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                  size: 16,
                  color: DebugTheme.textMuted,
                ),
              ),
            ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => Clipboard.setData(ClipboardData(text: widget.value)),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.copy_rounded,
                size: 16,
                color: DebugTheme.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
