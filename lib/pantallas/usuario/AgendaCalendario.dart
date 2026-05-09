import 'package:flutter/material.dart';
import 'package:proyect_seki/core/Colores.dart';

class AgendaCalendario extends StatelessWidget {
  const AgendaCalendario({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.background,
      appBar: AppBar(
        title: const Text("Calendario", style: TextStyle(color: Colores.textPrimary)),
        backgroundColor: Colores.primary,
        iconTheme: const IconThemeData(color: Colores.textPrimary),
      ),

      body: const Center(
        child: Text("Pantalla de Calendario", 
          style: TextStyle(fontSize: 18, color: Colores.textPrimary)),
      ),

      
       bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colores.surface,
        selectedItemColor: Colores.primary, // El ícono activo en color cian
        unselectedItemColor: Colores.iconNormal, // Los íconos inactivos en gris
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        currentIndex: 1, // El 1 indica que se esta en la segunda pestaña (Calendario)
        onTap: (index) {
          if (index == 1) return; // Ya se esta en Calendario, no se hace nada
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/agendaHome');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/agendaHistorial');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined), //icono de agenda
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined), //icono de calendario
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined), // icono de historial
            label: 'Historial',
          ),
        ],
      ),
    );
  }
}