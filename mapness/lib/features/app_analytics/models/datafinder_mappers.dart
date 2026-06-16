import 'package:dgis_map/library.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/lib/make_address.dart';

/// Maps 2GIS SDK objects into the shared [DataFinderPoi] payload.
///
/// Keeps the field extraction in one place so every call site reports POI data
/// identically. `poi_type` is the API object-type **string** (e.g. `branch`,
/// `street`, `building`) taken from `types.first.type.name` — not the rubric id,
/// per ByteDance.
extension DataFinderDirectoryObject on DirectoryObjectMessage {
  /// Builds a [DataFinderPoi]. [rank] is 1-based; [myLat]/[myLon] enable the
  /// distance computation (omitted when location is unavailable).
  DataFinderPoi toDataFinderPoi({int? rank, double? myLat, double? myLon}) {
    double? distanceMeters;
    final pos = markerPosition;
    if (pos != null && myLat != null && myLon != null) {
      // CommonFunctions.distance returns km; convert to meters for formatting.
      distanceMeters = CommonFunctions.distance(pos.latitude, pos.longitude, myLat, myLon) * 1000;
    }

    return DataFinderPoi(
      id: id?.objectId.toString(),
      name: title,
      address: makeAddress(),
      type: types.firstOrNull?.type.name,
      distanceKm: DataFinderPoi.formatDistanceKm(distanceMeters),
      rank: rank,
    );
  }
}

/// Maps a suggestion into a [DataFinderPoi]. POI fields are only available when
/// the suggestion wraps an object (`handler.objectHandler`); for text/rubric
/// suggestions only the title is filled.
extension DataFinderSuggest on SuggestMessage {
  /// Builds a [DataFinderPoi] for a suggestion. Keeps the underlying object's
  /// `type` as `poi_type`, and carries the **suggestion type**
  /// (`suggestedType.name`, e.g. `branch`, `rubric`, `street`) separately in
  /// [DataFinderPoi.suggestionType] so `suggestion_exposure` can report
  /// `suggestion_type` (BRD) without clobbering `poi_type`.
  DataFinderPoi toDataFinderPoi({int? rank, double? myLat, double? myLon}) {
    final object = handler.objectHandler?.item;
    if (object != null) {
      return object
          .toDataFinderPoi(rank: rank, myLat: myLat, myLon: myLon)
          .copyWith(suggestionType: dataFinderSuggestionType);
    }
    return DataFinderPoi(name: title.text, suggestionType: dataFinderSuggestionType, rank: rank);
  }

  /// The SDK suggestion type as a string (e.g. `branch`, `rubric`, `street`).
  String get dataFinderSuggestionType => suggestedType.name;
}
