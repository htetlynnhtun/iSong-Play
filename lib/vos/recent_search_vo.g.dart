// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_search_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentSearchVOAdapter extends TypeAdapter<RecentSearchVO> {
  @override
  final int typeId = 0;

  @override
  RecentSearchVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentSearchVO(
      createdAt: fields[0] as DateTime,
      query: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecentSearchVO obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.createdAt)
      ..writeByte(1)
      ..write(obj.query);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentSearchVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
