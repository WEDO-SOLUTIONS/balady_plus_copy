part of 'profile_image_widget.dart';

class DefaultProfileImage extends ConsumerWidget {
  final double dimension;
  final Color? color;
  const DefaultProfileImage({
    required this.dimension,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (dimension < 40) {
      return Icon(
        GeneralIcons.userCircle,
        size: dimension,
        color: color ?? context.colors.foregroundSoft,
      );
    }
    final userData = ref.read(authProvider);
    final name = getFirstLetters(userData.valueOrNull);

    return Container(
      width: dimension,
      height: dimension,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            context.colors.accentSecondarySoft,
            context.colors.accentSecondaryActive,
          ],
        ),
      ),
      child: name != null
          ? Text(
              name,
              style: context.textStyles.h1SemiBold.copyWith(
                color: context.colors.backgroundSurface1,
              ),
            )
          : Assets.icons.svg.icProfile.svg(
              height: 36,
              width: 36,
              colorFilter: ColorFilter.mode(
                context.colors.backgroundSurface1,
                BlendMode.srcIn,
              ),
            ),
    );
  }

  String? getFirstLetters(SsoUserInfo? userInfo) {
    final names = userInfo?.getFirstAndLastName().split(' ');
    if (names == null) {
      return null;
    }
    if (names.isEmpty) {
      return null;
    }
    if (names.length == 1 && names.first.isNotEmpty) {
      return names.first.characters.first.toUpperCase();
    }
    final firstLetter = names.first.isNotEmpty ? names.first[0].toUpperCase() : '';
    final secondLetter = names.last.isNotEmpty ? names.last[0].toUpperCase() : '';
    return '$firstLetter$secondLetter';
  }
}
