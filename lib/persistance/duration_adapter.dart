import 'package:hive/hive.dart';
import 'package:music_app/persistance/box_names.dart';

class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final typeId = durationTypeId;

  @override
  Duration read(BinaryReader reader) {
    return Duration(microseconds: reader.readInt());
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer.writeInt(obj.inMicroseconds);
  }
}