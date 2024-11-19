import 'package:hive/hive.dart';
import 'package:rank_hub/src/model/maimai/song_notes.dart';

part 'song_difficulty.g.dart';

@HiveType(typeId: 5)
class SongDifficulty {
  @HiveField(0)
  final String type; // SongType 的枚举值
  @HiveField(1)
  final int difficulty; // LevelIndex 的枚举值
  @HiveField(2)
  final String level;
  @HiveField(3)
  final num levelValue;
  @HiveField(4)
  final String noteDesigner;
  @HiveField(5)
  final int version;
  @HiveField(6)
  final Object? notes;

  SongDifficulty({
    required this.type,
    required this.difficulty,
    required this.level,
    required this.levelValue,
    required this.noteDesigner,
    required this.version,
    this.notes,
  });

  factory SongDifficulty.fromLxJson(Map<String, dynamic> json) {
    return SongDifficulty(
      type: json['type'],
      difficulty: json['difficulty'],
      level: json['level'],
      levelValue: json['level_value'],
      noteDesigner: json['note_designer'],
      version: json['version'],
      notes: json['notes'] != null ? SongNotes.fromLxJson(json['notes']) : null,
    );
  }
}

@HiveType(typeId: 6)
class SongDifficultyUtage extends SongDifficulty {
  @HiveField(7)
  final String kanji;
  @HiveField(8)
  final String description;
  @HiveField(9)
  final bool isBuddy;

  SongDifficultyUtage({
    required super.type,
    required super.difficulty,
    required super.level,
    required super.levelValue,
    required super.noteDesigner,
    required super.version,
    super.notes,
    required this.kanji,
    required this.description,
    required this.isBuddy,
  });

  factory SongDifficultyUtage.fromLxJson(Map<String, dynamic> json) {
    final dynamic notes = json['is_buddy'] == true
        ? BuddyNotes.fromLxJson(json['notes'])
        : json['notes'] != null
            ? SongNotes.fromLxJson(json['notes'])
            : null;

    return SongDifficultyUtage(
      kanji: json['kanji'],
      description: json['description'],
      isBuddy: json['is_buddy'] ?? false,
      notes: notes,
      type: json['type'],
      difficulty: json['difficulty'],
      level: json['level'],
      levelValue: json['level_value'],
      noteDesigner: json['note_designer'],
      version: json['version'],
    );
  }
}
