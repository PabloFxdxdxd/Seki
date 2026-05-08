import 'package:flutter/material.dart';
import 'package:proyect_seki/database/database.dart';

//Esta es la estructura de las tarjetas que se generan en la pantalla AgendaHome
Widget itemTarea({required ActivityData tarea}) {
  
  Color colorPrioridad = tarea.priority == 'alta' ? Colors.redAccent : const Color(0xFF8DEAE6);

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(7),
      border: Border(left: BorderSide(color: colorPrioridad, width: 5)), // Borde decorativo
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
      ],
    ),
    child: Row(
      children: [
        Icon(Icons.check_circle_outline, color: colorPrioridad),
        const SizedBox(width: 15),
        Text(
          tarea.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    ),
    
  );
}

Widget containerVerdeDeFondo() {
  return Container(
    color: const Color(0xFF8DEAE6).withOpacity(0.5), // Tu color cian
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Completado", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        Icon(Icons.check, color: Colors.white),
      ],
    ),
  );
}

