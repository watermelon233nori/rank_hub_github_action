import 'package:hive/hive.dart';

part 'song_notes.g.dart';

@HiveType(typeId: 3)
class SongNotes {
  @HiveField(0)
  final int total;
  @HiveField(1)
  final int tap;
  @HiveField(2)
  final int hold;
  @HiveField(3)
  final int slide;
  @HiveField(4)
  final int touch;
  @HiveField(5)
  final int breakCount; // "break" 是关键字，因此使用 breakCount 代替

  SongNotes({
    required this.total,
    required this.tap,
    required this.hold,
    required this.slide,
    required this.touch,
    required this.breakCount,
  });
  
  factory SongNotes.fromLxJson(Map<String, dynamic> json) {
    return SongNotes(
      total: json['total'],
      tap: json['tap'],
      hold: json['hold'],
      slide: json['slide'],
      touch: json['touch'],
      breakCount: json['break'],
    );
  }
}

@HiveType(typeId: 4)
class BuddyNotes {
  @HiveField(0)
  final SongNotes left;
  @HiveField(1)
  final SongNotes right;

  BuddyNotes({required this.left, required this.right});

  factory BuddyNotes.fromLxJson(Map<String, dynamic> json) {
    return BuddyNotes(
      left: SongNotes.fromLxJson(json['left']),
      right: SongNotes.fromLxJson(json['right']),
    );
  }
}
