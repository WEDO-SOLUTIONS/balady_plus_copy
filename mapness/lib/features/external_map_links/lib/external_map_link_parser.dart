// Parses the map links other apps hand us — the `baladymaps://` scheme
// (Meta/WhatsApp "Open in Balady+") and Android `geo:` URIs — into the
// platform-agnostic intents in `models/external_map_link_intent.dart`.
//
// Two rules keep this file honest:
//   * we never guess. A link we cannot read returns `null`, and the caller
//     simply does nothing instead of dropping the user on a wrong point;
//   * we decode exactly once, through `Uri.queryParameters`. Running
//     `Uri.decodeFull` on top of it would double-decode Arabic queries and
//     turn an escaped `%26`/`%2C` inside a name into a parameter separator.

import '../models/external_map_link_intent.dart';

/// Pure, synchronous parser for external map links. Stateless by design so it
/// can be unit-tested without Flutter or the map SDK.
abstract final class ExternalMapLinkParser {
  /// Scheme registered for third-party "Open in Balady+" menu entries.
  static const String baladyScheme = 'baladymaps';

  /// RFC 5870 `geo:` URIs — the system-wide Android "open a map" intent.
  static const String geoScheme = 'geo';

  /// Labels are rendered as the point-card title; anything longer than this is
  /// a payload rather than a name, so we cut it instead of refusing the link.
  static const int maxLabelLength = 120;

  /// Zoom bounds accepted by the map; callers routinely send `0` or `99`.
  static const double minZoom = 1;
  static const double maxZoom = 20;

  /// `lat,lng` with a dot decimal separator regardless of the caller's locale.
  ///
  /// ASCII-only on purpose: `\d` never matches Arabic-Indic digits, and a
  /// comma decimal separator (`24,7136`) cannot be told apart from a pair, so
  /// both are rejected rather than mis-read.
  static final RegExp _coordinatePair = RegExp(
    r'^\s*([-+]?\d{1,3}(?:\.\d+)?)\s*,\s*([-+]?\d{1,3}(?:\.\d+)?)\s*$',
  );

  /// The same pair followed by an optional `(label)`.
  ///
  /// Greedy and dot-all so a label may itself contain commas, brackets and
  /// newlines; it is matched against the raw value *before* any comma split.
  static final RegExp _coordinateWithLabel = RegExp(
    r'^\s*([-+]?\d{1,3}(?:\.\d+)?)\s*,\s*([-+]?\d{1,3}(?:\.\d+)?)\s*(?:\((.*)\))?\s*$',
    dotAll: true,
  );

  /// Whether [scheme] belongs to this parser. Everything else (https share
  /// links, short links, universal links, `insiderbaladyapp`) keeps its old
  /// route through the legacy deep-link handler.
  static bool handlesScheme(String scheme) {
    final normalized = scheme.trim().toLowerCase();
    return normalized == baladyScheme || normalized == geoScheme;
  }

  /// Turns [uri] into an actionable intent, or `null` when the link is not
  /// ours or is malformed.
  static ExternalMapLinkIntent? parse(Uri uri) {
    try {
      final scheme = uri.scheme.trim().toLowerCase();
      return switch (scheme) {
        baladyScheme => _parseBaladyMaps(_queryParameters(uri)),
        geoScheme => _parseGeo(uri),
        _ => null,
      };
    } on FormatException {
      // Broken percent-escapes anywhere in the URI: nothing to act on.
      return null;
    }
  }

  // --- baladymaps:// -------------------------------------------------------

  /// Precedence is `daddr` (routing) → `ll` (point) → `q`/`text` (search):
  /// a caller that sent an exact destination never wants a plain search.
  static ExternalMapLinkIntent? _parseBaladyMaps(Map<String, String> params) {
    final destination = _nonEmpty(params['daddr']);
    if (destination != null) {
      final source = _nonEmpty(params['saddr']);
      return ExternalMapDirectionsIntent(
        destination: _parsePlace(destination),
        // Absent, empty or `current` all mean "start from where I am"; the
        // routing page asks for the location permission itself.
        source: source == null || source.toLowerCase() == 'current' ? null : _parsePlace(source),
        mode: ExternalMapTravelMode.fromToken(params['mode']),
      );
    }

    final rawPoint = _nonEmpty(params['ll']);
    if (rawPoint != null) {
      final point = parseCoordinatePair(rawPoint);
      // `ll` is an explicit promise of a coordinate. If it does not hold we
      // drop the whole link instead of silently searching for its text.
      if (point == null) {
        return null;
      }
      return ExternalMapShowLocationIntent(
        point: point,
        label: _sanitizeLabel(params['label']),
        zoom: parseZoom(params['z']),
      );
    }

    final query = _nonEmpty(params['q']) ?? _nonEmpty(params['text']);
    if (query != null) {
      // Here `q` is always free text — the `q = lat,lon` reading stays in the
      // legacy https share-link parser. An unusable `near` only costs us the
      // bias, so the search still runs.
      return ExternalMapSearchIntent(query: query, near: parseCoordinatePair(params['near']));
    }

    return null;
  }

  static ExternalMapPlace _parsePlace(String raw) {
    final point = parseCoordinatePair(raw);
    if (point != null) {
      return ExternalMapPlacePoint(point: point);
    }
    return ExternalMapPlaceQuery(query: raw.trim());
  }

  // --- geo: ----------------------------------------------------------------

  /// `geo:lat,lng`, `geo:lat,lng?z=`, and the Android convention where the
  /// path is the sentinel `0,0` and the real target sits in `q` — either as
  /// an address to search or as `lat,lng(label)` to show directly.
  static ExternalMapLinkIntent? _parseGeo(Uri uri) {
    final params = _queryParameters(uri);
    final pathPoint = parseCoordinatePair(_geoPathCoordinates(uri));
    final query = _nonEmpty(params['q']);

    if (query != null) {
      final place = parseCoordinateWithLabel(query);
      if (place != null) {
        return ExternalMapShowLocationIntent(point: place.point, label: place.label, zoom: parseZoom(params['z']));
      }
      return ExternalMapSearchIntent(
        query: query,
        // `0,0` is the "ignore me" sentinel, never a hint for Null Island.
        near: pathPoint == null || pathPoint.isNullIsland ? null : pathPoint,
      );
    }

    if (pathPoint != null && !pathPoint.isNullIsland) {
      return ExternalMapShowLocationIntent(point: pathPoint, zoom: parseZoom(params['z']));
    }

    return null;
  }

  /// Strips the RFC 5870 `;u=<uncertainty>` suffix and a third `altitude`
  /// component so the plain `lat,lng` pair is left.
  static String _geoPathCoordinates(Uri uri) {
    var raw = uri.path;
    final parameterStart = raw.indexOf(';');
    if (parameterStart >= 0) {
      raw = raw.substring(0, parameterStart);
    }

    final components = raw.split(',');
    if (components.length > 2) {
      raw = '${components[0]},${components[1]}';
    }
    return raw;
  }

  // --- shared helpers (public for the unit tests) --------------------------

  /// Parses `lat,lng`. Returns `null` for anything that is not a finite pair
  /// inside ±90 / ±180.
  static ExternalMapPoint? parseCoordinatePair(String? raw) {
    if (raw == null) {
      return null;
    }
    final match = _coordinatePair.firstMatch(raw);
    if (match == null) {
      return null;
    }
    return _point(match.group(1), match.group(2));
  }

  /// Parses `lat,lng` optionally followed by `(label)`.
  static ExternalMapPlacePoint? parseCoordinateWithLabel(String? raw) {
    if (raw == null) {
      return null;
    }
    final match = _coordinateWithLabel.firstMatch(raw);
    if (match == null) {
      return null;
    }
    final point = _point(match.group(1), match.group(2));
    if (point == null) {
      return null;
    }
    return ExternalMapPlacePoint(point: point, label: _sanitizeLabel(match.group(3)));
  }

  /// Parses a zoom level and clamps it into [minZoom]..[maxZoom]. Unparsable
  /// values yield `null` so the caller can apply its own default.
  static double? parseZoom(String? raw) {
    final value = double.tryParse(raw?.trim() ?? '');
    if (value == null || !value.isFinite) {
      return null;
    }
    return value.clamp(minZoom, maxZoom).toDouble();
  }

  static ExternalMapPoint? _point(String? rawLatitude, String? rawLongitude) {
    final latitude = double.tryParse(rawLatitude ?? '');
    final longitude = double.tryParse(rawLongitude ?? '');
    if (latitude == null || longitude == null) {
      return null;
    }
    if (!latitude.isFinite || !longitude.isFinite) {
      return null;
    }
    if (latitude.abs() > 90 || longitude.abs() > 180) {
      return null;
    }
    return ExternalMapPoint(latitude: latitude, longitude: longitude);
  }

  static String? _sanitizeLabel(String? raw) {
    final label = raw?.trim();
    if (label == null || label.isEmpty) {
      return null;
    }
    return label.length > maxLabelLength ? label.substring(0, maxLabelLength) : label;
  }

  static String? _nonEmpty(String? raw) {
    final value = raw?.trim();
    return value == null || value.isEmpty ? null : value;
  }

  /// Query parameters with lower-cased keys, decoded exactly once as UTF-8.
  /// The first spelling of a key wins, so `?Q=a&q=b` keeps `a`.
  static Map<String, String> _queryParameters(Uri uri) {
    final params = <String, String>{};
    uri.queryParameters.forEach((key, value) => params.putIfAbsent(key.trim().toLowerCase(), () => value));
    return params;
  }
}
