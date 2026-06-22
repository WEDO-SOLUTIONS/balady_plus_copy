import 'dart:convert';

/// Configuration for the satellite raster tile overlay.
///
/// Sourced from Firebase Remote Config (`satellite_config` key, see
/// [RemoteConfigConstants.satelliteConfig]). Token is rotated independently
/// of [urlTemplate], which keeps the `{z}/{y}/{x}` ESRI placeholders.
class SatelliteConfig {
  const SatelliteConfig({
    required this.layerName,
    required this.urlTemplate,
    required this.token,
    required this.expiresMs,
  });

  /// 2GIS sublayerName used when creating the RasterTileSource.
  final String layerName;

  /// Tile URL template containing `{z}`, `{y}`, `{x}` and `{TOKEN}`
  /// placeholders. The first three are interpreted by 2GIS; `{TOKEN}` is
  /// substituted by [resolvedTileUri] before the value crosses the bridge.
  final String urlTemplate;

  /// Current ESRI auth token. Rotated via Remote Config.
  final String token;

  /// Token expiry as milliseconds since epoch. `0` when not provided in
  /// the config — treat as "unknown / never checked".
  final int expiresMs;

  /// True when [urlTemplate] embeds the `{TOKEN}` placeholder — implies the
  /// configured server requires authentication.
  bool get requiresToken => urlTemplate.contains('{TOKEN}');

  String get resolvedTileUri {
    if (urlTemplate.isEmpty) {
      return '';
    }
    return urlTemplate.replaceAll('{TOKEN}', token);
  }

  /// A template without `{TOKEN}` (public/free tile server) is usable without
  /// a token. When the template embeds `{TOKEN}`, the token must be present.
  bool get isUsable {
    if (urlTemplate.isEmpty) {
      return false;
    }
    if (requiresToken && token.isEmpty) {
      return false;
    }
    return true;
  }

  /// True when [expiresMs] is set and already in the past.
  bool get isExpired => expiresMs > 0 && DateTime.now().millisecondsSinceEpoch >= expiresMs;

  DateTime? get expiresAt => expiresMs > 0 ? DateTime.fromMillisecondsSinceEpoch(expiresMs) : null;

  static SatelliteConfig? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return null;
      }
      return SatelliteConfig(
        layerName: (decoded['layer_name'] as String?) ?? '',
        urlTemplate: (decoded['url_template'] as String?) ?? '',
        token: (decoded['token'] as String?) ?? '',
        expiresMs: _readInt(decoded['expires']),
      );
    } catch (_) {
      return null;
    }
  }
}

int _readInt(Object? raw) {
  if (raw is int) {
    return raw;
  }
  if (raw is num) {
    return raw.toInt();
  }
  if (raw is String) {
    return int.tryParse(raw) ?? 0;
  }
  return 0;
}
