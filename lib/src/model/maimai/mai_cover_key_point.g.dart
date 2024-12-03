// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mai_cover_key_point.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaiCoverKeyPointAdapter extends TypeAdapter<MaiCoverKeyPoint> {
  @override
  final int typeId = 31;

  @override
  MaiCoverKeyPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MaiCoverKeyPoint(
      x: fields[0] as double,
      y: fields[1] as double,
      size: fields[2] as double,
      angle: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MaiCoverKeyPoint obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.x)
      ..writeByte(1)
      ..write(obj.y)
      ..writeByte(2)
      ..write(obj.size)
      ..writeByte(3)
      ..write(obj.angle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaiCoverKeyPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
