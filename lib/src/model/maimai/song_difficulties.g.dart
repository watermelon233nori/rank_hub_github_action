// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_difficulties.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongDifficultiesAdapter extends TypeAdapter<SongDifficulties> {
  @override
  final int typeId = 7;

  @override
  SongDifficulties read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongDifficulties(
      standard: (fields[0] as List).cast<SongDifficulty>(),
      dx: (fields[1] as List).cast<SongDifficulty>(),
      utage: (fields[2] as List?)?.cast<SongDifficultyUtage>(),
    );
  }

  @override
  void write(BinaryWriter writer, SongDifficulties obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.standard)
      ..writeByte(1)
      ..write(obj.dx)
      ..writeByte(2)
      ..write(obj.utage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongDifficultiesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
