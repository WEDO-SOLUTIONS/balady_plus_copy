part of 'prayer_times_cubit.dart';

class PrayerTimesState extends Equatable {
  final BlocRequestStatus status;
  final PrayerTimesResponse? prayerTimesResponse;
  final GISResponse? gisResponse;
  final PrayerTimeEntity? nextPrayer;
  final String? errorMessage;
  final bool? userLocationUnkown;

  const PrayerTimesState(
      {this.status = BlocRequestStatus.initial,
      this.prayerTimesResponse,
      this.gisResponse,
      this.nextPrayer,
      this.errorMessage,
      this.userLocationUnkown});

  String get error => errorMessage ?? '';

  PrayerTimesState copyWith({
    BlocRequestStatus? status,
    PrayerTimesResponse? prayerTimes,
    GISResponse? gisResponse,
    PrayerTimeEntity? nextPrayer,
    String? errorMessage,
    bool? userLocationUnkown,
  }) {
    return PrayerTimesState(
        status: status ?? this.status,
        prayerTimesResponse: prayerTimes ?? prayerTimesResponse,
        gisResponse: gisResponse ?? this.gisResponse,
        nextPrayer: nextPrayer ?? this.nextPrayer,
        errorMessage: errorMessage ?? this.errorMessage,
        userLocationUnkown: userLocationUnkown ?? this.userLocationUnkown);
  }

  @override
  List<Object?> get props => [
        status,
        prayerTimesResponse,
        gisResponse,
        nextPrayer,
        errorMessage,
        userLocationUnkown
      ];
}
