import 'dart:async';
import 'dart:core';

import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../transaction_inquiry/presentation/core/models/download_file_result.dart';
import '../../data/models/request_details_response.dart';
import '../entities/download_file_params.dart';
import '../entities/reply_retrive_car_params.dart';
import '../entities/reply_retrive_car_response.dart';
import '../entities/request_details_response.dart';

abstract class RequestsRepository {
  Future<Either<Failure, RequestDetailsResponse>> getCRMIncidentRequestDetails(
      String params);
  Future<Either<Failure, RequestDetailsResponse>> getCRMINQRequestDetails(
      String params);
  Future<Either<Failure, RequestDetailsResponse>> getCRMREQRequestDetails(
      String params);

  Future<Either<Failure, CrmRequestDetails>> getDCRequestDetails(String params);

  Future<Either<Failure, DownloadFileResult?>> downloadFile(
      DownLoadFileParams params);
  Future<Either<Failure, ReplyRetriveCarResponse>> replyRetriveCar(
      {required ReplyRetriveCarParams params});
}
