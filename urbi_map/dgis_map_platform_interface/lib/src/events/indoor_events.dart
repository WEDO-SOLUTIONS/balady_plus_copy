/// Indoor levels events
class IndoorLevelsEvent {
  /// Indoor levels events
  IndoorLevelsEvent(this.levelNames, this.objectId);

  /// Event name
  static const name = 'levelNames';

  /// Indoor levels
  final List<IndoorLevel> levelNames;

  /// Id of object to which the levels belong
  final int objectId;
}

/// Indoor levels hiding events
class HideIndoorLevelsEvent {
  /// Event name
  static const name = 'hideLevels';
}

/// Indoor active level selection event
class IndoorActiveLevelEvent {
  /// Indoor active level selection event
  IndoorActiveLevelEvent(this.index);

  /// Event name
  static const name = 'activeLevelIndex';

  /// Index of selected level
  final int index;
}

/// Indoor level model
class IndoorLevel {
  /// Indoor level model
  IndoorLevel(this.name, this.levelIndex);

  /// Level name
  final String name;

  /// Level index
  final int levelIndex;
}
