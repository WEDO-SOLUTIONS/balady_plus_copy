part of 'prayer_times_cubit.dart';

class PrayerTimesState extends Equatable {
  final BlocRequestStatus status;
  final PrayerTimesResponse? prayerTimesResponse;
  final GISResponse? gisResponse;
  final PrayerTimeEntity? nextPrayer;
  final String? errorMessage;
  final bool? userLocationUnkown;
  final List<PrayerTimeRangeEntity> prayersRange;
  final List<String> prayerTimeSettings;

  const PrayerTimesState({
    this.status = BlocRequestStatus.initial,
    this.prayerTimesResponse,
    this.gisResponse,
    this.nextPrayer,
    this.errorMessage,
    this.userLocationUnkown,
    this.prayersRange = const [],
    this.prayerTimeSettings = const [],
  });

  bool get isAM =>
      nextPrayer?.prayer == Prayers.fajr ||
      nextPrayer?.prayer == Prayers.dhuhr ||
      nextPrayer?.prayer == Prayers.asr;

  String get error => errorMessage ?? '';
  bool get isNotificationDisable => prayerTimeSettings.contains("0");

  PrayerTimesState copyWith({
    BlocRequestStatus? status,
    PrayerTimesResponse? prayerTimes,
    GISResponse? gisResponse,
    PrayerTimeEntity? nextPrayer,
    String? errorMessage,
    bool? userLocationUnkown,
    List<PrayerTimeRangeEntity>? prayersRange,
    bool? isNotificationOn,
    List<String>? prayerTimeSettings,
  }) {
    return PrayerTimesState(
      status: status ?? this.status,
      prayerTimesResponse: prayerTimes ?? prayerTimesResponse,
      gisResponse: gisResponse ?? this.gisResponse,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      errorMessage: errorMessage ?? this.errorMessage,
      userLocationUnkown: userLocationUnkown ?? this.userLocationUnkown,
      prayersRange: prayersRange ?? this.prayersRange,
      prayerTimeSettings: prayerTimeSettings ?? this.prayerTimeSettings,
    );
  }

  @override
  List<Object?> get props => [
        status,
        prayerTimesResponse,
        gisResponse,
        nextPrayer,
        errorMessage,
        userLocationUnkown,
        prayersRange,
        prayerTimeSettings,
      ];
}
