import 'package:flutter/material.dart';
import 'package:proyect_seki/core/Fecha.dart';

import 'package:proyect_seki/core/adminTheme.dart';
import 'package:proyect_seki/database/database.dart'; //Donde están las funciones de la base de datos
import 'package:drift/drift.dart' as d;
import 'package:proyect_seki/pantallas/admins/barchart.dart';

class PantallaDashboard extends StatefulWidget {
  @override
  State<PantallaDashboard> createState() => _PantallaDashboardState();
}

class _PantallaDashboardState extends State<PantallaDashboard> {
  //-----------------Backend--------------------

  //Se definen las funciones para trabajar con la base de datos

  void insertar() {
    print("Usuario Insertado");
  }

  void eliminar() {
    print("Usuario Eliminado");
  }

  final _db = AppDatabase();

  late Future<int> _totalUsuarios;
  late Future<int> _habitosActivos;
  late Future<double> _cumplimiento;
  late Future<int> _registrosHoy;
  late Future<List<MonthlyGrowth>> _usuariosPorMes;
  late Future<List<TopUser>> _topUsuarios;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() {
    _totalUsuarios = _db.totalUsuarios();
    _habitosActivos = _db.habitosActivos();
    _cumplimiento = _db.cumplimientoGlobal();
    _registrosHoy = _db.registrosHoy();
    _usuariosPorMes = _db.usuariosPorMes();
    _topUsuarios = _db.getTopUsers();
  }

  @override
  //cierra la base de datos al salir de la pantalla para liberar recursos
  void dispose() {
    _db.close();
    super.dispose();
  }

  //-----------------Frontend--------------------

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AdminTheme.theme,
      child: Scaffold(
        //barra inferior
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: "Registro de Administradores",
            ),
          ],
          currentIndex: 0,
          onTap: (index) {
            //navegación entre secciones del admin
            if (index == 1) {
              Navigator.pushReplacementNamed(context, '/adminReg');
            }
          },
        ),
        //barra superior
        appBar: AppBar(
          title: const Text("Panel de Adminsitración"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => setState(
                () => _cargarDatos(),
              ), //recarga los datos al presionar el botón
            ),
          ],
        ),

        body: RefreshIndicator(
          onRefresh: () async => setState(
            () => _cargarDatos(),
          ), //permite recargar los datos al hacer pull-to-refresh
          child: Center(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                //4 bloques / body
                children: [
                  SizedBox(height: 20),
                  //Tíulo
                  Text(
                    "Dashboard",
                    style: AdminTheme.theme.textTheme.titleLarge,
                  ),
                  Text(
                    Fecha.obtenerFecha(),
                    style: AdminTheme.theme.textTheme.titleMedium,
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(5.0),
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    children: [
                      //Numero de usuarios
                      Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        child: FutureBuilder<int>(
                          future: _totalUsuarios,
                          builder: (context, snap) => Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  //Alineado a la izq
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Total de usuarios",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: AdminColors.textPrimary,
                                        ),
                                        textAlign: TextAlign.center,
                                        snap.hasData
                                            ? '${snap.data}'
                                            : snap.hasError
                                            ? 'Error'
                                            : '...',
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "registrados en la app",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AdminColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //Derecha / icono
                                Icon(
                                  Icons.people_outline,
                                  size: 65,
                                  color: AdminColors.secondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //Habitos activos
                      Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),

                        child: FutureBuilder<int>(
                          future: _habitosActivos,
                          builder: (context, snap) => Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  //Alineado a la izq
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Hábitos activos",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: AdminColors.textPrimary,
                                        ),
                                        textAlign: TextAlign.center,
                                        snap.hasData
                                            ? '${snap.data}'
                                            : snap.hasError
                                            ? 'Error'
                                            : '...',
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "en total",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AdminColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //Derecha / icono
                                Icon(
                                  Icons.check_box_outlined,
                                  size: 65,
                                  color: AdminColors.secondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //Cumplimiento
                      Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        child: FutureBuilder<double>(
                          future: _cumplimiento,
                          builder: (context, snap) => Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  //Alineado a la izq
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Cumplimiento global",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: AdminColors.textPrimary,
                                        ),
                                        textAlign: TextAlign.center,
                                        snap.hasData
                                            ? '${snap.data!.toStringAsFixed(1)}%'
                                            : snap.hasError
                                            ? 'Error'
                                            : '...',
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "de hábitos cumplidos",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AdminColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //Derecha / icono
                                Icon(
                                  Icons.trending_up,
                                  size: 65,
                                  color: AdminColors.secondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //Logs
                      Card(
                        child: FutureBuilder<int>(
                          future: _registrosHoy,
                          builder: (context, snap) => Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  //Alineado a la izq
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Registros de hoy",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: AdminColors.textPrimary,
                                        ),
                                        textAlign: TextAlign.center,
                                        snap.hasData
                                            ? '${snap.data}'
                                            : snap.hasError
                                            ? 'Error'
                                            : '...',
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "hábitos registrados hoy",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AdminColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //Derecha / icono
                                Icon(
                                  Icons.today_outlined,
                                  size: 65,
                                  color: AdminColors.secondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //Barras / crecimiento mensual
                  FutureBuilder<List<MonthlyGrowth>>(
                    future: _usuariosPorMes,
                    builder: (context, snap) {
                      return Card(
                        child: Column(
                          children: [
                            const ListTile(
                              title: Text("Crecimiento mensual"),
                              subtitle: Text(
                                "Últimos 6 meses",
                              ), //Barras de cada mes
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: snap.hasData
                                  ? GrowthBarChart(
                                      monthlyData: snap.data!
                                          .map((e) => e.cantidad)
                                          .toList(),
                                      monthLabels: snap.data!
                                          .map((e) => e.mes)
                                          .toList(),
                                    )
                                  : snap.hasError
                                  ? const Text(
                                      "Error al cargar",
                                      style: TextStyle(color: Colors.red),
                                    )
                                  : const SizedBox(
                                      height: 160,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  //Top usuarios
                  FutureBuilder<List<TopUser>>(
                    future: _topUsuarios,
                    builder: (context, snap) {
                      return Card(
                        child: snap.hasData
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const ListTile(
                                    title: Text("Top usuarios activos"),
                                  ),
                                  ...snap.data!.map(
                                    (u) => ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.deepOrange,
                                        child: Text(
                                          u.nom.substring(0, 1).toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      title: Text(u.nom),
                                      trailing: Text(
                                        '${u.totalReg} hábitos',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              )
                            : snap.hasError
                            ? const ListTile(
                                leading: Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                                title: Text("Error al cargar"),
                              )
                            : const SizedBox(
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
