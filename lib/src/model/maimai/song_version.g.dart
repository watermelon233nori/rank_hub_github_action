// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_version.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongVersionAdapter extends TypeAdapter<SongVersion> {
  @override
  final int typeId = 9;

  @override
  SongVersion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongVersion(
      id: fields[0] as int,
      title: fields[1] as String,
      version: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SongVersion obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.version);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongVersionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
