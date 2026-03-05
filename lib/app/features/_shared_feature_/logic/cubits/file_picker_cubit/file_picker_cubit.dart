import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

import '../../../../../core/utils/utils_exports.dart' show FileSelectorStatus;
import '../../../shared_feature_exports.dart' show FileInfo;

part 'file_picker_state.dart';

class FilePickerCubit extends Cubit<FilePickerState> {
  final String initialFileName;
  FilePickerCubit({required this.initialFileName}) : super(FilePickerState(fileName: initialFileName));

  void onSelectedAttachment(FileInfo file) => emit(state.copyWith(file: file, status: FileSelectorStatus.selected));
  void onUnSelectedAttachment() => emit(FilePickerState(fileName: initialFileName));
}
