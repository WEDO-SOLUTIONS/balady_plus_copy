import 'package:equatable/equatable.dart';

class UploadFileResponse extends Equatable {
  String? fileId;

  UploadFileResponse({this.fileId});
  @override
  List<Object?> get props => [fileId];
}
