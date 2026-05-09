import 'package:flutter/material.dart';
import 'package:proyect_seki/database/database.dart';
import 'package:proyect_seki/core/Colores.dart';
import 'package:intl/intl.dart'; //para formatear fechas

//Esta es la estructura de las tarjetas que se generan en la pantalla AgendaHome
Widget itemTarea({required ActivityData tarea}) {
  
  //logica para el color pastel izquierdo 
  final List<Color> coloresPastel = [
    const Color(0xFFFFB3BA), 
    const Color(0xFFFFDFBA),
    const Color(0xFFFFFFBA),
    const Color(0xFFBAFFC9), 
    const Color(0xFFBAE1FF),
    const Color(0xFFE2CBF7),
  ];
  //toma el ID para que sea el mismo color para la misma tarea
  Color colorBorde = coloresPastel[tarea.id % coloresPastel.length];

  //logica para la prioridad parte izquierda
  Color colorPrioridad;
  String textoPrioridad;

  switch (tarea.priority?.toLowerCase()) {
    case 'alta':
      colorPrioridad = Colores.prioridadAlta; // Rojo
      textoPrioridad = 'Alta';
      break;
    case 'media':
      colorPrioridad = Colores.prioridadMedia; // Naranja
      textoPrioridad = 'Media';
      break;
    case 'baja':
    default:
      colorPrioridad = Colores.prioridadBaja; // Verde
      textoPrioridad = 'Baja';
      break;
  }
  
  // 2. Formateo de fechas
  String fechaVencimiento = tarea.dueDate != null 
      ? DateFormat('dd MMM, hh:mm a').format(tarea.dueDate!) 
      : "Sin fecha";
  String fechaRecordatorio = tarea.reminderTime != null 
      ? DateFormat('hh:mm a').format(tarea.reminderTime!) 
      : "Sin aviso";

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colores.surface,
      borderRadius: BorderRadius.circular(15),
      border: Border(left: BorderSide(color: colorBorde, width: 8)), // Borde decorativo izq
      boxShadow: const [
        BoxShadow(color: Colores.sombra, blurRadius: 10, offset: Offset(0, 4)),
      ],
    ),
    child: Row(
      children: [
        //icono de tarea de la izquierda
        const Icon(Icons.notifications_none, color: Colores.textSecondary),
        const SizedBox(width: 12),

        //Texto de la tarea
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tarea.type ?? "Actividad", 
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colores.textSecondary, fontSize: 12)),
              Text(tarea.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colores.textPrimary)),
              const SizedBox(height: 6),
              if (tarea.priority != null) ...[
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 12, color: Colores.textSecondary),
                    const SizedBox(width: 4),
                    Text(fechaVencimiento, style: const TextStyle(fontSize: 12, color: Colores.textSecondary)),
                    const SizedBox(width: 10),
                    const Icon(Icons.access_time, size: 12, color: Colores.textSecondary),
                    const SizedBox(width: 4),
                    Text(fechaRecordatorio, style: const TextStyle(fontSize: 12, color: Colores.textSecondary)),
                  ],
                ),
              ],
            ],
          ),
        ),

        //Prioridad y Botón de Editar
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Cápsula de prioridad
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colorPrioridad.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorPrioridad, width: 1),
              ),
              child: Text(textoPrioridad,
                style: TextStyle(color: colorPrioridad, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            const SizedBox(height: 8),
            
            //Botón de Lápiz para Editar
            IconButton(
              constraints: const BoxConstraints(), 
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.edit_outlined, color: Colores.secondary, size: 26),
              onPressed: () {
                //Por ahora solo imprime en consola
                print("Editando actividad: ${tarea.id}");
              },
            ),
          ],
        ),
      ],
    ),
  );
}

// Este es un contenedor verde que se muestra cuando una tarea está marcada como completada
Widget containerVerdeDeFondo() {
  return Container(
    color: Colores.primaryTransparente,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Completado", style: TextStyle(color: Colores.background, fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        Icon(Icons.check, color: Colores.background),
      ],
    ),
  );
}