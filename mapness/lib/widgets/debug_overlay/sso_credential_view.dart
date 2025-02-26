import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/sso_credential_info.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class SsoCredentialView extends ConsumerWidget {
  const SsoCredentialView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credential = ref.watch(ssoCredentialProvider);

    return Column(
      children: [
        Text(
          'SSO Credentials',
          style: Theme.of(context).extension<ThemeTextStyles>()?.footNote.copyWith(color: Colors.black),
        ),
        _infoItem(
          context,
          title: 'Username',
          value: credential?.username ?? '',
        ),
        const SizedBox(height: 4),
        _infoItem(
          context,
          title: 'Password',
          value: credential?.password ?? '',
        ),
        const SizedBox(height: 4),
        _infoItem(
          context,
          title: 'OTP',
          value: credential?.otp ?? '',
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

Widget _infoItem(
  BuildContext context, {
  required String title,
  required String value,
}) =>
    Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).extension<ThemeTextStyles>()?.footNoteBold.copyWith(color: Colors.black),
              ),
              Text(
                value,
                style: Theme.of(context).extension<ThemeTextStyles>()?.footNoteBold.copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
        LabeledElevatedButton(
          onPressed: () => Clipboard.setData(ClipboardData(text: value)),
          label: 'copy',
        ),
      ],
    );
