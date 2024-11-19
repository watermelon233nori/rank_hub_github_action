import 'package:hive/hive.dart';
import 'package:rank_hub/src/model/maimai/song_genre.dart';
import 'package:rank_hub/src/model/maimai/song_info.dart';
import 'package:rank_hub/src/model/maimai/song_version.dart';

part 'game_data.g.dart';

@HiveType(typeId: 11)
class GameData {
  @HiveField(0)
  final List<SongInfo> songs;
  @HiveField(1)
  final List<SongGenre> genres;
  @HiveField(2)
  final List<SongVersion> versions;

  GameData({required this.songs, required this.genres, required this.versions});

  factory GameData.fromLxJson(Map<String, dynamic> json) {
    return GameData(
      songs: (json['songs'] as List)
          .map((json1) => SongInfo.fromLxJson(json1))
          .toList(),
      genres: (json['genres'] as List)
          .map((json1) => SongGenre.fromLxJson(json1))
          .toList(),
      versions: (json['versions'] as List)
          .map((json1) => SongVersion.fromLxJson(json1))
          .toList(),
    );
  }
}
