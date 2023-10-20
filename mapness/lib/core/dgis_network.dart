import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dgis_network.g.dart';

@riverpod
class DGisNetwork extends _$DGisNetwork {
  @override
  Dio build() {
    return Dio(BaseOptions(
      responseType: ResponseType.bytes,
      baseUrl: 'https://staging.baladi.steelhoss.xyz/api/1.0/',
      headers: {
        'Content-Type': 'application/protobuf',
        'Accept': 'application/protobuf',
        'X-Device-ID': '60b5ec03-1038-4a0a-b54f-d8f14108a050',
      },
    ))
      ..interceptors.add(
        PrettyDioLogger(
          /// Since protobufs are just binary files what a purpose to print it
          responseBody: false,
        ),
      );
  }
}
