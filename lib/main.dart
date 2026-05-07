import 'package:flutter/material.dart';
import 'package:proyect_seki/database/database.dart';


//Importación de pantallas

import 'package:proyect_seki/pantallas/Login.dart';
import 'package:proyect_seki/pantallas/pantallaEjemplo.dart';
import 'package:proyect_seki/pantallas/usuario/AgendaHome.dart';


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
        '/ejemplo': (context) => PantallaEjemplo(),
        '/agendaHome': (context) => AgendaHome()
      },
    );
  }
}



