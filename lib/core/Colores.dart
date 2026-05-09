import 'dart:ui';
import 'package:flutter/material.dart';

class Colores {

  //PALETA PRINCIPAL
  static const Color primary = Color(0xFF8DEAE6);      // Color principal de la app
  static const Color primaryTransparente = Color(0x808DEAE6);
  static const Color secondary = Color(0xFF34716E);    // Detalles oscuros, barras, etc.
  static const Color secondaryTransparente = Color.fromARGB(128, 85, 162, 158);    // Detalles oscuros, barras, etc.

  static const Color accent = Color(0xFFFF8A65);       // Acentos llamativos


  //FONDOS Y SUPERFICIES (Scaffolds, Tarjetas, Modales)
  static const Color background = Color(0xFFF5F5F6);   // Fondo general de la app (Scaffold)
  static const Color surface = Colors.white;           // Fondo de tarjetas, contenedores, modales
  static const Color surfaceSelected = Color(0xFF27A49E); // Fondo cuando un elemento está seleccionado


  //TEXTOS E ICONOS
  static const Color textPrimary = Color(0xFF212121);  // Títulos y textos principales
  static const Color textSecondary = Colors.grey;      // Subtítulos o textos menos importantes
  static const Color iconNormal = Colors.grey;         // Color de iconos inactivos o genéricos
  static const Color iconBackground = Color(0xFFEEEEEE); // Fondo circular para iconos


  //ESTADOS Y PRIORIDADES (Alertas, Éxito, Errores)
  static const Color error = Color(0xFFE53935);        // Mensajes de error o validaciones
  static const Color prioridadAlta = Colors.redAccent; // Borde o tag de tareas urgentes
  static const Color prioridadMedia = Colors.orangeAccent; // Borde o tag de tareas de media prioridad
  static const Color prioridadBaja = Colors.greenAccent; // Borde o tag de tareas de baja prioridad


  //BOTONES Y COMPONENTES ESPECÍFICOS
  static const Color googleButton = Color.fromARGB(255, 222, 127, 119); // Botón de Google
  static const Color sombra = Color(0x0D000000);       // Sombras de tarjetas o botones
  }