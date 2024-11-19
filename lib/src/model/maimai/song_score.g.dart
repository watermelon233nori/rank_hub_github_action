// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongScoreAdapter extends TypeAdapter<SongScore> {
  @override
  final int typeId = 0;

  @override
  SongScore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongScore(
      id: fields[0] as int,
      songName: fields[1] as String?,
      level: fields[2] as String?,
      levelIndex: fields[3] as int,
      achievements: fields[4] as num,
      fc: fields[5] as String?,
      fs: fields[6] as String?,
      dxScore: fields[7] as int,
      dxRating: fields[8] as num?,
      rate: fields[9] as String?,
      type: fields[10] as String,
      playTime: fields[11] as String?,
      uploadTime: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SongScore obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.songName)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.levelIndex)
      ..writeByte(4)
      ..write(obj.achievements)
      ..writeByte(5)
      ..write(obj.fc)
      ..writeByte(6)
      ..write(obj.fs)
      ..writeByte(7)
      ..write(obj.dxScore)
      ..writeByte(8)
      ..write(obj.dxRating)
      ..writeByte(9)
      ..write(obj.rate)
      ..writeByte(10)
      ..write(obj.type)
      ..writeByte(11)
      ..write(obj.playTime)
      ..writeByte(12)
      ..write(obj.uploadTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
