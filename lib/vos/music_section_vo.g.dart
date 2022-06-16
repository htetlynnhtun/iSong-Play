// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_section_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicSectionVOAdapter extends TypeAdapter<MusicSectionVO> {
  @override
  final int typeId = 5;

  @override
  MusicSectionVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MusicSectionVO(
      fields[0] as String,
      (fields[1] as List).cast<MusicListVO>(),
    );
  }

  @override
  void write(BinaryWriter writer, MusicSectionVO obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.musicLists);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicSectionVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
