import 'package:dio/dio.dart';
import 'package:mapness/features/common/providers/uuid_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dgis_network.g.dart';

@riverpod
class DGisNetwork extends _$DGisNetwork {
  final bool isProduction = false;
  // final bool isProduction = true;

  @override
  Future<Dio> build() async {
    return Dio(BaseOptions(
      responseType: ResponseType.bytes,
      baseUrl: isProduction
          ? 'https://baladi.steelhoss.xyz/api/1.0/'
          : 'https://staging.baladi.steelhoss.xyz/api/1.0/',
      headers: {
        'Content-Type': 'application/protobuf',
        'Accept': 'application/protobuf',
        'X-Device-ID': await ref.watch(uuidProviderProvider.future),
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
