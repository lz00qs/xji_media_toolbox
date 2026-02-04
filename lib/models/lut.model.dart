import 'package:freezed_annotation/freezed_annotation.dart';

part 'lut.model.freezed.dart';

@freezed
abstract class Lut with _$Lut {
  const factory Lut({
    @Default(0) int id,
    @Default('Default') String name,
    @Default('') String path,
  }) = _Lut;
}
