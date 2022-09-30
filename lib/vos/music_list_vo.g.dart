// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_list_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicListVOAdapter extends TypeAdapter<MusicListVO> {
  @override
  final int typeId = 6;

  @override
  MusicListVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MusicListVO(
      title: fields[0] as String,
      playlistId: fields[1] as String,
      thumbnail: fields[2] as String,
      songCount: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MusicListVO obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.playlistId)
      ..writeByte(2)
      ..write(obj.thumbnail)
      ..writeByte(3)
      ..write(obj.songCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicListVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
