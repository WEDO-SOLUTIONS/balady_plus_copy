import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/common/providers/user_state.dart';

import '../../common/config/package_config.dart';

class UserStatePicker extends StatelessWidget {
  const UserStatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        UserStateRow(userState: UserState.guest),
        UserStateRow(userState: UserState.personal),
        UserStateRow(userState: UserState.business)
      ],
    );
  }
}

class UserStateRow extends ConsumerWidget {
  const UserStateRow({
    super.key,
    required this.userState,
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
          ref.read(userStateProvider.notifier).update(userState);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                currentLanguage == userState
                    ? "assets/icons/svg/ic_radio_on.svg"
                    : "assets/icons/svg/ic_radio_off.svg",
                height: 24,
                width: 24,
                package: PackageConfig.packageName,
              ),
              const Spacer(),
              Text(
                userState.name,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  height: 1.4,
                  color: const Color(0xFF1E2A36),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
