enum AppIconQuickActionStatus {
  active,
  inactive;

  static AppIconQuickActionStatus fromJson(dynamic value) {
    final normalized = value?.toString().toLowerCase();
    return switch (normalized) {
      'active' => AppIconQuickActionStatus.active,
      _ => AppIconQuickActionStatus.inactive,
    };
  }

  bool get isActive => this == AppIconQuickActionStatus.active;
}

enum AppIconQuickActionPlatform {
  android,
  ios,
  huawei;

  static AppIconQuickActionPlatform? fromJson(dynamic value) => switch (value?.toString().toLowerCase()) {
    'android' => AppIconQuickActionPlatform.android,
    'ios' => AppIconQuickActionPlatform.ios,
    'huawei' => AppIconQuickActionPlatform.huawei,
    _ => null,
  };
}

enum AppIconQuickActionPermission {
  location,
  camera;

  static AppIconQuickActionPermission? fromJson(dynamic value) => switch (value?.toString().toLowerCase()) {
    'location' => AppIconQuickActionPermission.location,
    'camera' => AppIconQuickActionPermission.camera,
    _ => null,
  };
}

class AppIconQuickActionsConfig {
  const AppIconQuickActionsConfig({
    required this.version,
    required this.shortcuts,
  });

  final int version;
  final List<AppIconQuickActionItem> shortcuts;

  factory AppIconQuickActionsConfig.fromJson(Map<String, dynamic> json) {
    final rawShortcuts = json['shortcuts'];
    return AppIconQuickActionsConfig(
      version: (json['version'] as num?)?.toInt() ?? 1,
      shortcuts: rawShortcuts is List
          ? rawShortcuts
                .whereType<Map<String, dynamic>>()
                .map(AppIconQuickActionItem.fromJson)
                .where((item) => item.key.isNotEmpty && item.destination.isNotEmpty)
                .toList()
          : const [],
    );
  }

  static const AppIconQuickActionsConfig empty = AppIconQuickActionsConfig(version: 0, shortcuts: []);
}

class AppIconQuickActionItem {
  const AppIconQuickActionItem({
    required this.key,
    required this.labelEn,
    required this.labelAr,
    required this.destination,
    required this.status,
    required this.order,
    required this.platforms,
    required this.requireLogin,
    required this.requirePermissions,
    required this.iconReference,
  });

  final String key;
  final String labelEn;
  final String labelAr;
  final String destination;
  final AppIconQuickActionStatus status;
  final int order;
  final List<AppIconQuickActionPlatform> platforms;
  final bool requireLogin;
  final List<AppIconQuickActionPermission> requirePermissions;
  final String iconReference;

  factory AppIconQuickActionItem.fromJson(Map<String, dynamic> json) => AppIconQuickActionItem(
    key: _readString(json, ['key', 'shortcutKey']),
    labelEn: _readString(json, ['labelEn', 'shortcutNameEn', 'englishLabel']),
    labelAr: _readString(json, ['labelAr', 'shortcutNameAr', 'arabicLabel']),
    destination: _readString(json, ['destination', 'shortcutDestination']),
    status: AppIconQuickActionStatus.fromJson(json['status']),
    order: (json['order'] as num?)?.toInt() ?? 0,
    platforms: _readPlatforms(json['platforms']),
    requireLogin: _readBool(json['requireLogin']),
    requirePermissions: _readPermissions(json['requirePermissions']),
    iconReference: _readString(json, ['iconReference', 'icon']),
  );

  bool supportsPlatform(AppIconQuickActionPlatform platform) => platforms.contains(platform);

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }
    return '';
  }

  static bool _readBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    final normalized = value?.toString().toLowerCase();
    return normalized == 'yes' || normalized == 'true' || normalized == '1';
  }

  static List<AppIconQuickActionPlatform> _readPlatforms(dynamic raw) {
    if (raw is! List) {
      return AppIconQuickActionPlatform.values;
    }
    final parsed = raw.map(AppIconQuickActionPlatform.fromJson).whereType<AppIconQuickActionPlatform>().toList();
    return parsed.isEmpty ? AppIconQuickActionPlatform.values : parsed;
  }

  static List<AppIconQuickActionPermission> _readPermissions(dynamic raw) {
    if (raw == null) {
      return const [];
    }
    if (raw is List) {
      return raw.map(AppIconQuickActionPermission.fromJson).whereType<AppIconQuickActionPermission>().toList();
    }
    final single = AppIconQuickActionPermission.fromJson(raw);
    if (single != null) {
      return [single];
    }
    final normalized = raw.toString().toLowerCase();
    if (normalized == 'no' || normalized.isEmpty) {
      return const [];
    }
    return const [];
  }
}
