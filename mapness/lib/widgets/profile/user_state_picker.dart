import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/providers/user_state.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

class UserStatePicker extends StatelessWidget {
  const UserStatePicker({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    children: [
      UserStateRow(userState: UserState.guest),
      UserStateRow(userState: UserState.personal),
      UserStateRow(userState: UserState.business),
    ],
  );
}

class UserStateRow extends ConsumerWidget {
  const UserStateRow({
    required this.userState,
    super.key,
  });

  final UserState userState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(userStateProvider);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          ref.read(userStateProvider.notifier).value = userState;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                currentLanguage == userState ? Assets.icons.svg.icRadioOn.keyName : Assets.icons.svg.icRadioOff.keyName,
                height: 24,
                width: 24,
              ),
              const Spacer(),
              Text(
                userState.name,
                style: context.textStyle.text.copyWith(
                  color: context.colors.foregroundDefault,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
