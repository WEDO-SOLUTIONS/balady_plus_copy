part of 'city_event.dart';

enum CityEventType {
  saudiNationalDay(priority: 2),
  cityscape(priority: 3),
  foundingDay(priority: 4);

  final int priority;
  const CityEventType({required this.priority});

  bool get isFoundingDay => this == CityEventType.foundingDay;

  bool get isSaudiNationalDay => this == CityEventType.saudiNationalDay;

  bool get isCityscape => this == CityEventType.cityscape;
}

extension DefaultMarkerExt on CityEventType? {
  String get defaultMarker => switch (this) {
        CityEventType.foundingDay => Assets.icons.svg.placesNewFoundingDay.icDefault.keyName,
        CityEventType.saudiNationalDay => Assets.icons.svg.icMarkerMNewSaudiDay.keyName,
        _ => Assets.icons.svg.icMarkerMNew.keyName,
      };

  String get defaultPin => switch (this) {
        CityEventType.foundingDay => Assets.icons.svg.placesNewFoundingDay.icDefault.keyName,
        CityEventType.saudiNationalDay => Assets.icons.svg.icPinNewSaudiDay.keyName,
        _ => Assets.icons.svg.icPinNew.keyName,
      };

  MarkerIconMessage get icParking => switch (this) {
        CityEventType.saudiNationalDay => Assets.icons.svg.placesNew.icParking.keyName.markerIcon(),
        _ => Assets.icons.svg.placesNew.icParking.keyName.markerIcon(),
      };
}

extension FullAddressLogo on CityEventType {
  String? get addressLogoAsset => switch (this) {
        CityEventType.foundingDay => Assets.images.foundingDayCircleLogo.keyName,
        _ => null,
      };
}

extension FeedbackDashboard on CityEventType? {
  String get feedbackDashboard => switch (this) {
        CityEventType.saudiNationalDay => Assets.images.feedbackDashboardSaudiday.keyName,
        CityEventType.foundingDay => Assets.images.feedbackDashboardFoundingDay.keyName,
        _ => Assets.images.feedbackDashboard.keyName,
      };

  List<Color> get feedbackDashboardGradientColors => switch (this) {
        CityEventType.saudiNationalDay => const [Color(0xFF014850), Color(0xFF00343A)],
        CityEventType.foundingDay => const [Color(0xFFB28F64), Color(0xFF846743)],
        _ => const [Color(0xFF4EC9C0), Color(0xFF2AB3A9)],
      };
}

extension StyleX on CityEventType? {
  String get stylePath => switch (this) {
        CityEventType.saudiNationalDay => MapnessConstants.mapStylesSaudiPath,
        CityEventType.foundingDay => MapnessConstants.mapStylesFoundingDayPath,
        _ => MapnessConstants.mapStylesFoundingDayPath,
      };
}

extension DriveBackX on CityEventType? {
  ImageProvider get driveHomeBackground => switch (this) {
        CityEventType.saudiNationalDay => Assets.images.driveHomeBackgroundSaudiday.provider(),
        CityEventType.foundingDay => Assets.images.driveHomeBackgroundFoundingDay.provider(),
        _ => Assets.images.driveHomeBackground.provider(),
      };
  Widget get driveHomeArrow => switch (this) {
        CityEventType.saudiNationalDay => Assets.images.driveHomeArrowSaudiday.image(matchTextDirection: true),
        CityEventType.foundingDay => Transform.translate(
            offset: const Offset(0, -35),
            child: Assets.images.driveHomeArrowFoundingDay.image(matchTextDirection: true),
          ),
        _ => Assets.images.driveHomeArrow.image(matchTextDirection: true),
      };
  Color textColor(AppColorsThemeV3 colors) => switch (this) {
        CityEventType.saudiNationalDay => colors.foregroundDefault,
        CityEventType.foundingDay => colors.foregroundDefault,
        _ => colors.staticWhite,
      };

  bool get showBlueCircles => switch (this) {
        CityEventType.saudiNationalDay => false,
        CityEventType.foundingDay => false,
        _ => true,
      };
}

extension IllustrationsX on CityEventType? {
  String get illustrationError => switch (this) {
        CityEventType.foundingDay => Assets.imagesSvg.illustrationErrorFoundationDay.keyName,
        _ => Assets.imagesSvg.illustrationError.keyName,
      };
  String get illustrationNotifications => switch (this) {
        CityEventType.foundingDay => Assets.imagesSvg.illustrationNotificationsFoundatonDay.keyName,
        _ => Assets.imagesSvg.illustrationNotifications.keyName,
      };
}
