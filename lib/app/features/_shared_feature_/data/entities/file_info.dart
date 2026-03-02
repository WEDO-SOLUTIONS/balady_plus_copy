import 'package:equatable/equatable.dart';

import '../../../../core/dependency_injection/dependency_injection_exports.dart' show sl;

class FileInfo extends Equatable {
  final String fileName;
  final String filePath;
  final String fileBase64;
  final bool isUploaded;
  final String? id;
  final int sizeInMB;
  final String extension;

  const FileInfo({
    this.fileName = "",
    this.filePath = "",
    this.fileBase64 = "",
    this.isUploaded = false,
    this.id,
    this.sizeInMB = 0,
    this.extension = "",
  });

  @override
  List<Object?> get props => [id, isUploaded, filePath, fileName, sizeInMB, extension];

  FileInfo initialState() => sl<FileInfo>().copyWith(
        fileBase64: "",
        fileName: "",
        filePath: "",
        isUploaded: false,
        id: null,
        sizeInMB: 0,
        extension: "",
      );

  FileInfo copyWith({
    String? fileName,
    String? filePath,
    String? fileBase64,
    bool? isUploaded,
    String? id,
    int? sizeInMB,
    String? extension,
  }) {
    return FileInfo(
      fileBase64: fileBase64 ?? this.fileBase64,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      isUploaded: isUploaded ?? this.isUploaded,
      id: id ?? this.id,
      sizeInMB: sizeInMB ?? this.sizeInMB,
      extension: extension ?? this.extension,
    );
  }

  @override
  String toString() {
    return 'FileEntity(fileName: $fileName, filePath: $filePath, isUploaded: $isUploaded, id: $id, sizeInMB: $sizeInMB, extension: $extension)';
  }
}
