import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path/path.dart';
import 'package:proyect_seki/core/Colores.dart';
import 'package:proyect_seki/database/database.dart';

//Importación de pantallas

import 'package:proyect_seki/pantallas/Login.dart';
import 'package:proyect_seki/pantallas/admins/adminReg.dart';
import 'package:proyect_seki/pantallas/admins/dashboard.dart';
import 'package:proyect_seki/pantallas/pantallaEjemplo.dart';
import 'package:proyect_seki/pantallas/usuario/AgendaHome.dart';
import 'package:proyect_seki/pantallas/SignIn.dart';

late AppDatabase globalDatabase;
UserData? currentUser;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  globalDatabase = AppDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SEKI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8DEAE6)),
      ),
      // 3. Definimos la navegación por nombres
      initialRoute: '/', // La ruta que carga al abrir la app
      routes: {
        '/': (context) => PantallaLogin(),
        '/agendaHome': (context) => AgendaHome(),
        '/signin': (context) => PantallaRegistro(),
        '/ejemplo': (context) => PantallaEjemplo(),
        '/admin': (context) => PantallaDashboard(),
        '/adminReg': (context) => PantallaAdminRegistro(),
      },
    );
  }
}
