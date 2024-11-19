// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_alias.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongAliasAdapter extends TypeAdapter<SongAlias> {
  @override
  final int typeId = 10;

  @override
  SongAlias read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongAlias(
      songId: fields[0] as int,
      aliases: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SongAlias obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.songId)
      ..writeByte(1)
      ..write(obj.aliases);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongAliasAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
