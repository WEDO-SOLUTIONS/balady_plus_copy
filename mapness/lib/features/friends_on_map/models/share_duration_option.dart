/// R-78's 4 duration options for an S-19 share (15 min / 1 hr / 8 hr / 24
/// hr, default 1 hr) — distinct from `share_eta`'s own `ShareEtaTimeType`,
/// which only has 3 options and lacks the 24h one.
enum ShareDurationOption {
  fifteenMinutes(Duration(minutes: 15)),
  oneHour(Duration(hours: 1)),
  eightHours(Duration(hours: 8)),
  twentyFourHours(Duration(hours: 24));

  const ShareDurationOption(this.duration);

  final Duration duration;
}
