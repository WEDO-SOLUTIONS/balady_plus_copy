int? parseObjectIdFromFavouriteEntityId(String? entityId) {
  if (entityId == null || entityId.isEmpty) {
    return null;
  }

  final separatorIndex = entityId.indexOf('-');
  final objectIdPart = separatorIndex == -1 ? entityId : entityId.substring(0, separatorIndex);

  return int.tryParse(objectIdPart);
}

int? parseEntranceIdFromFavouriteEntityId(String? entityId) {
  if (entityId == null || entityId.isEmpty) {
    return null;
  }

  final separatorIndex = entityId.indexOf('-');
  if (separatorIndex == -1) {
    return null;
  }

  return int.tryParse(entityId.substring(separatorIndex + 1));
}

String buildFavouriteEntityId({
  required int objectId,
  required int entranceId,
}) => '$objectId-$entranceId';
