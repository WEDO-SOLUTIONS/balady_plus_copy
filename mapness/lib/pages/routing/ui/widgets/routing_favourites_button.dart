part of '../routing_favourites.dart';

class _Button extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const _Button({
    required this.onTap,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: SizedBox(
          height: 48,
          child: BaladyAppButton(
            buttonColorScheme: BaladyButtonColorScheme.neutral,
            buttonType: BaladyButtonType.secondary,
            primaryIcon: icon,
            onTap: onTap,
          ),
        ),
      );
}
