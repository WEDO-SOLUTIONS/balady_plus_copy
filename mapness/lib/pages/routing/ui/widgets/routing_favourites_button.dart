part of '../routing_favourites.dart';

/// Special button for favourites to be used in [RoutingFavourites].
/// Initially we use it for Home, Work and Favorites.
class _FavButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String semanticsLabel;
  String? label;

  _FavButton({required this.onTap, required this.icon,this.label,required this.semanticsLabel});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Semantics(
        button: true,
        label: semanticsLabel,
        child: ExcludeSemantics(
          child: AppButton(
            buttonColorScheme: ButtonColorScheme.accentSecondary,
            buttonType: ButtonType.secondary,
            primaryLabel: label,
        primaryIcon: icon,
        size: ButtonSize.xLarge,
        iconSize: 17,
        color: context.colors.accentContainerActive,
        textColor: context.colors.foregroundDefault,
        iconColor:context.colors.successContainerActive ,
        textAlignment : ButtonTextAligment.underIcon,
            onTap: onTap,
          ),
        ),
      ),
  );
}
