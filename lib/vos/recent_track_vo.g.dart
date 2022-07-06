// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_track_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentTrackVOAdapter extends TypeAdapter<RecentTrackVO> {
  @override
  final int typeId = 7;

  @override
  RecentTrackVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentTrackVO(
      fields[1] as String,
      fields[2] as bool,
    )..updatedAt = fields[0] as DateTime;
  }

  @override
  void write(BinaryWriter writer, RecentTrackVO obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.updatedAt)
      ..writeByte(1)
      ..write(obj.songID)
      ..writeByte(2)
      ..write(obj.isDownloaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentTrackVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
