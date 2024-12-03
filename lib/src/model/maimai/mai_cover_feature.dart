import 'package:hive_flutter/hive_flutter.dart';

part 'mai_cover_feature.g.dart';

@HiveType(typeId: 30)
class MaiCoverFeature {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final List<List<double>> keypoints;

  @HiveField(2)
  final List<List<num>> descriptors;

  MaiCoverFeature({
    required this.id,
    required this.keypoints,
    required this.descriptors,
  });
}
