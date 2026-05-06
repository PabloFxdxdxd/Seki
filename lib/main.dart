import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:proyect_seki/database/database.dart';
import 'package:drift/drift.dart' as d;

//Importación de pantallas

import 'package:proyect_seki/pantallas/Login.dart';
import 'package:proyect_seki/pantallas/pantallaEjemplo.dart';
import 'package:proyect_seki/pantallas/SignIn.dart';

late AppDatabase globalDatabase;


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
        '/signin': (context) => PantallaRegistro(),
        '/ejemplo': (context) => PantallaEjemplo()
      },
    );
  }
}



