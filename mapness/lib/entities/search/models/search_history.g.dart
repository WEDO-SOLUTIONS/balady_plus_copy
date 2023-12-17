// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchHistoryItemAdapter extends TypeAdapter<SearchHistoryItem> {
  @override
  final int typeId = 1;

  @override
  SearchHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchHistoryItem(
      title: fields[0] as String,
      address: fields[1] as String,
      objectId: fields[2] as int?,
      entranceId: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SearchHistoryItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.objectId)
      ..writeByte(3)
      ..write(obj.entranceId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
