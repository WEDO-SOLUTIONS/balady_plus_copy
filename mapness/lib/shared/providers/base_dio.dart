import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'base_dio.g.dart';

@riverpod
class BaseDio extends _$BaseDio {
  @override
  Dio build() => Dio();
}
