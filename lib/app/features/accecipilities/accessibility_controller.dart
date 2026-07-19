import 'package:app_settings/app_settings.dart';
import 'package:balady_plus/app/features/accecipilities/life_sycle_event_handler.dart';
import 'package:dgis_map/dgis_map_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityController extends ChangeNotifier {
  // Text & Reading
  double textScale = 1.0;
  double lineHeight = 1.2;
  double letterSpacing = 0.0;
  FontWeight fontWeight = FontWeight.normal;

  // Visual
  bool highContrast = false;
  bool grayscale = false;
  bool reduceAnimations = false;
  bool reduceTransparency = false;

  // Interaction
  bool largeCursor = false;
  double tapTargetSize = 1.0;
  bool screenReaderEnabled = false;

  // Cognitive
  bool simplifyLayout = false;
  bool hideNonEssentialContent = false;
  bool readingMode = false;

  // Audio
  bool monoAudio = false;
  bool captionsEnabled = false;

  // Platform integration
  bool followSystemSettings = true;

  static const Map<FontWeight, String> fontWeightLabels = {
    FontWeight.w100: 'Thin',
    FontWeight.w300: 'Light',
    FontWeight.w400: 'Regular',
    FontWeight.w500: 'Medium',
    FontWeight.w700: 'Bold',
    FontWeight.w900: 'Black',
  };

  AccessibilityController() {
    _loadSettings();
    _setupPlatformListener();
  }

  Future<void> _setupPlatformListener() async {
    // Listen to system accessibility changes
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () => _checkSystemSettings(),
      ),
    );
  }

  Future<void> _checkSystemSettings() async {
    if (followSystemSettings) {
      await _syncWithSystemSettings();
    }
  }

  Future<void> _syncWithSystemSettings() async {
    // This would integrate with platform channels to get system settings
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      textScale = prefs.getDouble('textScale') ?? 1.0;
      lineHeight = prefs.getDouble('lineHeight') ?? 1.2;
      letterSpacing = prefs.getDouble('letterSpacing') ?? 0.0;
      fontWeight = FontWeight.values[prefs.getInt('fontWeight') ?? 4];

      highContrast = prefs.getBool('highContrast') ?? false;
      grayscale = prefs.getBool('grayscale') ?? false;
      reduceAnimations = prefs.getBool('reduceAnimations') ?? false;
      reduceTransparency = prefs.getBool('reduceTransparency') ?? false;

      largeCursor = prefs.getBool('largeCursor') ?? false;
      tapTargetSize = prefs.getDouble('tapTargetSize') ?? 1.0;
      screenReaderEnabled = prefs.getBool('screenReaderEnabled') ?? false;

      simplifyLayout = prefs.getBool('simplifyLayout') ?? false;
      hideNonEssentialContent =
          prefs.getBool('hideNonEssentialContent') ?? false;
      readingMode = prefs.getBool('readingMode') ?? false;

      monoAudio = prefs.getBool('monoAudio') ?? false;
      captionsEnabled = prefs.getBool('captionsEnabled') ?? false;

      followSystemSettings = prefs.getBool('followSystemSettings') ?? true;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading accessibility settings: $e');
      }
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('textScale', textScale);
      await prefs.setDouble('lineHeight', lineHeight);
      await prefs.setDouble('letterSpacing', letterSpacing);
      await prefs.setInt('fontWeight', FontWeight.values.indexOf(fontWeight));

      await prefs.setBool('highContrast', highContrast);
      await prefs.setBool('grayscale', grayscale);
      await prefs.setBool('reduceAnimations', reduceAnimations);
      await prefs.setBool('reduceTransparency', reduceTransparency);

      await prefs.setBool('largeCursor', largeCursor);
      await prefs.setDouble('tapTargetSize', tapTargetSize);
      await prefs.setBool('screenReaderEnabled', screenReaderEnabled);

      await prefs.setBool('simplifyLayout', simplifyLayout);
      await prefs.setBool('hideNonEssentialContent', hideNonEssentialContent);
      await prefs.setBool('readingMode', readingMode);

      await prefs.setBool('monoAudio', monoAudio);
      await prefs.setBool('captionsEnabled', captionsEnabled);

      await prefs.setBool('followSystemSettings', followSystemSettings);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving accessibility settings: $e');
      }
    }
  }

  // Text & Reading methods
  // void setTextScale(double value) {
  //   textScale = value;
  //   _saveSettings();
  //   notifyListeners();
  // }

  void setTextScale(double value,DgisMapController? dgisController) async{
    textScale = value;
    _saveSettings();
    await _syncMapFontScale(value,dgisController);
    notifyListeners();
  }

  Future<void> _syncMapFontScale(double scale,DgisMapController? _dgisController) async {
    if (_dgisController == null) return;

    try {

      await _dgisController.setMapAttributeString(
        'fontScaleMultiplier',
        value: scale.toString(),
      );
    } catch (e) {
      print('Error syncing map font scale: $e');
    }
  }







  void setLineHeight(double value) {
    lineHeight = value;
    _saveSettings();
    notifyListeners();
  }

  void setLetterSpacing(double value) {
    letterSpacing = value;
    _saveSettings();
    notifyListeners();
  }

  void setFontWeight(FontWeight value) {
    fontWeight = value;
    _saveSettings();
    notifyListeners();
  }

  // Visual methods
  void toggleContrast(bool value) {
    highContrast = value;
    _saveSettings();
    notifyListeners();
  }

  void toggleGrayscale(bool value) {
    grayscale = value;
    _saveSettings();
    notifyListeners();
  }

  void toggleAnimations(bool value) {
    reduceAnimations = value;
    _saveSettings();
    notifyListeners();
  }

  void toggleTransparency(bool value) {
    reduceTransparency = value;
    _saveSettings();
    notifyListeners();
  }

  // Interaction methods
  void toggleLargeCursor(bool value) {
    largeCursor = value;
    _saveSettings();
    notifyListeners();
  }

  void setTapTargetSize(double value) {
    tapTargetSize = value;
    _saveSettings();
    notifyListeners();
  }

  Future<void> toggleScreenReader(value) async {
    AppSettings.openAppSettings(type: AppSettingsType.accessibility);
    screenReaderEnabled = value;
    _saveSettings();
    notifyListeners();
    // try {
    //   if (Platform.isIOS) {
    //     // Try direct accessibility settings
    //     const url = 'App-Prefs:root=ACCESSIBILITY';
    //     if (await canLaunchUrl(Uri.parse(url))) {
    //       await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    //     } else {
    //       // Fallback to general settings
    //       const fallbackUrl = 'app-settings:';
    //       if (await canLaunchUrl(Uri.parse(fallbackUrl))) {
    //         await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
    //       }
    //     }
    //   } else if (Platform.isAndroid) {
    //     const url = 'android.settings.ACCESSIBILITY_SETTINGS';
    //     if (await canLaunchUrl(Uri.parse(url))) {
    //       await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    //     } else {
    //       const fallbackUrl = 'android.settings.SETTINGS';
    //       if (await canLaunchUrl(Uri.parse(fallbackUrl))) {
    //         await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
    //       }
    //     }
    //   }
    // } catch (e) {
    //   debugPrint('Failed to open accessibility settings: $e');
    // }
  }


  // Cognitive methods
  void toggleSimplifyLayout(bool value) {
    simplifyLayout = value;
    _saveSettings();
    notifyListeners();
  }

  void toggleNonEssentialContent(bool value) {
    hideNonEssentialContent = value;
    _saveSettings();
    notifyListeners();
  }

  void toggleReadingMode(bool value) {
    readingMode = value;
    _saveSettings();
    notifyListeners();
  }

  // Audio methods
  void toggleMonoAudio(bool value) {
    monoAudio = value;
    _saveSettings();
    notifyListeners();
  }

  void toggleCaptions(bool value) {
    captionsEnabled = value;
    _saveSettings();
    notifyListeners();
  }

  // System integration
  void toggleSystemSettings(bool value) {
    followSystemSettings = value;
    if (value) _syncWithSystemSettings();
    _saveSettings();
    notifyListeners();
  }

  void reset() {
    textScale = 1.0;
    lineHeight = 1.2;
    letterSpacing = 0.0;
    fontWeight = FontWeight.normal;

    highContrast = false;
    grayscale = false;
    reduceAnimations = false;
    reduceTransparency = false;

    largeCursor = false;
    tapTargetSize = 1.0;
    screenReaderEnabled = false;

    simplifyLayout = false;
    hideNonEssentialContent = false;
    readingMode = false;

    monoAudio = false;
    captionsEnabled = false;

    followSystemSettings = true;

    _saveSettings();
    notifyListeners();
  }

  // Helper to get current text style with all modifications
  TextStyle getModifiedTextStyle(TextStyle baseStyle) {
    return baseStyle.copyWith(
      fontSize:
          baseStyle.fontSize != null ? baseStyle.fontSize! * textScale : null,
      height: lineHeight,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
    );
  }

  // Check if any accessibility features are active
  bool get hasActiveAccessibilityFeatures {
    return textScale != 1.0 ||
        lineHeight != 1.2 ||
        letterSpacing != 0.0 ||
        fontWeight != FontWeight.normal ||
        highContrast ||
        grayscale ||
        reduceAnimations ||
        reduceTransparency ||
        largeCursor ||
        tapTargetSize != 1.0 ||
        simplifyLayout ||
        hideNonEssentialContent ||
        readingMode ||
        monoAudio ||
        captionsEnabled;
  }
}
