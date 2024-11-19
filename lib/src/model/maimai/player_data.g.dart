// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerDataAdapter extends TypeAdapter<PlayerData> {
  @override
  final int typeId = 21;

  @override
  PlayerData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerData(
      name: fields[0] as String,
      rating: fields[1] as int,
      friendCode: fields[2] as int,
      trophy: fields[3] as Collection?,
      trophyName: fields[4] as String?,
      courseRank: fields[5] as int,
      classRank: fields[6] as int,
      star: fields[7] as int,
      icon: fields[8] as Collection?,
      namePlate: fields[9] as Collection?,
      frame: fields[10] as Collection?,
      uploadTime: fields[11] as String,
      uuid: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerData obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.rating)
      ..writeByte(2)
      ..write(obj.friendCode)
      ..writeByte(3)
      ..write(obj.trophy)
      ..writeByte(4)
      ..write(obj.trophyName)
      ..writeByte(5)
      ..write(obj.courseRank)
      ..writeByte(6)
      ..write(obj.classRank)
      ..writeByte(7)
      ..write(obj.star)
      ..writeByte(8)
      ..write(obj.icon)
      ..writeByte(9)
      ..write(obj.namePlate)
      ..writeByte(10)
      ..write(obj.frame)
      ..writeByte(11)
      ..write(obj.uploadTime)
      ..writeByte(12)
      ..write(obj.uuid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
