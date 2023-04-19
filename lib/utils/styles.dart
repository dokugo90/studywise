import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

const Color mainColor = Color(0xFF4636FC);
const Color darkTheme = Color(0xFF0a092d);
const Color darkThemeUi = Color(0xFF2e3856);
const Color lightTheme = Color(0xFFedeff4);
const Color lightThemeUi = Colors.white;
const FontWeight fontBold = FontWeight.w900;
const Icon light_mode_icon = Icon(EvaIcons.sunOutline, color: Color(0xFFffcd1f),);
const Icon dark_mode_icon = Icon(EvaIcons.moon, color: Color(0xFF0a092d),);

class ThemeService {
  bool darkMode = false;
}
