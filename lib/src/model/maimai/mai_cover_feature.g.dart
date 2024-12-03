// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mai_cover_feature.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaiCoverFeatureAdapter extends TypeAdapter<MaiCoverFeature> {
  @override
  final int typeId = 30;

  @override
  MaiCoverFeature read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MaiCoverFeature(
      id: fields[0] as int,
      keypoints: (fields[1] as List)
          .map((dynamic e) => (e as List).cast<double>())
          .toList(),
      descriptors: (fields[2] as List)
          .map((dynamic e) => (e as List).cast<num>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, MaiCoverFeature obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.keypoints)
      ..writeByte(2)
      ..write(obj.descriptors);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaiCoverFeatureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
