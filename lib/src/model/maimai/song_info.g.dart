// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongInfoAdapter extends TypeAdapter<SongInfo> {
  @override
  final int typeId = 2;

  @override
  SongInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongInfo(
      id: fields[0] as int,
      title: fields[1] as String,
      artist: fields[2] as String,
      genre: fields[3] as String,
      bpm: fields[4] as int,
      map: fields[5] as String?,
      version: fields[6] as int,
      rights: fields[7] as String?,
      disabled: fields[8] as bool?,
      difficulties: fields[9] as SongDifficulties,
    );
  }

  @override
  void write(BinaryWriter writer, SongInfo obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.genre)
      ..writeByte(4)
      ..write(obj.bpm)
      ..writeByte(5)
      ..write(obj.map)
      ..writeByte(6)
      ..write(obj.version)
      ..writeByte(7)
      ..write(obj.rights)
      ..writeByte(8)
      ..write(obj.disabled)
      ..writeByte(9)
      ..write(obj.difficulties);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
