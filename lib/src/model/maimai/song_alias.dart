import 'package:hive/hive.dart';

part 'song_alias.g.dart';

@HiveType(typeId: 10)
class SongAlias {
  @HiveField(0)
  final int songId;
  @HiveField(1)
  final List<String> aliases;

  SongAlias({
    required this.songId,
    required this.aliases,
  });

  factory SongAlias.fromLxJson(Map<String, dynamic> json) {
    return SongAlias(
      songId: json['song_id'],
      aliases: List<String>.from(json['aliases'])
      );
  }
}
