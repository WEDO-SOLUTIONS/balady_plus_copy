import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_dto.freezed.dart';

part 'pagination_dto.g.dart';

@freezed
abstract class PaginationDto with _$PaginationDto {
  factory PaginationDto({
    required final int limit,
    required final int offset,
    required final int page,
    required final int totalPages,
    required final int total,
  }) = _PaginationDto;

  factory PaginationDto.fromJson(Map<String, dynamic> json) => _$PaginationDtoFromJson(json);
}
