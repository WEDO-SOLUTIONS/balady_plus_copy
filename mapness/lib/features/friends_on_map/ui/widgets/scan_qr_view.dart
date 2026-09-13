import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/friends_on_map/providers/invite_resolution_flow.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// R-31/R-32: only built while the "Scan" tab on `AddFriendPage` is
/// selected — the parent removes this widget from the tree (rather than
/// hiding it) when the tab isn't active, so the camera controller created
/// here in [initState] is torn down in [dispose] instead of staying open in
/// the background.
class ScanQrView extends ConsumerStatefulWidget {
  const ScanQrView({super.key});

  @override
  ConsumerState<ScanQrView> createState() => _ScanQrViewState();
}

class _ScanQrViewState extends ConsumerState<ScanQrView> {
  MobileScannerController? _controller;
  bool? _permissionGranted;
  bool _handlingDetection = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensurePermission());
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _ensurePermission() async {
    // Already handles the "already granted" case silently (no dialog) via
    // Permission.camera.request() returning granted instantly.
    final granted = await CommonFunctions.checkCameraSettings(context);
    if (!mounted) {
      return;
    }
    setState(() {
      _permissionGranted = granted;
      if (granted) {
        _controller = MobileScannerController();
      }
    });
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handlingDetection) {
      return;
    }
    if (capture.barcodes.isEmpty) {
      return;
    }
    final rawValue = capture.barcodes.first.rawValue;
    if (rawValue == null) {
      return;
    }
    _handlingDetection = true;
    await _controller?.stop();
    await resolveInviteAndShowResult(context, ref, rawValue);
    _handlingDetection = false;
    if (mounted) {
      await _controller?.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionGranted == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_permissionGranted == false) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.$4x),
          child: Text(
            context.l10n.scanQrCameraDenied,
            textAlign: TextAlign.center,
            style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundMuted),
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(RadiusBorder.l),
      child: MobileScanner(controller: _controller, onDetect: _onDetect),
    );
  }
}
