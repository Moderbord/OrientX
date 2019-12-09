import 'package:flutter/material.dart';
import '../themes/theme_export.dart' as themeImport;

enum Themes {
  orangeLight,
  orangeDark,
  blueLight,
  blueDark,
  purpleLight,
  purpleDark
}

String getThemeName(Themes theme) {
  switch (theme) {
    case Themes.orangeLight:
      return "Orientering (standard)";
    case Themes.orangeDark:
      return "Nattorientering";
    case Themes.blueLight:
      return "Marina";
    case Themes.blueDark:
      return "Vinternatt";
    case Themes.purpleLight:
      return "Ultraviolett";
    case Themes.purpleDark:
      return "Sombert värre";
  }

  return "No theme!";
}

Themes themeGetEnum(ThemeData themeData) {

  if (themeData == themeImport.orangeDark) return Themes.orangeDark;
  if (themeData == themeImport.blueLight) return Themes.blueLight;
  if (themeData == themeImport.blueDark) return Themes.blueDark;
  if (themeData == themeImport.purpleLight) return Themes.purpleLight;
  if (themeData == themeImport.purpleDark) return Themes.purpleDark;

  return Themes.orangeLight;
}

ThemeData themeFromEnum(Themes theme) {
  switch (theme) {
    case Themes.orangeLight:
      return themeImport.orangeLight;
    case Themes.orangeDark:
      return themeImport.orangeDark;
    case Themes.blueLight:
      return themeImport.blueLight;
    case Themes.blueDark:
      return themeImport.blueDark;
    case Themes.purpleLight:
      return themeImport.purpleLight;
    case Themes.purpleDark:
      return themeImport.purpleDark;
  }

  return themeImport.orangeLight;
}
