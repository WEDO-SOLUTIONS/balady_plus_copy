part of '../routing_favourites.dart';

/// Special button for favourites to be used in [RoutingFavourites].
/// Initially we use it for Home, Work and Favorites.
class _FavButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String semanticsLabel;

  const _FavButton({required this.onTap, required this.icon, required this.semanticsLabel});

  @override
  Widget build(BuildContext context) => Expanded(
    child: SizedBox(
      height: 48,
      child: Semantics(
        button: true,
        label: semanticsLabel,
        child: ExcludeSemantics(
          child: AppButton(
            buttonColorScheme: ButtonColorScheme.accentSecondary,
            buttonType: ButtonType.secondary,
            primaryIcon: icon,
            onTap: onTap,
          ),
        ),
      ),
    ),
  );
}
