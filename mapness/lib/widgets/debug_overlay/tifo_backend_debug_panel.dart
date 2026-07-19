import 'dart:async';
import 'dart:convert';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

/// Debug console for the TIFO staging backend: preset requests for the main
/// read endpoints plus a free-form method/path/body row, with the raw response
/// (status, latency, body) rendered inline. Auth follows the backend
/// prototype's convention — the user id itself is the bearer token.
class TifoBackendDebugPanel extends StatefulWidget {
  const TifoBackendDebugPanel({super.key});

  @override
  State<TifoBackendDebugPanel> createState() => _TifoBackendDebugPanelState();
}

class _TifoBackendDebugPanelState extends State<TifoBackendDebugPanel> {
  static const String _defaultBaseUrl = 'https://urbi-lifestyle-stg.momah.gov.sa/1.0/api/v1/tifo';

  // Central Riyadh; matches the demo web app's viewport query shape
  // (minLng,minLat,maxLng,maxLat).
  static const String _defaultBbox = '46.65,24.66,46.72,24.73';

  final TextEditingController _baseUrlController = TextEditingController(text: _defaultBaseUrl);
  final TextEditingController _userIdController = TextEditingController(text: 'debug-tester');
  final TextEditingController _pathController = TextEditingController(text: '/districts/summary');
  final TextEditingController _bodyController = TextEditingController();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      // Error bodies (401/422/...) are the whole point of a debug console —
      // surface them instead of throwing.
      validateStatus: (_) => true,
    ),
  );

  String _method = 'GET';
  bool _isBusy = false;
  String? _lastRequestLabel;
  int? _lastStatusCode;
  int? _lastLatencyMs;
  String? _lastResponseBody;

  @override
  void dispose() {
    _baseUrlController.dispose();
    _userIdController.dispose();
    _pathController.dispose();
    _bodyController.dispose();
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DebugCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DebugSectionHeader(
          icon: Icons.cloud_sync_rounded,
          title: 'TIFO Backend',
          subtitle: 'Staging API console',
          gradient: DebugTheme.gradientTeal,
          trailing: _lastStatusCode == null
              ? null
              : DebugBadge(
                  label: 'HTTP $_lastStatusCode',
                  color: _lastStatusCode! < 400 ? DebugTheme.success : DebugTheme.error,
                ),
        ),
        const SizedBox(height: 12),
        Text(
          'Base URL',
          style: context.textStyles.bodySmallMedium.copyWith(color: DebugTheme.textSecondary),
        ),
        const SizedBox(height: 4),
        DebugTextField(controller: _baseUrlController, hint: _defaultBaseUrl),
        const SizedBox(height: 8),
        Text(
          'User ID (sent as Bearer token)',
          style: context.textStyles.bodySmallMedium.copyWith(color: DebugTheme.textSecondary),
        ),
        const SizedBox(height: 4),
        DebugTextField(controller: _userIdController, hint: 'debug-tester'),
        const SizedBox(height: 12),
        Text(
          'Presets',
          style: context.textStyles.bodySmallMedium.copyWith(color: DebugTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _presetButton(label: 'config', path: '/config'),
            _presetButton(label: 'me', path: '/me'),
            _presetButton(label: 'districts', path: '/districts/summary'),
            _presetButton(label: 'buildings', path: '/buildings?bbox=$_defaultBbox'),
            _presetButton(label: 'season', path: '/season'),
            _presetButton(label: 'leaderboards', path: '/leaderboards?scope=both'),
            _presetButton(label: 'daily tokens', path: '/tokens/daily', method: 'POST'),
          ],
        ),
        const DebugDivider(),
        Text(
          'Custom request',
          style: context.textStyles.bodySmallMedium.copyWith(color: DebugTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final method in const ['GET', 'POST'])
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _method == method
                    ? DebugButton(
                        label: method,
                        icon: Icons.check_rounded,
                        gradient: DebugTheme.gradientTeal,
                        isCompact: true,
                        onPressed: () {},
                      )
                    : DebugOutlinedButton(
                        label: method,
                        icon: Icons.circle_outlined,
                        color: DebugTheme.info,
                        isCompact: true,
                        onPressed: () => setState(() => _method = method),
                      ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        DebugTextField(controller: _pathController, hint: '/districts/summary'),
        if (_method == 'POST') ...[
          const SizedBox(height: 8),
          DebugTextField(controller: _bodyController, hint: '{"club": "..."} — optional JSON body'),
        ],
        const SizedBox(height: 8),
        DebugButton(
          label: _isBusy ? 'Sending...' : 'Send',
          icon: Icons.send_rounded,
          gradient: DebugTheme.gradientTeal,
          isCompact: true,
          onPressed: _isBusy
              ? () {}
              : () => unawaited(
                  _send(
                    label: '$_method ${_pathController.text.trim()}',
                    method: _method,
                    path: _pathController.text.trim(),
                    body: _bodyController.text.trim(),
                  ),
                ),
        ),
        if (_lastResponseBody != null) ...[
          const DebugDivider(),
          Row(
            children: [
              Expanded(
                child: Text(
                  '$_lastRequestLabel — HTTP $_lastStatusCode, $_lastLatencyMs ms',
                  style: context.textStyles.captionSmallRegular.copyWith(
                    color: (_lastStatusCode ?? 500) < 400 ? DebugTheme.success : DebugTheme.error,
                  ),
                ),
              ),
              DebugOutlinedButton(
                label: 'Copy',
                icon: Icons.copy_rounded,
                color: DebugTheme.info,
                isCompact: true,
                onPressed: () => unawaited(Clipboard.setData(ClipboardData(text: _lastResponseBody!))),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 260),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: DebugTheme.surfaceLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: DebugTheme.border),
            ),
            child: SingleChildScrollView(
              child: SelectableText(
                _preview(_lastResponseBody!),
                style: context.textStyles.captionSmallRegular.copyWith(
                  color: DebugTheme.textPrimary,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ],
    ),
  );

  Widget _presetButton({required String label, required String path, String method = 'GET'}) => DebugOutlinedButton(
    label: label,
    icon: method == 'GET' ? Icons.download_rounded : Icons.upload_rounded,
    color: DebugTheme.info,
    isCompact: true,
    onPressed: _isBusy ? () {} : () => unawaited(_send(label: '$method $path', method: method, path: path)),
  );

  Future<void> _send({
    required String label,
    required String method,
    required String path,
    String body = '',
  }) async {
    final baseUrl = _baseUrlController.text.trim();
    final userId = _userIdController.text.trim();
    if (baseUrl.isEmpty || path.isEmpty) {
      return;
    }
    setState(() {
      _isBusy = true;
      _lastRequestLabel = label;
      _lastStatusCode = null;
      _lastLatencyMs = null;
      _lastResponseBody = null;
    });

    // Mirrors the backend demo's apiFetch: every request carries a locale.
    final separator = path.contains('?') ? '&' : '?';
    final url = '$baseUrl$path${separator}locale=en';
    final stopwatch = Stopwatch()..start();
    String responseText;
    int? statusCode;
    try {
      final response = await _dio.request<dynamic>(
        url,
        options: Options(
          method: method,
          headers: {
            'Content-Type': 'application/json',
            if (userId.isNotEmpty) 'Authorization': 'Bearer $userId',
          },
        ),
        data: body.isEmpty ? null : body,
      );
      statusCode = response.statusCode;
      responseText = _prettyJson(response.data);
    } catch (e) {
      responseText = 'Request failed: $e';
    } finally {
      stopwatch.stop();
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _isBusy = false;
      _lastStatusCode = statusCode;
      _lastLatencyMs = stopwatch.elapsedMilliseconds;
      _lastResponseBody = responseText;
    });
  }

  String _prettyJson(Object? data) {
    try {
      final decoded = data is String ? jsonDecode(data) : data;
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return data.toString();
    }
  }

  /// The full body stays available via Copy; the inline view is capped so a
  /// large viewport query can't turn the sheet into a mile-long scroll.
  String _preview(String body) {
    const cap = 6000;
    if (body.length <= cap) {
      return body;
    }
    return '${body.substring(0, cap)}\n… truncated, ${body.length} chars total — use Copy for the full body';
  }
}
