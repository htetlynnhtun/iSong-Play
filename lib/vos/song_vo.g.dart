// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongVOAdapter extends TypeAdapter<SongVO> {
  @override
  final int typeId = 1;

  @override
  SongVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongVO(
      createdAt: fields[0] as DateTime,
      id: fields[1] as String,
      title: fields[2] as String,
      artist: fields[3] as String,
      thumbnail: fields[4] as String,
      duration: fields[6] as Duration,
      filePath: fields[7] as String,
      dominantColor: (fields[8] as List).cast<Color?>(),
      isFavorite: fields[9] as bool,
    )..isDownloadFinished = fields[5] as bool;
  }

  @override
  void write(BinaryWriter writer, SongVO obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.createdAt)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.artist)
      ..writeByte(4)
      ..write(obj.thumbnail)
      ..writeByte(5)
      ..write(obj.isDownloadFinished)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.filePath)
      ..writeByte(8)
      ..write(obj.dominantColor)
      ..writeByte(9)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
