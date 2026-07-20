import 'package:flutter/foundation.dart';

/// The four playable TIFO clubs. Slugs and colors mirror the backend/demo
/// (`CLUB_COLORS` in the staging web app); ARGB values are what we paint the
/// captured building polygons with on the map.
enum TifoClub {
  alHilal(slug: 'al-hilal', label: 'Al Hilal', fillArgb: 0xB31E5FA8, strokeArgb: 0xFF1E5FA8),
  alNassr(slug: 'al-nassr', label: 'Al Nassr', fillArgb: 0xB3D9A400, strokeArgb: 0xFFD9A400),
  alRiyadh(slug: 'al-riyadh', label: 'Al Riyadh', fillArgb: 0xB30E8F6E, strokeArgb: 0xFF0E8F6E),
  alShabab(slug: 'al-shabab', label: 'Al Shabab', fillArgb: 0xB34A5568, strokeArgb: 0xFF4A5568);

  const TifoClub({
    required this.slug,
    required this.label,
    required this.fillArgb,
    required this.strokeArgb,
  });

  final String slug;
  final String label;
  final int fillArgb;
  final int strokeArgb;

  static TifoClub? fromSlug(String? slug) {
    if (slug == null) {
      return null;
    }
    for (final club in values) {
      if (club.slug == slug) {
        return club;
      }
    }
    return null;
  }
}

/// Neutral (unclaimed) building — green, matching the demo's default fill.
const int kTifoNeutralFillArgb = 0x7322C55E;
const int kTifoNeutralStrokeArgb = 0xE622C55E;

/// One entry of the data-driven season roster (`GET /clubs`). The BRD makes
/// the roster per-season data, so screens must render from this list rather
/// than a hardcoded enum; [TifoClub] stays only as a color fallback.
@immutable
class TifoClubInfo {
  const TifoClubInfo({
    required this.id,
    required this.name,
    required this.short,
    required this.colorArgb,
  });

  /// Slug used across the API (`al-hilal`, …).
  final String id;
  final String name;
  final String short;
  final int colorArgb;

  int get fillArgb => (colorArgb & 0x00FFFFFF) | 0xB3000000;

  static TifoClubInfo? fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString();
    if (id == null || id.isEmpty) {
      return null;
    }
    return TifoClubInfo(
      id: id,
      name: json['name']?.toString() ?? id,
      short: json['short']?.toString() ?? '',
      colorArgb: _parseHexColor(json['color']?.toString()) ?? kTifoNeutralStrokeArgb,
    );
  }

  static int? _parseHexColor(String? hex) {
    if (hex == null) {
      return null;
    }
    final cleaned = hex.replaceFirst('#', '');
    final value = int.tryParse(cleaned, radix: 16);
    if (value == null) {
      return null;
    }
    return cleaned.length == 6 ? (0xFF000000 | value) : value;
  }
}

/// Player profile from `GET /me`. On staging the profile is created lazily on
/// first authenticated call, so this also doubles as "registration".
@immutable
class TifoProfile {
  const TifoProfile({
    required this.userId,
    required this.clubId,
    required this.balance,
    required this.onboardingCompleted,
    required this.tutorialCompleted,
    required this.freeClaimsRemaining,
    required this.buildingsOwned,
    required this.dailyAllowanceGranted,
  });

  final String userId;
  final String? clubId;
  final int balance;
  final bool onboardingCompleted;
  final bool tutorialCompleted;
  final int freeClaimsRemaining;
  final int buildingsOwned;
  final bool dailyAllowanceGranted;

  bool get hasClub => clubId != null && clubId!.isNotEmpty;

  factory TifoProfile.fromJson(Map<String, dynamic> json) => TifoProfile(
    userId: json['userId']?.toString() ?? '',
    clubId: json['club']?.toString(),
    balance: (json['balance'] as num?)?.toInt() ?? 0,
    onboardingCompleted: json['onboardingCompleted'] == true,
    tutorialCompleted: json['tutorialCompleted'] == true,
    freeClaimsRemaining: (json['freeClaimsRemaining'] as num?)?.toInt() ?? 0,
    buildingsOwned: (json['buildingsOwned'] as num?)?.toInt() ?? 0,
    dailyAllowanceGranted: json['dailyAllowanceGranted'] == true,
  );
}

/// Game economy/tuning from `GET /config` — only the fields the client needs.
@immutable
class TifoGameConfig {
  const TifoGameConfig({
    required this.claimCost,
    required this.challengeCost,
    required this.missesAllowed,
  });

  static const TifoGameConfig fallback = TifoGameConfig(claimCost: 2, challengeCost: 1, missesAllowed: 3);

  final int claimCost;
  final int challengeCost;
  final int missesAllowed;

  factory TifoGameConfig.fromJson(Map<String, dynamic> json) => TifoGameConfig(
    claimCost: (json['claimCost'] as num?)?.toInt() ?? fallback.claimCost,
    challengeCost: (json['challengeCost'] as num?)?.toInt() ?? fallback.challengeCost,
    missesAllowed: (json['missesAllowed'] as num?)?.toInt() ?? fallback.missesAllowed,
  );
}

/// One kick of a shootout session, reported back on submit. The backend
/// recomputes the score from these events (anti-cheat) — submitting a score
/// without them risks a `voided` outcome.
@immutable
class TifoKickEvent {
  const TifoKickEvent({required this.index, required this.scored, required this.atMs});

  final int index;
  final bool scored;

  /// Milliseconds since the session started.
  final int atMs;

  Map<String, Object?> toJson() => {
    'index': index,
    'outcome': scored ? 'goal' : 'miss',
    'atMs': atMs,
  };
}

/// Result of a finished penalty shootout, handed back by the game to the
/// caller so it can submit to `/buildings/{id}/play` with the full event log.
@immutable
class TifoShootoutOutcome {
  const TifoShootoutOutcome({required this.goals, required this.misses, required this.events});

  final int goals;
  final int misses;
  final List<TifoKickEvent> events;
}

/// A single ring of a polygon: an ordered list of (lat, lng) points.
typedef TifoRing = List<TifoLatLng>;

@immutable
class TifoLatLng {
  const TifoLatLng(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

/// A capturable building returned by `GET /buildings?bbox=…`.
///
/// [rings] is already flattened from the API's GeoJSON `geometry`: one entry
/// per outer ring (a MultiPolygon yields several). Holes are dropped — the
/// game only needs the footprint outline.
@immutable
class TifoBuilding {
  const TifoBuilding({
    required this.id,
    required this.rings,
    this.name,
    this.ownerClubSlug,
    this.savedScore = 0,
    this.scoreToBeat = 0,
    this.status = 'available',
    this.contested7d = 0,
  });

  final String id;
  final List<TifoRing> rings;
  final String? name;
  final String? ownerClubSlug;
  final int savedScore;

  /// Score a challenger must strictly beat (0 for unclaimed buildings).
  final int scoreToBeat;

  /// `available` | `cooldown` | `live` — only `available` buildings can be
  /// challenged (BRD: the Challenge CTA is disabled otherwise).
  final String status;

  /// Times this building was contested in the last 7 days (informational).
  final int contested7d;

  bool get isAvailable => status == 'available';

  TifoClub? get ownerClub => TifoClub.fromSlug(ownerClubSlug);

  bool get isNeutral => ownerClub == null;

  String get displayName {
    final n = name;
    if (n != null && n.trim().isNotEmpty) {
      return n;
    }
    final tail = id.length <= 6 ? id : id.substring(id.length - 6);
    return 'Building #$tail';
  }

  TifoBuilding copyWith({String? ownerClubSlug, int? savedScore, int? scoreToBeat, String? status}) => TifoBuilding(
    id: id,
    rings: rings,
    name: name,
    ownerClubSlug: ownerClubSlug ?? this.ownerClubSlug,
    savedScore: savedScore ?? this.savedScore,
    scoreToBeat: scoreToBeat ?? this.scoreToBeat,
    status: status ?? this.status,
    contested7d: contested7d,
  );

  /// Parses one item from the `items` array. Returns null when the geometry is
  /// missing or unusable, so a single malformed building can't break the batch.
  static TifoBuilding? fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString();
    if (id == null) {
      return null;
    }
    final rings = _parseGeometry(json['geometry']);
    if (rings.isEmpty) {
      return null;
    }
    return TifoBuilding(
      id: id,
      rings: rings,
      name: json['name'] as String?,
      ownerClubSlug: json['ownerClub'] as String?,
      savedScore: (json['savedScore'] as num?)?.toInt() ?? 0,
      scoreToBeat: (json['scoreToBeat'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? 'available',
      contested7d: (json['contested7d'] as num?)?.toInt() ?? 0,
    );
  }

  /// GeoJSON → list of outer rings. Coordinates are `[lng, lat]` (GeoJSON
  /// order). Supports `Polygon` (`coordinates: [ring, hole…]`) and
  /// `MultiPolygon` (`coordinates: [[ring, hole…], …]`); only outer rings kept.
  static List<TifoRing> _parseGeometry(Object? geometry) {
    if (geometry is! Map) {
      return const [];
    }
    final type = geometry['type'];
    final coords = geometry['coordinates'];
    if (coords is! List) {
      return const [];
    }
    final result = <TifoRing>[];
    try {
      if (type == 'Polygon') {
        final ring = _parseRing(coords.isNotEmpty ? coords.first : null);
        if (ring != null) {
          result.add(ring);
        }
      } else if (type == 'MultiPolygon') {
        for (final poly in coords) {
          if (poly is List && poly.isNotEmpty) {
            final ring = _parseRing(poly.first);
            if (ring != null) {
              result.add(ring);
            }
          }
        }
      }
    } catch (_) {
      return const [];
    }
    return result;
  }

  static TifoRing? _parseRing(Object? raw) {
    if (raw is! List || raw.length < 3) {
      return null;
    }
    final ring = <TifoLatLng>[];
    for (final p in raw) {
      if (p is List && p.length >= 2) {
        final lng = (p[0] as num).toDouble();
        final lat = (p[1] as num).toDouble();
        ring.add(TifoLatLng(lat, lng));
      }
    }
    return ring.length >= 3 ? ring : null;
  }
}

/// Response of `POST /buildings/{id}/play/start`.
@immutable
class TifoPlaySession {
  const TifoPlaySession({required this.sessionId, this.expiresAt, this.balance});

  final String sessionId;
  final DateTime? expiresAt;
  final int? balance;

  factory TifoPlaySession.fromJson(Map<String, dynamic> json) => TifoPlaySession(
    sessionId: json['sessionId'].toString(),
    expiresAt: DateTime.tryParse(json['expiresAt']?.toString() ?? ''),
    balance: (json['balance'] as num?)?.toInt(),
  );
}

/// Outcome of `POST /buildings/{id}/play`.
enum TifoOutcome { claimed, taken, failed, voided, unknown }

@immutable
class TifoPlayResult {
  const TifoPlayResult({
    required this.outcome,
    required this.yourScore,
    this.balance,
  });

  final TifoOutcome outcome;
  final int yourScore;
  final int? balance;

  bool get isWin => outcome == TifoOutcome.claimed || outcome == TifoOutcome.taken;

  factory TifoPlayResult.fromJson(Map<String, dynamic> json) => TifoPlayResult(
    outcome: switch (json['outcome']?.toString()) {
      'claimed' => TifoOutcome.claimed,
      'taken' => TifoOutcome.taken,
      'failed' => TifoOutcome.failed,
      'voided' => TifoOutcome.voided,
      _ => TifoOutcome.unknown,
    },
    yourScore: (json['yourScore'] as num?)?.toInt() ?? 0,
    balance: (json['balance'] as num?)?.toInt(),
  );
}
