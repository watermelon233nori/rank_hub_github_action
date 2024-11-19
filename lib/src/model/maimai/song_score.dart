import 'package:hive/hive.dart';

part 'song_score.g.dart';

@HiveType(typeId: 0)
class SongScore {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String? songName;

  @HiveField(2)
  final String? level;

  @HiveField(3)
  final int levelIndex;

  @HiveField(4)
  final num achievements;

  @HiveField(5)
  final String? fc;

  @HiveField(6)
  final String? fs;

  @HiveField(7)
  final int dxScore;

  @HiveField(8)
  final num? dxRating;

  @HiveField(9)
  final String? rate;

  @HiveField(10)
  final String type;

  @HiveField(11)
  final String? playTime;

  @HiveField(12)
  final String? uploadTime;

  SongScore({
    required this.id,
    this.songName,
    this.level,
    required this.levelIndex,
    required this.achievements,
    this.fc,
    this.fs,
    required this.dxScore,
    this.dxRating,
    this.rate,
    required this.type,
    this.playTime,
    this.uploadTime,
  });

  factory SongScore.fromLxJson(Map<String, dynamic> json) {
    return SongScore(
      id: json['id'],
      songName: json['song_name'],
      level: json['level'],
      levelIndex: json['level_index'],
      achievements: json['achievements'],
      fc: json['fc'],
      fs: json['fs'],
      dxScore: json['dx_score'],
      dxRating: json['dx_rating'],
      rate: json['rate'],
      type: json['type'],
      playTime: json['play_time'],
      uploadTime: json['upload_time'],
    );
  }
}
