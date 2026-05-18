import 'package:flutter/material.dart';
import 'package:proyect_seki/core/Colores.dart';
import 'package:proyect_seki/core/Fecha.dart';
import 'package:proyect_seki/core/activityItemsCompleted.dart';
import 'package:proyect_seki/database/database.dart'; //Donde están las funciones de la base de datos
import 'package:drift/drift.dart' as d;
import 'package:proyect_seki/main.dart';
import 'package:proyect_seki/pantallas/usuario/FormActividad.dart';

class AgendaHomeCompleted extends StatefulWidget {
  const AgendaHomeCompleted({super.key});
 

  @override
  State<AgendaHomeCompleted> createState() => _AgendaHomeCompletedState();

}

class _AgendaHomeCompletedState extends State<AgendaHomeCompleted> {


  //-----------------Backend--------------------

  //Se definen las funciones para trabajar con la base de datos

  //--Esta es de ejemplo (Eliminar cuando se acabe la decoración)--
  void insertar(){
    globalDatabase.insertActivity(
                  ActivityCompanion(
                    type: d.Value("Task"),
                    //userId: d.Value(currentUser!.id), 
                    userId: d.Value(currentUser?.id ?? 0), // //si es nulo le pasamos un id por defecto (0) para que no tire error, pero debería ser el id del usuario logueado
                    title: d.Value("Leer"),
                    details: d.Value("Leer un capitulo de un libro"),
                    priority: d.Value("baja"),
                    startDate: d.Value(DateTime.now()),
                    dueDate: d.Value(DateTime(2026, 10, 15, 10, 30)),
                    frequency: d.Value("weekly"),
                    reminderTime: d.Value(DateTime(2026, 9, 15, 10, 30)),
                    isActive: d.Value(true),
                    createdAt: d.Value(DateTime.now()),

                  
                  )
                );

                print("Tarea Insertada");
  }

    void mostrarOpcionEliminar(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar tarea"),
        content: const Text("¿Estás seguro de que quieres borrar esta actividad?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(
            onPressed: () {
              globalDatabase.eliminarTarea(id); //Función de eliminación
              Navigator.pop(context);
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void navegarPendientes(){
    Navigator.pushNamed(context, '/agendaHome');
  }

  //-----------------Frontend--------------------

  void irADetalle(ActivityData tarea) {
    //Por ahora solo imprimimos para testear, luego se podrá navegar
    print("Navegando a la tarea: ${tarea.title}");
    //Navigator.pushNamed(context, '/TareaDetalles');
  }

  //-----------------Frontend--------------------

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colores.background,
      //Menú superior
      appBar: AppBar(
        title:Row(
          children:[
            CircleAvatar(
              backgroundColor: Colores.iconBackground,
              radius: 20,
              child: Icon(
                Icons.person_outline, 
                color: Colores.iconNormal,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("¡Hola, ${currentUser?.name}!", maxLines:1, overflow: TextOverflow.ellipsis)
            )
          ]
        )
      ),
      
      body: Center(
          //seccion de botones pendientes/completados y fecha
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: navegarPendientes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colores.surface, //Fondo color cian
                        foregroundColor: Colores.secondary, // Color del texto
                        elevation: 0, 
                        side: BorderSide(color: Colores.secondary, width: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Pendientes",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colores.primaryTransparente, // Fondo blanco no seleccionado
                        foregroundColor: Colores.secondary, 
                        elevation: 0, 
                        side: BorderSide(color: Colores.secondary, width: 2), 
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Completados",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
        
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 15),
                  child: Text(
                      Fecha.obtenerFecha(),
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold, 
                      color: Colores.textPrimary
                    )
                  ),
                ),
              
              Expanded(
                child: Container(
                  width: 350,
                  color: Colores.secondaryTransparente,
                  child: StreamBuilder<List<ActivityData>>(
                          //si es nulo le pasamos un id por defecto (0) para que no tire error, pero debería ser el id del usuario logueado
                          stream: globalDatabase.verMisTareasTerminadas(currentUser!.id),
                          //stream: globalDatabase.verMisTareas(currentUser?.id ?? 0), 
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const CircularProgressIndicator();
                            
                            final tareas = snapshot.data!;
                          
                            return ListView.builder(
                              itemCount: tareas.length,
                              itemBuilder: (context, index) {
                                final tarea = tareas[index];
                                //Para que detecte cuando se mantiene presionado
                                return GestureDetector(  
                                  onLongPress: () => mostrarOpcionEliminar(tarea.id),
                                  onTap: () => irADetalle(tarea),
                                  
                                  // La decoración de la tarea: /core/activityItems.dart
                                  child: itemTareaCompleted(context: context, tarea: tarea),
                                );
                              },
                            );
                          },
                        ),
                          
                ),
              ),
            ]
            ,),

      ),

    //Botón de agregar nueva actividad
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: SizedBox(
          width: 60,
          height: 60,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormActividad()), //Navega al formulario de actividad sin datos para crear una nueva tarea
              );
            }, 
            backgroundColor: Colores.primary,
            focusColor: Colores.secondary,
            child: const Icon(Icons.add, color: Colores.iconBackground, size: 40)
            ),
        ),
      ),

      //Menú inferior
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colores.surface,
        selectedItemColor: Colores.primary, // El ícono activo en color cian
        unselectedItemColor: Colores.iconNormal, // Los íconos inactivos en gris
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        currentIndex: 0, // El 0 indica que se esta en la primera pestaña
        onTap: (index) {
          if (index == 0) return; // Ya se esta en Agenda, no se hace nada
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/agendaCalendario');
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