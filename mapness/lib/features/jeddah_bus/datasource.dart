import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/bus/model.dart';
import 'package:mapness/entities/makkah_buses/model.dart';

List<BusLineDtoFeature> _parseLines(String jsonInput) => BusLineDto.fromJson(jsonDecode(jsonInput)).features;

List<BusStationDtoFeature> _parseStations(String jsonInput) => BusStationDto.fromJson(jsonDecode(jsonInput)).features;

class JeddahBusData extends Equatable {
  final Map<int, BusStation> stations;
  final Map<BusLineId, BusLine> lines;

  const JeddahBusData({this.stations = const {}, this.lines = const {}});

  @override
  List<Object?> get props => [stations, lines];

  bool isStationDirectoryObject(DirectoryObjectMessage? object) => getStationByDirectoryObject(object) != null;

  BusStation? getStationByDirectoryObject(DirectoryObjectMessage? object) {
    // the POI might have several ids in different groups so we check if any of them is a station
    final busStationObjectIds = _getStationIdsForDirectoryObject(object);
    for (final id in busStationObjectIds) {
      final station = stations[id];
      if (station != null) {
        return station;
      }
    }
    return null;
  }

  Iterable<int> _getStationIdsForDirectoryObject(DirectoryObjectMessage? object) => [
    object?.id?.objectId,
    ...?object?.group.map((e) => e.id.objectId),
  ].nonNulls;
}

abstract class JeddahBusJsonDatasource {
  Future<JeddahBusData> getInfo() async {
    try {
      final srcLines = await _getLines();
      final srcStations = await _getStations();

      // combine lines and stations responses into cosy model
      final lineTypeToCoordinatesMap = <BusCoordinates, Set<BusLineId>>{};
      for (final line in srcLines) {
        final lineId = BusLineId(
          name: line.properties.routeShortNameEn,
          direction: BusLineDirection.fromString(line.properties.directionType),
        );

        for (final c in line.geometry.coordinates) {
          final coordinates = BusCoordinates.list(c);
          if (lineTypeToCoordinatesMap.containsKey(coordinates)) {
            lineTypeToCoordinatesMap[coordinates]!.add(lineId);
          } else {
            lineTypeToCoordinatesMap[coordinates] = {lineId};
          }
        }
      }

      final stationToCoordinatesMap = <BusCoordinates, BusStation>{};
      for (final s in srcStations) {
        final stationId = int.tryParse(s.properties.stationId);
        if (stationId == null) {
          debugPrint('failed to parse station id for station\n$s');
          continue;
        }
        final coordinates = BusCoordinates.list(s.geometry.coordinates);
        final lineIds = lineTypeToCoordinatesMap[coordinates];
        if (lineIds == null) {
          debugPrint('failed to get line id for station\n$s');
          continue;
        }

        final uniqueLineIds = Map.fromEntries(lineIds.map((e) => MapEntry(e.name, e))).values;

        final station = BusStation(
          stationId: stationId,
          nameEn: s.properties.stationNameEn,
          nameAr: s.properties.stationNameAr,
          coordinates: BusCoordinates.list(s.geometry.coordinates),
          lineIds: uniqueLineIds.sorted((a, b) => a.name.compareTo(b.name)),
        );
        stationToCoordinatesMap[station.coordinates] = station;
      }

      final lines = srcLines
          .map(
            (e) => BusLine(
              id: BusLineId(
                name: e.properties.routeShortNameEn,
                direction: BusLineDirection.fromString(e.properties.directionType),
              ),
              color: e.properties.colorCode.intColorCode ?? 0xFF000000,
              routeShortNameEn: e.properties.routeShortNameEn,
              routeShortNameAr: e.properties.routeShortNameAr,
              routeLongNameEn: e.properties.routeLongNameEn,
              routeLongNameAr: e.properties.routeLongNameAr,
              stations: e.geometry.coordinates
                  .map((e) => stationToCoordinatesMap[BusCoordinates.list(e)])
                  .nonNulls
                  .toList(),
              polylineCoordinates: e.geometry.coordinates.map((e) => BusCoordinates.list(e)).toList(),
            ),
          )
          .toList();

      return JeddahBusData(
        stations: stationToCoordinatesMap.map((_, station) => MapEntry(station.stationId, station)),
        lines: Map.fromEntries(lines.map((e) => MapEntry(e.id, e))),
      );
    } catch (e) {
      debugPrint('failed to get Jeddah bus data: $e');
      return const JeddahBusData();
    }
  }

  Future<List<BusLineDtoFeature>> _getLines();

  Future<List<BusStationDtoFeature>> _getStations();
}

class JeddahBusJsonDatasourceAsset extends JeddahBusJsonDatasource {
  @override
  Future<List<BusLineDtoFeature>> _getLines() async {
    final linesJson = await rootBundle.loadString(Assets.maps.buses.jeddahBusLines);
    return compute(_parseLines, linesJson);
  }

  @override
  Future<List<BusStationDtoFeature>> _getStations() async {
    final linesJson = await rootBundle.loadString(Assets.maps.buses.jeddahBusStations);
    return compute(_parseStations, linesJson);
  }
}

class JeddahBusJsonDatasourceGist extends JeddahBusJsonDatasource {
  final Dio dio = Dio();

  @override
  Future<List<BusLineDtoFeature>> _getLines() async {
    final fileContent = await _getFileContents('b19bedbb11c713abf5d2798dcb24f615');
    return compute(_parseLines, fileContent);
  }

  @override
  Future<List<BusStationDtoFeature>> _getStations() async {
    final fileContent = await _getFileContents('dbf5290d2d898bbd94d28f4d8c809662');
    return compute(_parseStations, fileContent);
  }

  Future<String> _getFileContents(String gistId) async {
    final linesResponse = await dio.get(
      'https://api.github.com/gists/$gistId',
    );
    final files = (linesResponse.data as Map<String, dynamic>?)?['files'] as Map<String, dynamic>?;
    final firstFile = files?['gistfile1.txt'] as Map<String, dynamic>?;
    final fileContent = firstFile?['content'] as String?;
    if (fileContent == null) {
      throw Exception('no file content in linesResponse: ${linesResponse.data}');
    }
    return fileContent;
  }
}
