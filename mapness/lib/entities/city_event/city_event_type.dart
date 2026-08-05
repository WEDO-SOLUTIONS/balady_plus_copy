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
    _ => Assets.icons.svg.placesNew.old.icMarkerMNew.keyName,
  };

  String defaultPin({bool isDark = false}) => switch (this) {
    CityEventType.foundingDay =>
      isDark
          ? Assets.icons.svg.placesNewFoundingDayBigDark.icDefault.keyName
          : Assets.icons.svg.placesNewFoundingDayBig.icDefault.keyName,
    CityEventType.saudiNationalDay => Assets.icons.svg.icPinNewSaudiDay.keyName,
    _ => Assets.icons.svg.placesBigNew.light.icPinNew.keyName,
  };

  MarkerIconMessage getIcParking({bool isDark = false}) {
    if (isDark) {
      Assets.icons.svg.placesNew.dark.icParking.keyName.markerIcon();
    }
    return switch (this) {
      CityEventType.saudiNationalDay => Assets.icons.svg.placesNewSaudiDay.icParking.keyName.markerIcon(),
      _ => Assets.icons.svg.placesBigNew.light.icParking.keyName.markerIcon(),
    };
  }
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

  List<Color> get fireworkGradientColors => switch (this) {
    CityEventType.saudiNationalDay => const [Color(0xFF014850), Color(0xFF00343A)],
    CityEventType.foundingDay => const [
      Color(0xFFDE8830),
      Color(0xFF724432),
      Color(0xFFEEC230),
      Color(0xFF02964E),
    ],
    _ => const [Color(0xFF4EC9C0), Color(0xFF2AB3A9)],
  };

  List<List<Color>> get fireworkGradientColors2 => switch (this) {
    // one shader darke
    CityEventType.foundingDay => const [
      [
        Color(0xFFDE8830),
        Color(0xFF724432),
      ],
      [
        Color(0xFF724432),
        Color(0xFFDE8830),
      ],
      [
        Color(0xFFEEC230),
        Color(0xFF02964E),
      ],
      [
        Color(0xFF02964E),
        Color(0xFFEEC230),
      ],
    ],
    _ => const [
      [Color(0xFF4EC9C0)],
      [Color(0xFF2AB3A9)],
    ],
  };
}

extension StyleX on CityEventType? {
  String get stylePath => switch (this) {
    CityEventType.saudiNationalDay => MapnessConstants.mapStylesSaudiPath,
    CityEventType.foundingDay => MapnessConstants.mapStylesFoundingDayPath,
    _ => MapnessConstants.mapStylesPath,
  };
}

extension DriveBackX on CityEventType? {
  ImageProvider getDriveHomeBackground({bool isDark = false}) {
    if (isDark) {
      return Assets.images.driveHomeBackgroundDark.provider();
    }
    return switch (this) {
      CityEventType.saudiNationalDay => Assets.images.driveHomeBackgroundSaudiday.provider(),
      CityEventType.foundingDay => Assets.images.driveHomeBackgroundFoundingDay.provider(),
      _ => Assets.images.driveHomeBackground.provider(),
    };
  }

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

  String getIllustrationNotifications({required bool isDark}) => isDark
      ? Assets.imagesSvg.illustrationNotificationsDark.keyName
      : switch (this) {
          CityEventType.foundingDay => Assets.imagesSvg.illustrationNotificationsFoundatonDay.keyName,
          _ => Assets.imagesSvg.illustrationNotifications.keyName,
        };

  String getIllustrationPercent({required bool isDark}) => isDark
      ? Assets.imagesSvg.illustrationPercentDark.keyName
      : switch (this) {
          CityEventType.foundingDay => Assets.imagesSvg.illustrationPercentFoundingDay.keyName,
          _ => Assets.imagesSvg.illustrationPercent.keyName,
        };
}

extension TrafficControlX on CityEventType? {
  Widget trafficIcon({
    required bool isDark,
    Color? inactiveColor,
    bool isOn = false,
  }) {
    final defaultOff = isDark ? Assets.icons.svg.darkCar : Assets.icons.svg.car;
    final defaultOn = isDark ? Assets.icons.svg.darkCarActive : Assets.icons.svg.carActive;

    final asset = switch (this) {
      CityEventType.saudiNationalDay when isOn => Assets.icons.svg.carActiveSaudi,
      CityEventType.foundingDay when isOn => Assets.icons.svg.carActiveFoundingDay,
      _ => isOn ? defaultOn : defaultOff,
    };

    return SvgPicture.asset(
      asset.keyName,
      colorFilter: inactiveColor != null ? ColorFilter.mode(inactiveColor, BlendMode.srcIn) : null,
    );
  }
}
