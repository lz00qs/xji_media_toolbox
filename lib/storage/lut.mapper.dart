import '../models/lut.model.dart';
import 'lut.entity.dart';

extension LutMapper on LutEntity {
  Lut toModel() => Lut(name: name, path: path);
}

extension LutEntityMapper on Lut {
  LutEntity toEntity() => LutEntity(name: name, path: path);
}
