import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:mapness/entities/feedback/dto/feedback_category_dto.dart';
import 'package:mapness/entities/feedback/feedback_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feedback_categories.g.dart';

@riverpod
class FeedbackCategories extends _$FeedbackCategories {
  @override
  Future<List<FeedbackCategoryEntity>> build() async {
    final data = await _loadMock();
    final scheme = FeedbackCategoryDto.parseList(data);
    return scheme.map((e) => e.toDomain()).toList();
  }

  Future<List<dynamic>> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final input = await rootBundle.loadString('assets/feedback_scheme_mock.json');
      return jsonDecode(input) as List<dynamic>;
    } catch (e) {
      log(e.toString());
    }
    return [];
  }
}
