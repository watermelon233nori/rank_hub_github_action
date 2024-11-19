import 'package:hive/hive.dart';

part 'song_genre.g.dart';

@HiveType(typeId: 8)
class SongGenre {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String genre;

  SongGenre({
    required this.id,
    required this.title,
    required this.genre,
  });

  factory SongGenre.fromLxJson(Map<String, dynamic> json) {
    return SongGenre(
      id: json['id'],
      title: json['title'],
      genre: json['genre'],
    );
  }
}
