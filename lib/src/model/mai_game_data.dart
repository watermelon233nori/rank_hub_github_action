import 'package:rank_hub/src/model/maimai/song_genre.dart';
import 'package:rank_hub/src/model/maimai/song_info.dart';
import 'package:rank_hub/src/model/maimai/song_version.dart';

class MaiGameData {
  final List<SongInfo> songs;
  final List<SongGenre> genres;
  final List<SongVersion> versions;

  MaiGameData({
    required this.songs,
    required this.genres,
    required this.versions
  });
}
