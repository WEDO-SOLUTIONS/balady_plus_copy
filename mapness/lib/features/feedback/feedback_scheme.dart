import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:mapness/entities/feedback/feedback_scheme_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feedback_scheme.g.dart';

@riverpod
class FeedbackScheme extends _$FeedbackScheme {
  @override
  Future<FeedbackListData> build() async {
    state = const AsyncValue.loading();
    final data = await getSchemes();
    final scheme = FeedbackListData.fromJson(data);
    state = AsyncValue.data(scheme);
    return scheme;
  }

  Future<Map<String, dynamic>> getSchemes() async {
    try {
      final input = await rootBundle.loadString('assets/feedback_scheme_mock.json');
      return jsonDecode(input) as Map<String, dynamic>;
    } catch (e) {
      log(e.toString());
    }
    return {};
  }
}
