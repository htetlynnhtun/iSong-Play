import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:music_app/persistance/box_names.dart';

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final typeId = colorTypeId;

  @override
  Color read(BinaryReader reader) {
    return Color(reader.readInt());
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeInt(obj.value);
  }
}
