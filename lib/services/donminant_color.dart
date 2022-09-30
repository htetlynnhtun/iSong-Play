import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class DominantColor {
  static Future<List<Color?>> getDominantColor(String imageUrl) async {
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
      maximumColorCount: 20,
    );
    Color? beginColor = paletteGenerator.darkMutedColor?.color;
    Color? endColor = paletteGenerator.dominantColor?.color;
    return [beginColor, endColor];
  }
}
