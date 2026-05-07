import 'package:flutter/material.dart';
import 'package:proyect_seki/core/Colores.dart';
import 'package:proyect_seki/core/Fecha.dart';
import 'package:proyect_seki/core/activityItems.dart';
import 'package:proyect_seki/database/database.dart'; //Donde están las funciones de la base de datos
import 'package:drift/drift.dart' as d;
import 'package:proyect_seki/main.dart';

class AgendaHome extends StatefulWidget {
  const AgendaHome({super.key});
 

  @override
  State<AgendaHome> createState() => _AgendaHomeState();

}

class _AgendaHomeState extends State<AgendaHome> {


  //-----------------Backend--------------------

  //Se definen las funciones para trabajar con la base de datos

  //--Esta es de ejemplo (Eliminar cuando se acabe la decoración)--
  void insertar(){
    globalDatabase.insertActivity(
                  ActivityCompanion(
                    type: d.Value("Task"),
                    userId: d.Value(currentUser!.id),
                    title: d.Value("Pasear a Canas"),
                    details: d.Value("Por las mañanas se deberá pasear a Canas"),
                    priority: d.Value("alta"),
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

  void irADetalle(ActivityData tarea) {
    //Por ahora solo imprimimos para testear, luego se podrá navegar
    print("Navegando a la tarea: ${tarea.title}");
    //Navigator.pushNamed(context, '/TareaDetalles');
  }

  //-----------------Frontend--------------------

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colores.backgroundClear,
      //Menú superior
      appBar: AppBar(
        title:Row(
          children:[
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 20,
              child: Icon(
                Icons.person_outline, 
                color: Colors.grey,
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
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(onPressed: (){},child: Text("Pendientes"))
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(onPressed: (){},child: Text("Completados"))
              )
            ],),

            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text("Hoy ${Fecha.obtenerFecha()} "),
            ),
            Container(
              width: 300,
              height: 500,
              color: Colores.secondary,

              child: StreamBuilder<List<ActivityData>>(
                      stream: globalDatabase.verMisTareas(currentUser!.id),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const CircularProgressIndicator();
                        
                        final tareas = snapshot.data!;

                        return ListView.builder(
                          itemCount: tareas.length,
                          itemBuilder: (context, index) {
                            final tarea = tareas[index];

                            //Este widget permite que el elemento se deslize
                            return Dismissible(
                              key: Key(tarea.id.toString()),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) => globalDatabase.marcarCompletada(tarea.id),
                              background: containerVerdeDeFondo(),
                              
                              //Para que detecte cuando se mantiene presionado
                              child: GestureDetector(  
                                onLongPress: () => mostrarOpcionEliminar(tarea.id),
                                onTap: () => irADetalle(tarea),
                                
                                // La decoración de la tarea: /core/activityItems.dart
                                child: itemTarea(tarea: tarea),
                              ),
                            );
                          },
                        );
                      },
                    ),

            ),
            //--Esta es de ejemplo (Eliminar cuando se acabe la decoración)--
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ElevatedButton(onPressed: insertar, child: Text("Insertar Ejemplo")),
            ),
            
          ]
          ,)

      ),

      

      floatingActionButton: FloatingActionButton(onPressed: insertar, child: Icon(Icons.new_label)),
       
    );
  }
 
}