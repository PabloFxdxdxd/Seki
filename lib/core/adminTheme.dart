import 'package:flutter/material.dart';

class AdminColors {
  //colores para el dashboard
  static const Color primary = Color(0xFF8DEAE6);
  static const Color primarySelected = Color(0xFF27A49E);
  static const Color secondary = Color(0xFF34716E);
  static const Color background = Color(0xFFFFFFFF);

  //cards
  static const Color surface = Color(0xFF1E2E2E); //card oscura
  static const Color surfaceDark = Color(0xFF152222);

  //text
  static const Color textPrimary = Color(0xFFE8F8F7);
  static const Color textSecondary = Color(0xFF8DEAE6); //primary
  static const Color textMuted = Color(0xFF5A9490); //apagado

  //estados
  static const Color successLight = Color(0x3327A49E); //20% opacidad
  static const Color error = Color(0xFFE05C5C);
  //bordes
  static const Color border = Color(0xFF2E4444);
  static const Color borderFocus = Color(0xFF27A49E);

  //scaffold y appbar
  static const Color scaffoldBackground = Color(0xFF111E1E);
  static const Color appBarBackground = Color(0xFF152222);

  //bottom nav
  static const Color navBackground = Color(0xFF152222);
  static const Color navSelected = Color(0xFF8DEAE6);
  static const Color navUnselected = Color(0xFF5A9490);
}

class AdminTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AdminColors.scaffoldBackground,
    colorScheme: const ColorScheme.dark(
      primary: AdminColors.primary,
      onPrimary: AdminColors.surfaceDark,
      secondary: AdminColors.secondary,
      onSecondary: AdminColors.textPrimary,
      surface: AdminColors.surface,
      onSurface: AdminColors.textPrimary,
      error: AdminColors.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AdminColors.appBarBackground,
      foregroundColor: AdminColors.textPrimary,
      elevation: 0,
      iconTheme: IconThemeData(color: AdminColors.primary),
      titleTextStyle: TextStyle(
        color: AdminColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
    cardTheme: CardThemeData(
      color: AdminColors.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AdminColors.border, width: 0.5),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AdminColors.navBackground,
      indicatorColor: AdminColors.successLight,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AdminColors.navSelected);
        }
        return const IconThemeData(color: AdminColors.navUnselected);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(color: AdminColors.navSelected, fontSize: 11);
        }
        return const TextStyle(color: AdminColors.navUnselected, fontSize: 11);
      }),
    ),
    dividerTheme: const DividerThemeData(
      color: AdminColors.border,
      thickness: 0.5,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: AdminColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        color: AdminColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(color: AdminColors.textPrimary, fontSize: 13),
      bodySmall: TextStyle(color: AdminColors.textSecondary, fontSize: 11),
      labelSmall: TextStyle(color: AdminColors.textMuted, fontSize: 10),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AdminColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AdminColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AdminColors.borderFocus,
          width: 1.5,
        ),
      ),
      hintStyle: const TextStyle(color: AdminColors.textMuted),
      labelStyle: const TextStyle(color: AdminColors.textSecondary),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AdminColors.primarySelected,
        foregroundColor: AdminColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
