import 'package:flutter/widgets.dart';
import 'package:mapness/entities/makkah_places/makkah_place_model.dart';

/// Helper class for handling multilingual text in Makkah places feature.
///
/// Provides consistent fallback logic: try requested language first,
/// then fallback to the other language, then to empty string or default value.
class MakkahMultilingualHelper {
  MakkahMultilingualHelper._();

  /// Returns the appropriate title based on current text direction.
  ///
  /// Falls back from requested language to other language, never returns null.
  /// Example: For RTL (Arabic), tries titleAr → titleEn → empty string
  static String getTitle(
    MakkahPlace place,
    TextDirection direction, {
    String defaultValue = '',
  }) {
    final isRtl = direction == TextDirection.rtl;
    final primary = isRtl ? place.titleAr : place.titleEn;
    final fallback = isRtl ? place.titleEn : place.titleAr;

    return primary ?? fallback ?? defaultValue;
  }

  /// Returns the appropriate description based on current text direction.
  ///
  /// Falls back from requested language to other language, never returns null.
  static String getDescription(
    MakkahPlace place,
    TextDirection direction, {
    String defaultValue = '',
  }) {
    final isRtl = direction == TextDirection.rtl;
    final primary = isRtl ? place.descriptionAr : place.descriptionEn;
    final fallback = isRtl ? place.descriptionEn : place.descriptionAr;

    return primary ?? fallback ?? defaultValue;
  }

  /// Returns the appropriate workhours text based on current text direction.
  static String? getWorkhours(
    MakkahPlace place,
    TextDirection direction,
  ) {
    final isRtl = direction == TextDirection.rtl;
    final primary = isRtl ? place.workhoursAr : place.workhoursEn;
    final fallback = isRtl ? place.workhoursEn : place.workhoursAr;

    return primary ?? fallback;
  }

  /// Returns the appropriate general tag based on current text direction.
  static String? getGeneralTag(
    MakkahPlace place,
    TextDirection direction,
  ) {
    final isRtl = direction == TextDirection.rtl;
    final primary = isRtl ? place.generalTagAr : place.generalTagEn;
    final fallback = isRtl ? place.generalTagEn : place.generalTagAr;

    return primary ?? fallback;
  }

  /// Returns the appropriate address based on current text direction.
  static String? getAddress(
    MakkahPlace place,
    TextDirection direction,
  ) {
    final isRtl = direction == TextDirection.rtl;
    final primary = isRtl ? place.addressAr : place.addressEn;
    final fallback = isRtl ? place.addressEn : place.addressAr;

    return primary ?? fallback;
  }

  /// Returns the appropriate features text based on current text direction.
  static String? getFeatures(
    MakkahPlace place,
    TextDirection direction,
  ) {
    final isRtl = direction == TextDirection.rtl;
    final primary = isRtl ? place.featuresAr : place.featuresEn;
    final fallback = isRtl ? place.featuresEn : place.featuresAr;

    return primary ?? fallback;
  }

  /// Returns the appropriate accessibility text based on current text direction.
  static String? getAccessibility(
    MakkahPlace place,
    TextDirection direction,
  ) {
    final isRtl = direction == TextDirection.rtl;
    final primary = isRtl ? place.accessibilityAr : place.accessibilityEn;
    final fallback = isRtl ? place.accessibilityEn : place.accessibilityAr;

    return primary ?? fallback;
  }

  /// Returns the appropriate feature text based on current text direction.
  static String getFeatureText(
    MakkahPlaceFeature feature,
    TextDirection direction, {
    String defaultValue = '',
  }) {
    final isRtl = direction == TextDirection.rtl;
    final primary = isRtl ? feature.textAr : feature.textEn;
    final fallback = isRtl ? feature.textEn : feature.textAr;

    return primary ?? fallback ?? defaultValue;
  }

  /// Returns the appropriate feature short tag based on current text direction.
  static String? getFeatureShortTag(
    MakkahPlaceFeature feature,
    TextDirection direction,
  ) {
    final isRtl = direction == TextDirection.rtl;
    final primary = isRtl ? feature.shortTagAr : feature.shortTagEn;
    final fallback = isRtl ? feature.shortTagEn : feature.shortTagAr;

    return primary ?? fallback;
  }

  /// Returns list of tags in appropriate language based on text direction.
  static List<String> getTags(
    MakkahPlace place,
    TextDirection direction,
  ) {
    final isRtl = direction == TextDirection.rtl;
    final primary = isRtl ? place.tagsAr : place.tagsEn;
    final fallback = isRtl ? place.tagsEn : place.tagsAr;

    return primary?.where((tag) => tag.trim().isNotEmpty).toList() ??
        fallback?.where((tag) => tag.trim().isNotEmpty).toList() ??
        const [];
  }
}
