import 'package:flutter/material.dart';
import 'package:proyect_seki/core/Colores.dart';

class AgendaHistorial extends StatelessWidget {
  const AgendaHistorial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.background,
      appBar: AppBar(
        title: const Text("Historial", style: TextStyle(color: Colores.textPrimary)),
        backgroundColor: Colores.primary,
        iconTheme: const IconThemeData(color: Colores.textPrimary),
      ),
      body: const Center(
        child: Text("Pantalla de Historial Proximamente en la VERSIÓN 2.0   :)", 
          style: TextStyle(fontSize: 18, color: Colores.textPrimary)),
      ),
       bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colores.surface,
        selectedItemColor: Colores.primary, // El ícono activo en color cian
        unselectedItemColor: Colores.iconNormal, // Los íconos inactivos en gris
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        currentIndex: 2, // El 2 indica que se esta en la tercera pestaña (Historial)
        onTap: (index) {
          if (index == 2) return; // Ya se esta en Historial, no se hace nada
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/agendaHome');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/agendaCalendario');
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