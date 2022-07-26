import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Colour {
  static Color background = const Color(0xFF252e42);
  static Color backgroundContainer = const Color(0xFF2f3b52);
  static Color primary = const Color(0xFFD6B704);
  static Color primaryContainer = const Color(0xDDD6B734);
  static Color secondary = const Color(0xFF8AA314);
  static Color secondaryContainer = const Color(0xFF0051b2);
  static Color tertiary = const Color(0xFFfe0049);
  static Color text = const Color(0xFFb1b5be);
  static Color textAccent = const Color(0xFF313030);
}

class Textstyle {
  static TextStyle body = GoogleFonts.lato(
    textStyle: TextStyle(color: Colour.text),
  );
  static TextStyle bodySmall = body.copyWith(fontSize: 12);
  static TextStyle bodyBold = GoogleFonts.lato(
    textStyle: TextStyle(color: Colour.text, fontWeight: FontWeight.bold),
  );
  static TextStyle caption = body.copyWith(fontStyle: FontStyle.italic);
  static TextStyle title = GoogleFonts.lato(
    textStyle: TextStyle(
      color: Colour.text,
      fontWeight: FontWeight.bold,
      fontSize: 32,
    ),
  );
  static TextStyle title2 = GoogleFonts.lato(
    textStyle: TextStyle(
      color: Colour.text,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
  );
  static TextStyle subtitle = GoogleFonts.lato(
    textStyle: TextStyle(
      color: Colour.text,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  );
}

InputDecoration inputDecor(
  String labelText,
  String hintText, {
  Widget? prefix,
  bool isClearable = false,
  Function()? onClear,
  bool isFilled = false,
}) {
  return InputDecoration(
    fillColor: Colour.primary,
    filled: isFilled,
    labelText: labelText,
    hintText: hintText,
    labelStyle: Textstyle.body,
    hintStyle: Textstyle.body,
    focusColor: Colour.primary,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: Colour.text,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Colour.primary,
      ),
    ),
    prefix: prefix,
    suffixIcon: isClearable == true
        ? InkWell(
            onTap: onClear,
            child: Icon(
              Icons.cancel_rounded,
              color: Colour.text,
              size: 18,
            ),
          )
        : null,
  );
}
