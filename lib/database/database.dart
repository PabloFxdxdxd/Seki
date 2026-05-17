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

  //Para Obtener datos en vivo

  //Obtener las tareas según el id del usuario
  Stream<List<ActivityData>> verMisTareas(int userId) {
    return (select(activity)..where((t) => t.userId.equals(userId))).watch();
  }

  //Modificación
  Future<void> marcarCompletada(int id) async {
    await (update(activity)..where((t) => t.id.equals(id))).write(ActivityCompanion(
      isActive: Value(false),
    ));
  }

  //Eliminación
  Future<void> eliminarTarea(int id) async {
    await (delete(activity)..where((t) => t.id.equals(id))).go();
  }
  

  //Dashboard - Administración

  //total de usuarios
  Future<int> totalUsuarios() async {
    final usuarios = countAll();
    final consulta = selectOnly(user)
          ..addColumns([usuarios]); //hace la consulta y sólo va a la tabla user 
    final total = await consulta.getSingle();
    return total.read(usuarios) ?? 0; //si el valor es nulo devuelve 0
  }
  
  //hábitos activos
  Future<int> habitosActivos() async {  
    final acts = countAll();
    final consulta = selectOnly(activity)
          ..addColumns([acts])
          ..where(activity.isActive.equals(true)); //toma solo las acts activas
    final result = await consulta.getSingle();
    return result.read(acts) ?? 0;
  }

  //cumplimiento global
  Future<double> cumplimientoGlobal() async {
    final registros = countAll();
    final consulta = selectOnly(activity)
          ..addColumns([registros]);
    final totalRegistros = (await consulta.getSingle()).read(registros) ?? 0;

    if (totalRegistros == 0){
      return 0.0; 
    } 
    
    final cumplidos = countAll(
      filter: activity.isActive.equals(false) //True sin terminar, False cumplida
    ); //contará solo los registros que cumplan el filtro
    final consultaCumplidos = selectOnly(activity)
          ..addColumns([cumplidos]);
    final totalCumplidos = (await consultaCumplidos.getSingle()).read(cumplidos) ?? 0;
    return (totalCumplidos / totalRegistros) * 100; //porcentaje
  }

  //registros de hoy
  Future<int> registrosHoy() async {
    final hoy = DateTime.now();
    final inicioDia = DateTime(hoy.year, hoy.month, hoy.day);
    final finDia = inicioDia.add(const Duration(days: 1));
    
    final registros = countAll();
    final consulta = selectOnly(activity)
          ..addColumns([registros])
          ..where(activity.dueDate.isBetweenValues(inicioDia, finDia)); //registros del día
    final totalRegistros = await consulta.getSingle();
    return totalRegistros.read(registros) ?? 0;
  }
  
  //usuarios por mes (para el barchart)
  Future<List<MonthlyGrowth>> usuariosPorMes() async {
    final hoy = DateTime.now();
    const meses = [
      '', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
       'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    
    final result = <MonthlyGrowth>[];

    //calcula los últimos 6 meses
    for(int i=5; i>=0; i--){
      final fecha = DateTime(hoy.year, hoy.month - i, 1);
      final sigMes = DateTime(fecha.year, fecha.month + 1, 1);

      final count = countAll();   
      final consulta = selectOnly(user)
            ..addColumns([count])
            ..where(user.createdAt.isBetweenValues(fecha, sigMes)); //usuarios del mes
      final total = await consulta.getSingle();
      result.add(MonthlyGrowth(
        mes: meses[fecha.month], 
        cantidad: total.read(count) ?? 0,
      ));
    }
    return result;
  }

  //Top 3 usuarios más activos
  Future<List<TopUser>> getTopUsers({int limit = 3}) async {
    final filas = await (select(user).join([
      leftOuterJoin(activity, activity.userId.equalsExp(user.id) & activity.isActive.equals(false)),
    ])).get();

    final Map<int, _UserLogAccum> accum = {};
    for (final fila in filas) {
      final u = fila.readTable(user);
      final a = fila.readTableOrNull(activity);
      accum.putIfAbsent(u.id, () => _UserLogAccum(name: u.name));
      if (a != null){
        accum[u.id]!.total++;
      } 
    }

    final sorted = accum.values
        .map((a) => TopUser(
              nom: a.name,
              totalReg: a.total,
              completado: 0,
            ))
        .toList()
      ..sort((a, b) => b.totalReg.compareTo(a.totalReg));

    return sorted.take(limit).toList();
  }
}

class MonthlyGrowth {
  final String mes;
  final int cantidad;
  MonthlyGrowth({required this.mes, required this.cantidad});
}

class TopUser {
  final String nom;
  final int totalReg;
  final double completado;
  TopUser({
    required this.nom,
    required this.totalReg,
    required this.completado,
  });
}


class _UserLogAccum {
  final String name;
  int total = 0;
  int completed = 0;
  _UserLogAccum({required this.name});
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}