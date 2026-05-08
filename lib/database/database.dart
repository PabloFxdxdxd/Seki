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

  //Detectar si existe el email

  Future<bool> existeEmail(String email) async {
    final usuario = await (select(user)
          ..where((t) => t.email.equals(email)))
        .getSingleOrNull();
        
    if(usuario == null){
      return false;
    }else{
      return true;
    }
  }



  


}


LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}