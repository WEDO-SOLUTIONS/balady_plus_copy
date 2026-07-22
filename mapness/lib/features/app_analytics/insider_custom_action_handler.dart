import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Centralized handler for Insider SDK custom action callbacks (`TEMP_STORE_CUSTOM_ACTION`).
///
/// Designed to parse incoming in-app message custom action payloads and route them
/// to appropriate application actions (`open_screen`, `navigate`, `open_url`, `show_dialog`).
class InsiderCustomActionHandler {
  InsiderCustomActionHandler._();

  /// Primary entry point to process a `TEMP_STORE_CUSTOM_ACTION` callback payload.
  static void handleCustomAction(Object? rawData) {
    debugPrint('[INSIDER][CustomAction] Raw payload received: $rawData');

    if (rawData == null) {
      debugPrint('[INSIDER][CustomAction] Payload is null. Aborting.');
      return;
    }

    Map<String, dynamic> payload = {};

    try {
      if (rawData is Map) {
        payload = Map<String, dynamic>.from(rawData);
      } else if (rawData is String) {
        final decoded = json.decode(rawData);
        if (decoded is Map) {
          payload = Map<String, dynamic>.from(decoded);
        }
      }
    } catch (e, stackTrace) {
      debugPrint('[INSIDER][CustomAction] Error parsing payload: $e\n$stackTrace');
      return;
    }

    if (payload.isEmpty) {
      debugPrint('[INSIDER][CustomAction] Resolved payload is empty. Nothing to handle.');
      return;
    }

    final actionType = payload['action']?.toString() ?? payload['type']?.toString();

    debugPrint('[INSIDER][CustomAction] Action type: $actionType, payload: $payload');

    switch (actionType?.toLowerCase()) {
      case 'open_screen':
        _handleOpenScreen(payload);
        break;
      case 'navigate':
        _handleNavigate(payload);
        break;
      case 'open_url':
        _handleOpenUrl(payload);
        break;
      case 'show_dialog':
        _handleShowDialog(payload);
        break;
      default:
        _handleGenericOrCustomAction(actionType, payload);
        break;
    }
  }

  static void _handleOpenScreen(Map<String, dynamic> payload) {
    final screenName = payload['screen'] ?? payload['target'];
    debugPrint('[INSIDER][CustomAction] open_screen target: $screenName (payload: $payload)');
    // Placeholder for custom screen routing
  }

  static void _handleNavigate(Map<String, dynamic> payload) {
    final route = payload['route'] ?? payload['path'];
    debugPrint('[INSIDER][CustomAction] navigate target: $route (payload: $payload)');
    // Placeholder for route navigation
  }

  static void _handleOpenUrl(Map<String, dynamic> payload) {
    final url = payload['url'] ?? payload['link'];
    debugPrint('[INSIDER][CustomAction] open_url target: $url (payload: $payload)');
    // Placeholder for URL opening
  }

  static void _handleShowDialog(Map<String, dynamic> payload) {
    final title = payload['title'] ?? 'Insider Alert';
    final message = payload['message'] ?? payload['content'];
    debugPrint('[INSIDER][CustomAction] show_dialog: title=$title, message=$message');
    // Placeholder for displaying dialog
  }

  static void _handleGenericOrCustomAction(String? actionType, Map<String, dynamic> payload) {
    debugPrint('[INSIDER][CustomAction] Generic action triggered: $actionType (payload: $payload)');
  }
}
