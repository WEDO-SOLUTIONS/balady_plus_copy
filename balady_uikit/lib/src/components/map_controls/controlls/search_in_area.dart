part of '../map_controls.dart';

class SearchInArea extends StatelessWidget {
  final Function()? onTap;
  final bool visible;
  final String title;

  const SearchInArea({
    required this.visible,
    required this.title,
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: visible ? 0 : null,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: MapButton(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x),
          child: Text(
            title,
            style: context.textStyles.bodyLargeSemiBold.copyWith(
              color: context.colors.foregroundDefault,
            ),
          ),
        ),
      ),
    );
  }
}
