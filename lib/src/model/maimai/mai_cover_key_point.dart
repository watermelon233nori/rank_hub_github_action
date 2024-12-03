import 'package:hive/hive.dart';

part 'mai_cover_key_point.g.dart';

@HiveType(typeId: 31)
class MaiCoverKeyPoint {
  @HiveField(0)
  final double x;
  @HiveField(1)
  final double y;
  @HiveField(2)
  final double size;
  @HiveField(3)
  final double angle;

  MaiCoverKeyPoint({
    required this.x,
    required this.y,
    required this.size,
    required this.angle,
  });
}