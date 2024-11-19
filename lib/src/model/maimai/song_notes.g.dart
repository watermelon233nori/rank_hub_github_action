// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_notes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongNotesAdapter extends TypeAdapter<SongNotes> {
  @override
  final int typeId = 3;

  @override
  SongNotes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongNotes(
      total: fields[0] as int,
      tap: fields[1] as int,
      hold: fields[2] as int,
      slide: fields[3] as int,
      touch: fields[4] as int,
      breakCount: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SongNotes obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.total)
      ..writeByte(1)
      ..write(obj.tap)
      ..writeByte(2)
      ..write(obj.hold)
      ..writeByte(3)
      ..write(obj.slide)
      ..writeByte(4)
      ..write(obj.touch)
      ..writeByte(5)
      ..write(obj.breakCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongNotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BuddyNotesAdapter extends TypeAdapter<BuddyNotes> {
  @override
  final int typeId = 4;

  @override
  BuddyNotes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BuddyNotes(
      left: fields[0] as SongNotes,
      right: fields[1] as SongNotes,
    );
  }

  @override
  void write(BinaryWriter writer, BuddyNotes obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.left)
      ..writeByte(1)
      ..write(obj.right);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BuddyNotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
