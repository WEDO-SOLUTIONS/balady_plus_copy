int? parseObjectIdFromFavouriteEntityId(String? entityId) {
  if (entityId == null || entityId.isEmpty) {
    return null;
  }

  final separatorIndex = entityId.indexOf('-');
  final objectIdPart = separatorIndex == -1 ? entityId : entityId.substring(0, separatorIndex);

  return int.tryParse(objectIdPart);
}

String buildFavouriteEntityId({
  required int objectId,
  required int entranceId,
}) =>
    '$objectId-$entranceId';
