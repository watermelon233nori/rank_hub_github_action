// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_difficulty.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongDifficultyAdapter extends TypeAdapter<SongDifficulty> {
  @override
  final int typeId = 5;

  @override
  SongDifficulty read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongDifficulty(
      type: fields[0] as String,
      difficulty: fields[1] as int,
      level: fields[2] as String,
      levelValue: fields[3] as num,
      noteDesigner: fields[4] as String,
      version: fields[5] as int,
      notes: fields[6] as Object?,
    );
  }

  @override
  void write(BinaryWriter writer, SongDifficulty obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.difficulty)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.levelValue)
      ..writeByte(4)
      ..write(obj.noteDesigner)
      ..writeByte(5)
      ..write(obj.version)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongDifficultyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SongDifficultyUtageAdapter extends TypeAdapter<SongDifficultyUtage> {
  @override
  final int typeId = 6;

  @override
  SongDifficultyUtage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongDifficultyUtage(
      type: fields[0] as String,
      difficulty: fields[1] as int,
      level: fields[2] as String,
      levelValue: fields[3] as num,
      noteDesigner: fields[4] as String,
      version: fields[5] as int,
      notes: fields[6] as Object?,
      kanji: fields[7] as String,
      description: fields[8] as String,
      isBuddy: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SongDifficultyUtage obj) {
    writer
      ..writeByte(10)
      ..writeByte(7)
      ..write(obj.kanji)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.isBuddy)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.difficulty)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.levelValue)
      ..writeByte(4)
      ..write(obj.noteDesigner)
      ..writeByte(5)
      ..write(obj.version)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongDifficultyUtageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
