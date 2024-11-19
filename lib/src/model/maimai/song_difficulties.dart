import 'package:hive/hive.dart';
import 'package:rank_hub/src/model/maimai/song_difficulty.dart';

part 'song_difficulties.g.dart';

@HiveType(typeId: 7)
class SongDifficulties {
  @HiveField(0)
  final List<SongDifficulty> standard;
  @HiveField(1)
  final List<SongDifficulty> dx;
  @HiveField(2)
  final List<SongDifficultyUtage>? utage;

  SongDifficulties({
    required this.standard,
    required this.dx,
    this.utage,
  });

  factory SongDifficulties.fromLxJson(Map<String, dynamic> json) {
    return SongDifficulties(
      standard: (json['standard'] as List)
          .map((item) => SongDifficulty.fromLxJson(item))
          .toList(),
      dx: (json['dx'] as List)
          .map((item) => SongDifficulty.fromLxJson(item))
          .toList(),
      utage: json['utage'] != null
          ? (json['utage'] as List)
              .map((item) => SongDifficultyUtage.fromLxJson(item))
              .toList()
          : null,
    );
  }
}
