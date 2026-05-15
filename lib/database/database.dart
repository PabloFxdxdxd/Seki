import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DriftDatabase(include: {'tables.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  //Funciones de la base de datos (Tienen que ser Future porque el programa necesita tiempo para hacer las consultas)

  //Validar credenciales (inicio de sesión)
  Future<UserData?> validarCredenciales(String email, String password) async {
    //Se busca un usuario que coincida ambos
    final usuario = await (select(user)
          ..where((t) => t.email.equals(email) & t.password.equals(password)))
        .getSingleOrNull();

  return usuario;
  }

  //Obtener si es administrador o usuario

  Future<bool> esAdministrador(String email) async {
    //Se busca un usuario que coincida ambos
    final usuario = await (select(user)
          ..where((t) => t.email.equals(email) & t.type.equals("admin")))
        .getSingleOrNull();
        
    if(usuario == null){
      return false;
    }else{
      return true;
    }
  }


  //Inserciones
  Future<int> insertUser(UserCompanion entry) {
    return into(user).insert(entry);
  }
  Future<int> insertActivity(ActivityCompanion entry) {
    return into(activity).insert(entry);
  }
  Future<int> insertActivityLogs(ActivityLogsCompanion entry) {
    return into(activityLogs).insert(entry);
  }

  //Getters (De toda la información)
  
  Future<List<UserData>> getAllUsers() {
    return select(user).get();
  }
  Future<List<ActivityData>> getAllActivities() {
    return select(activity).get();
  }
  Future<List<ActivityLog>> getAllActivityLogs() {
    return select(activityLogs).get();
  }

  //Para Obtener datos en vivo

  //Obtener las tareas pendientes según el id del usuario
  Stream<List<ActivityData>> verMisTareas(int userId) {
  
  final ahora = DateTime.now();
  final inicioHoy = DateTime(ahora.year, ahora.month, ahora.day);
  final finHoy = DateTime(ahora.year, ahora.month, ahora.day, 23, 59, 59);

  return (select(activity)
    ..where((t) {
      //mismo usuario y que no esté borrada
      final filtroBase = t.userId.equals(userId) & t.isActive.equals(true);

      //la fecha de entrega debe ser hoy
      final esTareaDeHoy = t.type.equals('Tarea') & 
                           t.dueDate.isBetweenValues(inicioHoy, finHoy);

    
      final esHabitoActivo = t.type.equals('Hábito');

      //Retornamos si cumple los básicos Y (es tarea de hoy O es hábito)
      return filtroBase & (esTareaDeHoy | esHabitoActivo);
    })
    //Ordenamos para que las de mayor prioridad o más próximas salgan primero
    ..orderBy([(t) => OrderingTerm.asc(t.dueDate)])
  ).watch();
}

  //Obtener las tareas terminadas según el id del usuario
  Stream<List<ActivityData>> verMisTareasTerminadas(int userId) {
    return (select(activity)..where((t) => t.userId.equals(userId) & t.isActive.equals(false))).watch();
  }

  //Modificación
  //Marcar como completada
  Future<void> marcarCompletada(int id) async {
    await (update(activity)..where((t) => t.id.equals(id))).write(ActivityCompanion(
      isActive: Value(false),
    ));
  }

  //Eliminación
  Future<void> eliminarTarea(int id) async {
    await (delete(activity)..where((t) => t.id.equals(id))).go();
  }
  
  


}


LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}