/// Event that appears when sound on/off is changed in CarPlay or Android Auto
class SoundOnEvent {
  /// Constructor
  const SoundOnEvent({required this.value});

  /// Event name for Platform
  static const name = "soundOnEvent";

  /// Value of sound on/off
  final bool value;
}
