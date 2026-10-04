import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

String formatPoiRating(double rating, AppLocalizations l10n) => NumberFormat('0.0', l10n.localeName).format(rating);

String formatPoiReviewDate(DateTime date, AppLocalizations l10n, {DateTime? now}) {
  final today = DateUtils.dateOnly(now ?? DateTime.now());
  final daysAgo = today.difference(DateUtils.dateOnly(date)).inDays;
  if (daysAgo == 0) {
    return l10n.today;
  }
  if (daysAgo == 1) {
    return l10n.yesterday;
  }
  return DateFormat('d MMMM y', l10n.localeName).format(date);
}

String poiReviewAuthorInitials(String name) {
  final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) {
    return '';
  }
  // Arabic letters change shape when adjacent, so two-letter initials read as a word; keep one.
  final isArabic = RegExp(r'^[؀-ۿ]').hasMatch(words.first);
  if (isArabic || words.length == 1) {
    return words.first.characters.first;
  }
  return (words.first.characters.first + words[1].characters.first).toUpperCase();
}

// Localazy rejects plural sources with an `=0` form, so zero has its own keys.
String formatPoiRatingsCount(int count, AppLocalizations l10n) =>
    count == 0 ? l10n.poiReviewsNoRatings : l10n.poiReviewsRatingsTotal(count);

String formatPoiReviewsCount(int count, AppLocalizations l10n) =>
    count == 0 ? l10n.poiReviewsNoReviews : l10n.poiReviewsReviewsTotal(count);
