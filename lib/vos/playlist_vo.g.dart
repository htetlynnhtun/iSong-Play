// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaylistVoAdapter extends TypeAdapter<PlaylistVo> {
  @override
  final int typeId = 4;

  @override
  PlaylistVo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaylistVo(
      createdAt: fields[0] as DateTime,
      name: fields[2] as String,
    )
      ..id = fields[1] as String
      ..thumbnail = fields[3] as String?
      ..songList = (fields[4] as HiveList).castHiveList();
  }

  @override
  void write(BinaryWriter writer, PlaylistVo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.createdAt)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.thumbnail)
      ..writeByte(4)
      ..write(obj.songList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistVoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
