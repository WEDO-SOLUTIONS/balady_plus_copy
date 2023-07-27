class IndoorLevelsEvent {
  IndoorLevelsEvent(this.levelNames);

  static const name = 'levelNames';

  final List<IndoorLevel> levelNames;
}

class IndoorActiveLevelEvent {
  IndoorActiveLevelEvent(this.index);

  static const name = 'activeLevelIndex';

  final int index;
}

class IndoorLevel {
  IndoorLevel(this.name, this.levelIndex);

  final String name;
  final int levelIndex;
}
