import 'package:hive/hive.dart';
import 'package:rank_hub/src/model/maimai/song_difficulties.dart';

part 'song_info.g.dart';

@HiveType(typeId: 2)
class SongInfo {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String artist;
  @HiveField(3)
  final String genre;
  @HiveField(4)
  final int bpm;
  @HiveField(5)
  final String? map;
  @HiveField(6)
  final int version;
  @HiveField(7)
  final String? rights;
  @HiveField(8)
  final bool? disabled;
  @HiveField(9)
  final SongDifficulties difficulties;

  SongInfo({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.bpm,
    this.map,
    required this.version,
    this.rights,
    this.disabled = false, // 默认值为 false
    required this.difficulties,
  });

  factory SongInfo.fromLxJson(Map<String, dynamic> json) {
    return SongInfo(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      genre: json['genre'],
      bpm: json['bpm'],
      map: json['map'],
      version: json['version'],
      rights: json['rights'],
      disabled: json['disabled'] ?? false,
      difficulties: SongDifficulties.fromLxJson(json['difficulties']),
    );
  }
}