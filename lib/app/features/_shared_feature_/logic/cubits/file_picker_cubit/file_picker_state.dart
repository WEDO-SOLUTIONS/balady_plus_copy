part of 'file_picker_cubit.dart';

class FilePickerState extends Equatable {
  final FileSelectorStatus status;
  final String fileName;
  final FileInfo? file;

  const FilePickerState({
    this.status = FileSelectorStatus.unselected,
    required this.fileName,
    this.file,
  });

  String get selectedFileName => file?.fileName ?? fileName;
  bool get isSelected => status == FileSelectorStatus.selected;

  @override
  List<Object?> get props => [status, fileName, file];

  FilePickerState copyWith({
    FileSelectorStatus? status,
    String? fileName,
    FileInfo? file,
  }) =>
      FilePickerState(
        status: status ?? this.status,
        fileName: fileName ?? this.fileName,
        file: file ?? this.file,
      );

  @override
  String toString() => 'FilePickerState(status: $status, fileName: $fileName, file: $file)';
}
