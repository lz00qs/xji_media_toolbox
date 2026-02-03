import 'package:freezed_annotation/freezed_annotation.dart';

part 'lut.model.freezed.dart';

@freezed
abstract class Lut with _$Lut {
  const factory Lut({
    @Default('Default') String name,
    @Default('') String path,
  }) = _Lut;
}
