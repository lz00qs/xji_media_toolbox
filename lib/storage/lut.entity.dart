import 'package:objectbox/objectbox.dart';

@Entity()
class LutEntity {
  @Id()
  int id = 0;
  String name = 'Default';
  String path = '';

  LutEntity({
    this.id = 0,
    required this.name,
    required this.path,
  });
}
