part of 'prayer_times_cubit.dart';

class PrayerTimesState extends Equatable {
  final BlocRequestStatus status;
  final PrayerTimesResponse? prayerTimesResponse;
  final GISResponse? gisResponse;
  final PrayerTimeEntity? nextPrayer;
  final String? errorMessage;

  const PrayerTimesState({
    this.status = BlocRequestStatus.initial,
    this.prayerTimesResponse,
    this.gisResponse,
    this.nextPrayer,
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  PrayerTimesState copyWith({
    BlocRequestStatus? status,
    PrayerTimesResponse? prayerTimes,
    GISResponse? gisResponse,
    PrayerTimeEntity? nextPrayer,
    String? errorMessage,
  }) {
    return PrayerTimesState(
      status: status ?? this.status,
      prayerTimesResponse: prayerTimes ?? prayerTimesResponse,
      gisResponse: gisResponse ?? this.gisResponse,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        prayerTimesResponse,
        gisResponse,
        nextPrayer,
        errorMessage,
      ];
}
