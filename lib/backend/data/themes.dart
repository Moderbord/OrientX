import 'package:flutter/material.dart';
import '../../app/themes/theme_export.dart' as themeImport;

/// Enumeration of available themes.
enum Themes {
  orangeLight,
  orangeDark,
  blueLight,
  blueDark,
  purpleLight,
  purpleDark
}

/// Returns the formatted name of a specific theme.
///
/// Takes an enumerated theme index.
String getThemeName(Themes theme) {
  switch (theme) {
    case Themes.orangeLight:
      return "Orientering (standard)";
    case Themes.orangeDark:
      return "Nattorientering (AMOLED)";
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

/// Returns the enumerated them index corresponding to a theme data object.
Themes themeGetEnum(ThemeData themeData) {

  if (themeData == themeImport.orangeDark) return Themes.orangeDark;
  if (themeData == themeImport.blueLight) return Themes.blueLight;
  if (themeData == themeImport.blueDark) return Themes.blueDark;
  if (themeData == themeImport.purpleLight) return Themes.purpleLight;
  if (themeData == themeImport.purpleDark) return Themes.purpleDark;

  return Themes.orangeLight;
}

/// Returns the theme data object corresponding to an enumerated theme index.
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
