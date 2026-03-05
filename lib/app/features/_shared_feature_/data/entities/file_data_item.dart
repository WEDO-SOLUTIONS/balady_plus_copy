import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class FileDataItem extends Equatable {
  final String fileName;
  final String filePath;
  final String fileBase64;
  final bool? isUploaded;
  final Uint8List? bytes;
  final String? id;
  final int sizeInMB;
  final dynamic? fileKey;

  const FileDataItem({
    required this.fileBase64,
    required this.fileName,
    required this.filePath,
    this.isUploaded = false,
    this.id,
    this.sizeInMB = 0,
    this.bytes,
    this.fileKey,
  });

  FileDataItem initialState() =>
      const FileDataItem(fileBase64: "", fileName: "", filePath: "", isUploaded: false, id: null, sizeInMB: 0);

  FileDataItem copyWith({
    String? fileName,
    String? filePath,
    String? fileBase64,
    bool? isUploaded,
    String? id,
    int? sizeInMB,
    Uint8List? bytes,
    String? fileKey,
  }) {
    return FileDataItem(
      fileBase64: fileBase64 ?? this.fileBase64,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      isUploaded: isUploaded ?? this.isUploaded,
      id: id ?? this.id,
      sizeInMB: sizeInMB ?? this.sizeInMB,
      fileKey: fileKey ?? this.fileKey,
      bytes: bytes ?? this.bytes,
    );
  }

  @override
  List<Object?> get props => [id, isUploaded, filePath, fileName, sizeInMB, fileKey];

  @override
  String toString() {
    return 'FileDataItem(fileName: $fileName, filePath: $filePath, isUploaded: $isUploaded, id: $id, sizeInMB: $sizeInMB)';
  }
}
