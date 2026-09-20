import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilitySettings {
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

  AccessibilitySettings({
    this.textScale = 1.0,
    this.lineHeight = 1.2,
    this.letterSpacing = 0.0,
    this.fontWeight = FontWeight.normal,
    this.highContrast = false,
    this.grayscale = false,
    this.reduceAnimations = false,
    this.reduceTransparency = false,
    this.largeCursor = false,
    this.tapTargetSize = 1.0,
    this.screenReaderEnabled = false,
    this.simplifyLayout = false,
    this.hideNonEssentialContent = false,
    this.readingMode = false,
    this.monoAudio = false,
    this.captionsEnabled = false,
    this.followSystemSettings = true,
  });

  static Future<AccessibilitySettings> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return AccessibilitySettings(
        textScale: prefs.getDouble('textScale') ?? 1.0,
        lineHeight: prefs.getDouble('lineHeight') ?? 1.2,
        letterSpacing: prefs.getDouble('letterSpacing') ?? 0.0,
        fontWeight: FontWeight.values[prefs.getInt('fontWeightIndex') ?? 3], // Default w400
        highContrast: prefs.getBool('highContrast') ?? false,
        grayscale: prefs.getBool('grayscale') ?? false,
        reduceAnimations: prefs.getBool('reduceAnimations') ?? false,
        reduceTransparency: prefs.getBool('reduceTransparency') ?? false,
        largeCursor: prefs.getBool('largeCursor') ?? false,
        tapTargetSize: prefs.getDouble('tapTargetSize') ?? 1.0,
        screenReaderEnabled: prefs.getBool('screenReaderEnabled') ?? false,
        simplifyLayout: prefs.getBool('simplifyLayout') ?? false,
        hideNonEssentialContent: prefs.getBool('hideNonEssentialContent') ?? false,
        readingMode: prefs.getBool('readingMode') ?? false,
        monoAudio: prefs.getBool('monoAudio') ?? false,
        captionsEnabled: prefs.getBool('captionsEnabled') ?? false,
        followSystemSettings: prefs.getBool('followSystemSettings') ?? true,
      );
    } catch (e) {
      return AccessibilitySettings(); // Return defaults on error
    }
  }

  /// Converts the object into a Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'textScale': textScale,
      'lineHeight': lineHeight,
      'letterSpacing': letterSpacing,
      'fontWeightIndex': FontWeight.values.indexOf(fontWeight), // Store index
      'highContrast': highContrast,
      'grayscale': grayscale,
      'reduceAnimations': reduceAnimations,
      'reduceTransparency': reduceTransparency,
      'largeCursor': largeCursor,
      'tapTargetSize': tapTargetSize,
      'screenReaderEnabled': screenReaderEnabled,
      'simplifyLayout': simplifyLayout,
      'hideNonEssentialContent': hideNonEssentialContent,
      'readingMode': readingMode,
      'monoAudio': monoAudio,
      'captionsEnabled': captionsEnabled,
      'followSystemSettings': followSystemSettings,
    };
  }
}
