import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:proyect_seki/core/Colores.dart';
import 'package:proyect_seki/core/activityItems.dart';
import 'package:proyect_seki/database/database.dart';
import 'package:proyect_seki/main.dart';
import 'package:proyect_seki/pantallas/usuario/FormActividad.dart'; // Importante para el botón +

class AgendaCalendario extends StatefulWidget {
  const AgendaCalendario({Key? key}) : super(key: key);

  @override
  State<AgendaCalendario> createState() => _AgendaCalendarioState();
}

class _AgendaCalendarioState extends State<AgendaCalendario> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  //LÓGICA PARA FECHAS PASADAS 
  bool _esFechaPasada(DateTime fecha) {
    final hoy = DateTime.now();
    final fechaHoy = DateTime(hoy.year, hoy.month, hoy.day);
    final fechaSeleccionada = DateTime(fecha.year, fecha.month, fecha.day);
    return fechaSeleccionada.isBefore(fechaHoy); // Retorna true si es antes de hoy
  }

  // LOGICA PARA REPETIR HÁBITOS Y MARCAR FECHAS
  Map<DateTime, List<ActivityData>> _agruparEventos(List<ActivityData> actividades) {
    Map<DateTime, List<ActivityData>> eventos = {};

    for (var act in actividades) {
      if (act.type == 'Tarea' || act.type == 'Task') {
        if (act.dueDate != null) {
          DateTime fecha = DateTime(act.dueDate!.year, act.dueDate!.month, act.dueDate!.day);
          if (eventos[fecha] == null) eventos[fecha] = [];
          eventos[fecha]!.add(act);
        }
      } else if (act.type == 'Hábito' || act.type == 'Habit') {
        DateTime inicio = act.startDate ?? DateTime.now();
        DateTime fin = act.dueDate ?? DateTime.now().add(const Duration(days: 365)); 
        
        DateTime actual = DateTime(inicio.year, inicio.month, inicio.day);
        DateTime fechaFin = DateTime(fin.year, fin.month, fin.day);
        String frec = act.frequency?.toLowerCase() ?? 'diario';

        while (actual.isBefore(fechaFin) || actual.isAtSameMomentAs(fechaFin)) {
          if (eventos[actual] == null) eventos[actual] = [];
          eventos[actual]!.add(act);
          
          if (frec == 'semanal' || frec == 'weekly') {
            actual = actual.add(const Duration(days: 7));
          } else if (frec == 'mensual' || frec == 'monthly') {
            actual = DateTime(actual.year, actual.month + 1, actual.day);
          } else {
            actual = actual.add(const Duration(days: 1));
          }
        }
      }
    }
    return eventos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.background,
      appBar: AppBar(
        title: const Text("Calendario", style: TextStyle(color: Colores.secondary, fontWeight: FontWeight.bold)),
        backgroundColor: Colores.background,
        elevation: 0,
        centerTitle: true,
      ),
      
      body: StreamBuilder<List<ActivityData>>(
        stream: globalDatabase.verTodasMisActividades(currentUser?.id ?? 0),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final actividades = snapshot.data ?? [];
          final eventosPorDia = _agruparEventos(actividades);
          
          DateTime diaNormalizado = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
          List<ActivityData> tareasDelDia = eventosPorDia[diaNormalizado] ?? [];

          //FILTRO DE ORDEN CRONOLÓGICO PARA EL CALENDARIO
          tareasDelDia.sort((a, b) {
            DateTime horaA = a.dueDate ?? a.reminderTime ?? DateTime.now();
            DateTime horaB = b.dueDate ?? b.reminderTime ?? DateTime.now();
            return horaA.compareTo(horaB);
          });

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colores.primaryTransparente, 
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.only(bottom: 16),
                child: TableCalendar(
                  locale: 'es_ES',
                  firstDay: DateTime.utc(2025, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() => _calendarFormat = format);
                  },
                  eventLoader: (day) {
                    return eventosPorDia[DateTime(day.year, day.month, day.day)] ?? [];
                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(color: Colores.secondary, fontSize: 18, fontWeight: FontWeight.bold),
                    leftChevronIcon: Icon(Icons.chevron_left, color: Colores.secondary),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Colores.secondary),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colores.secondary, fontWeight: FontWeight.bold),
                    weekendStyle: TextStyle(color: Colores.secondary, fontWeight: FontWeight.bold),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: Colores.secondary, fontWeight: FontWeight.w600),
                    weekendTextStyle: const TextStyle(color: Colores.secondary, fontWeight: FontWeight.w600),
                    outsideDaysVisible: false,
                    selectedDecoration: const BoxDecoration(
                      color: Colores.secondary, 
                      shape: BoxShape.circle, 
                    ),
                    selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    todayDecoration: BoxDecoration(
                      color: Colores.secondary.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: const TextStyle(color: Colores.secondary, fontWeight: FontWeight.bold),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) return const SizedBox();
                      return Positioned(
                        bottom: 6,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: events.take(4).map((event) {
                            bool esHabito = (event as ActivityData).type == 'Hábito' || event.type == 'Habit';
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1.5),
                              width: 12, 
                              height: 5, 
                              decoration: BoxDecoration(
                                color: esHabito ? const Color.fromARGB(255, 247, 172, 149) : const Color.fromARGB(255, 244, 183, 243), 
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colores.background,
                  child: tareasDelDia.isEmpty 
                    ? const Center(
                        child: Text("No hay eventos", style: TextStyle(fontSize: 18, color: Colores.textSecondary, fontWeight: FontWeight.bold)),
                      )
                    : ListView.builder(
                        itemCount: tareasDelDia.length,
                        itemBuilder: (context, index) {
                          return itemTarea(context: context, tarea: tareasDelDia[index]);
                        },
                      ),
                ),
              ),
            ],
          );
        },
      ),

      //BOTÓN FLOTANTE CON VALIDACIÓN DE FECHA
      floatingActionButton: _selectedDay != null && _esFechaPasada(_selectedDay!)
          ? null // Si la fecha es pasada, se oculta (es null)
          : Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                width: 60,
                height: 60,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FormActividad()),
                    );
                  }, 
                  backgroundColor: Colores.primary,
                  focusColor: Colores.secondary,
                  child: const Icon(Icons.add, color: Colores.iconBackground, size: 40)
                ),
              ),
            ),
      
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colores.surface,
        selectedItemColor: Colores.primary,
        unselectedItemColor: Colores.iconNormal,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        currentIndex: 1, 
        onTap: (index) {
          if (index == 1) return;
          if (index == 0) Navigator.pushReplacementNamed(context, '/agendaHome');
          if (index == 2) Navigator.pushReplacementNamed(context, '/agendaHistorial');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Calendario'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Historial'),
        ],
      ),
    );
  }
}