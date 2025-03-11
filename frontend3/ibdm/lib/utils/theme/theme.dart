import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff005eb3),
      surfaceTint: Color(0xff005eb3),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff559dff),
      onPrimaryContainer: Color(0xff000e23),
      secondary: Color(0xff445f8a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffbcd4ff),
      onSecondaryContainer: Color(0xff223f67),
      tertiary: Color(0xff5d5f5f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffffff),
      onTertiaryContainer: Color(0xff575859),
      error: Color(0xffa5000d),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffe80f1b),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff181c22),
      onSurfaceVariant: Color(0xff414753),
      outline: Color(0xff717785),
      outlineVariant: Color(0xffc0c6d5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3038),
      inversePrimary: Color(0xffa7c8ff),
      primaryFixed: Color(0xffd5e3ff),
      onPrimaryFixed: Color(0xff001b3c),
      primaryFixedDim: Color(0xffa7c8ff),
      onPrimaryFixedVariant: Color(0xff004689),
      secondaryFixed: Color(0xffd5e3ff),
      onSecondaryFixed: Color(0xff001b3c),
      secondaryFixedDim: Color(0xffacc8f8),
      onSecondaryFixedVariant: Color(0xff2b4770),
      tertiaryFixed: Color(0xffe2e2e2),
      onTertiaryFixed: Color(0xff1a1c1c),
      tertiaryFixedDim: Color(0xffc6c6c7),
      onTertiaryFixedVariant: Color(0xff454747),
      surfaceDim: Color(0xffd7dae3),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f3fd),
      surfaceContainer: Color(0xffebedf7),
      surfaceContainerHigh: Color(0xffe6e8f1),
      surfaceContainerHighest: Color(0xffe0e2ec),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff004382),
      surfaceTint: Color(0xff005eb3),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff0074da),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff27436c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5a75a1),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff414343),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff737575),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffe80f1b),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff181c22),
      onSurfaceVariant: Color(0xff3d434f),
      outline: Color(0xff595f6c),
      outlineVariant: Color(0xff747b88),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3038),
      inversePrimary: Color(0xffa7c8ff),
      primaryFixed: Color(0xff0074da),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff005caf),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5a75a1),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff415d87),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff737575),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5a5c5c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dae3),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f3fd),
      surfaceContainer: Color(0xffebedf7),
      surfaceContainerHigh: Color(0xffe6e8f1),
      surfaceContainerHighest: Color(0xffe0e2ec),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002248),
      surfaceTint: Color(0xff005eb3),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004382),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff002248),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff27436c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff202323),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff414343),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0003),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1e242f),
      outline: Color(0xff3d434f),
      outlineVariant: Color(0xff3d434f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3038),
      inversePrimary: Color(0xffe4ecff),
      primaryFixed: Color(0xff004382),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff002c5a),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff27436c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff0c2d54),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff414343),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff2b2d2d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dae3),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f3fd),
      surfaceContainer: Color(0xffebedf7),
      surfaceContainerHigh: Color(0xffe6e8f1),
      surfaceContainerHighest: Color(0xffe0e2ec),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa7c8ff),
      surfaceTint: Color(0xffa7c8ff),
      onPrimary: Color(0xff003061),
      primaryContainer: Color(0xff0074da),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xffacc8f8),
      onSecondary: Color(0xff113158),
      secondaryContainer: Color(0xff203d65),
      onSecondaryContainer: Color(0xffb7d1ff),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff2f3131),
      tertiaryContainer: Color(0xffd4d4d4),
      onTertiaryContainer: Color(0xff3e4040),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xffe80f1b),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xff10131a),
      onSurface: Color(0xffe0e2ec),
      onSurfaceVariant: Color(0xffc0c6d5),
      outline: Color(0xff8b919f),
      outlineVariant: Color(0xff414753),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e2ec),
      inversePrimary: Color(0xff005eb3),
      primaryFixed: Color(0xffd5e3ff),
      onPrimaryFixed: Color(0xff001b3c),
      primaryFixedDim: Color(0xffa7c8ff),
      onPrimaryFixedVariant: Color(0xff004689),
      secondaryFixed: Color(0xffd5e3ff),
      onSecondaryFixed: Color(0xff001b3c),
      secondaryFixedDim: Color(0xffacc8f8),
      onSecondaryFixedVariant: Color(0xff2b4770),
      tertiaryFixed: Color(0xffe2e2e2),
      onTertiaryFixed: Color(0xff1a1c1c),
      tertiaryFixedDim: Color(0xffc6c6c7),
      onTertiaryFixedVariant: Color(0xff454747),
      surfaceDim: Color(0xff10131a),
      surfaceBright: Color(0xff363941),
      surfaceContainerLowest: Color(0xff0b0e15),
      surfaceContainerLow: Color(0xff181c22),
      surfaceContainer: Color(0xff1c2026),
      surfaceContainerHigh: Color(0xff272a31),
      surfaceContainerHighest: Color(0xff31353c),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffafccff),
      surfaceTint: Color(0xffa7c8ff),
      onPrimary: Color(0xff001632),
      primaryContainer: Color(0xff3391ff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffb0ccfc),
      onSecondary: Color(0xff001632),
      secondaryContainer: Color(0xff7792bf),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff2f3131),
      tertiaryContainer: Color(0xffd4d4d4),
      onTertiaryContainer: Color(0xff1e2020),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff10131a),
      onSurface: Color(0xfffbfaff),
      onSurfaceVariant: Color(0xffc5cbda),
      outline: Color(0xff9da3b1),
      outlineVariant: Color(0xff7d8391),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e2ec),
      inversePrimary: Color(0xff00488b),
      primaryFixed: Color(0xffd5e3ff),
      onPrimaryFixed: Color(0xff001129),
      primaryFixedDim: Color(0xffa7c8ff),
      onPrimaryFixedVariant: Color(0xff00366b),
      secondaryFixed: Color(0xffd5e3ff),
      onSecondaryFixed: Color(0xff001129),
      secondaryFixedDim: Color(0xffacc8f8),
      onSecondaryFixedVariant: Color(0xff18365e),
      tertiaryFixed: Color(0xffe2e2e2),
      onTertiaryFixed: Color(0xff0f1112),
      tertiaryFixedDim: Color(0xffc6c6c7),
      onTertiaryFixedVariant: Color(0xff343637),
      surfaceDim: Color(0xff10131a),
      surfaceBright: Color(0xff363941),
      surfaceContainerLowest: Color(0xff0b0e15),
      surfaceContainerLow: Color(0xff181c22),
      surfaceContainer: Color(0xff1c2026),
      surfaceContainerHigh: Color(0xff272a31),
      surfaceContainerHighest: Color(0xff31353c),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffbfaff),
      surfaceTint: Color(0xffa7c8ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffafccff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffbfaff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb0ccfc),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffd4d4d4),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff10131a),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffbfaff),
      outline: Color(0xffc5cbda),
      outlineVariant: Color(0xffc5cbda),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e2ec),
      inversePrimary: Color(0xff002a55),
      primaryFixed: Color(0xffdce7ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffafccff),
      onPrimaryFixedVariant: Color(0xff001632),
      secondaryFixed: Color(0xffdce7ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb0ccfc),
      onSecondaryFixedVariant: Color(0xff001632),
      tertiaryFixed: Color(0xffe6e7e7),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffcacbcb),
      onTertiaryFixedVariant: Color(0xff141717),
      surfaceDim: Color(0xff10131a),
      surfaceBright: Color(0xff363941),
      surfaceContainerLowest: Color(0xff0b0e15),
      surfaceContainerLow: Color(0xff181c22),
      surfaceContainer: Color(0xff1c2026),
      surfaceContainerHigh: Color(0xff272a31),
      surfaceContainerHighest: Color(0xff31353c),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );

  /// Success
  static const success = ExtendedColor(
    seed: Color(0xff00f782),
    value: Color(0xff00f782),
    light: ColorFamily(
      color: Color(0xff006d36),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff1ffe88),
      onColorContainer: Color(0xff005126),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff006d36),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff1ffe88),
      onColorContainer: Color(0xff005126),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff006d36),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff1ffe88),
      onColorContainer: Color(0xff005126),
    ),
    dark: ColorFamily(
      color: Color(0xfff7fff4),
      onColor: Color(0xff003919),
      colorContainer: Color(0xff00f17f),
      onColorContainer: Color(0xff004821),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xfff7fff4),
      onColor: Color(0xff003919),
      colorContainer: Color(0xff00f17f),
      onColorContainer: Color(0xff004821),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xfff7fff4),
      onColor: Color(0xff003919),
      colorContainer: Color(0xff00f17f),
      onColorContainer: Color(0xff004821),
    ),
  );


  List<ExtendedColor> get extendedColors => [
    success,
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
