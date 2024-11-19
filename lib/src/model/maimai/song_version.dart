import 'package:hive/hive.dart';

part 'song_version.g.dart';

@HiveType(typeId: 9)
class SongVersion {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final int version;

  SongVersion({
    required this.id,
    required this.title,
    required this.version,
  });

  factory SongVersion.fromLxJson(Map<String, dynamic> json) {
    return SongVersion(
      id: json['id'],
      title: json['title'],
      version: json['version'],
    );
  }
}
