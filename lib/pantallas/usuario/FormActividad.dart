import 'package:flutter/material.dart';
import 'package:proyect_seki/core/Colores.dart';
import 'package:proyect_seki/database/database.dart';
import 'package:intl/intl.dart';
import 'package:proyect_seki/main.dart'; // Para acceder a globalDatabase y currentUser
import 'package:drift/drift.dart' as d; // Para usar d.Value()


class FormActividad extends StatefulWidget {
  final ActivityData? actividad; // Si es null es crear, si tiene datos es editar

  const FormActividad({Key? key, this.actividad}) : super(key: key);

  @override
  State<FormActividad> createState() => _FormActividadState();
}

class _FormActividadState extends State<FormActividad> {
  // Variables para manejar el formulario
  String tipoActividad = 'Tarea'; // Tarea o Hábito
  
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController detallesController = TextEditingController();
  
  // Variables Tarea
  bool tieneFechaEntrega = false;
  DateTime? fechaEntrega;
  TimeOfDay? horaEntrega;
  String prioridad = 'Media';
  
  // Variables Hábito
  String frecuencia = 'Diario'; // Diario, Semanal, Mensual
  bool tieneFechaFin = false;
  DateTime? fechaFin;
  
  // Variables Compartidas
  bool tieneRecordatorio = false;
  DateTime? fechaRecordatorio;
  TimeOfDay? horaRecordatorio;

  @override
  void initState() {
    super.initState();
    // Si recibimos una actividad (Modo Edición), llenamos los campos
    if (widget.actividad != null) {
      final act = widget.actividad!;
      tipoActividad = act.type == 'Habit' ? 'Hábito' : 'Tarea';
      nombreController.text = act.title;
      detallesController.text = act.details ?? '';
      prioridad = act.priority != null ? _capitalizar(act.priority!) : 'Media';
      
      if (act.dueDate != null) {
        tieneFechaEntrega = true;
        fechaEntrega = act.dueDate;
        horaEntrega = TimeOfDay.fromDateTime(act.dueDate!);
      }
      if (act.reminderTime != null) {
        tieneRecordatorio = true;
        fechaRecordatorio = act.reminderTime;
        horaRecordatorio = TimeOfDay.fromDateTime(act.reminderTime!);
      }
      // Configura más variables de acuerdo a la base de datos, como frecuencia para hábitos, fecha de fin, etc.
    }
  }
  // Colócala al final de tu clase _NuevaActividadState, antes de la última llave }
  DateTime? _combinarFechaHora(DateTime? fecha, TimeOfDay? hora) {
    // Si no hay fecha, no hay nada que combinar
    if (fecha == null) return null;

    // Si hay fecha pero no hay hora, devolvemos la fecha a las 00:00 (medianoche)
    if (hora == null) {
      return DateTime(fecha.year, fecha.month, fecha.day);
    }

    // Si están ambos, los combinamos
    return DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      hora.hour,
      hora.minute,
    );
  }
 
 // Método auxiliar para capitalizar la prioridad (Alta, Media, Baja)
  String _capitalizar(String texto) => texto[0].toUpperCase() + texto.substring(1);

  // Limpieza de controladores para evitar fugas de memoria
  @override
  void dispose() {
    nombreController.dispose();
    detallesController.dispose();
    super.dispose();
  }

  // Metodo para mostrar el formulario de fecha y hora, reutilizable para fecha de entrega, recordatorio, etc
  Future<void> _seleccionarFecha(BuildContext context, Function(DateTime) onSeleccionado) async {
    final DateTime? seleccion = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colores.secondary, // Color de encabezado
              onPrimary: Colors.white, // Texto en encabezado
              onSurface: Colores.textPrimary, // Texto de los días
            ),
          ),
          child: child!,
        );
      },
    );
    if (seleccion != null) onSeleccionado(seleccion);
  }
  
  // Método para mostrar el selector de hora
  Future<void> _seleccionarHora(BuildContext context, Function(TimeOfDay) onSeleccionado) async {
    final TimeOfDay? seleccion = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colores.secondary),
          ),
          child: child!,
        );
      },
    );
    if (seleccion != null) onSeleccionado(seleccion);
  }

  // Método para guardar la actividad (crear o actualizar según el caso)
void _guardarActividad() {
    //VALIDACIÓN
    if (nombreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un nombre')),
      );
      return;
    }

    //PREPARAR FECHAS
    // Combinamos las fechas y horas seleccionadas
    DateTime? finalDueDate = _combinarFechaHora(
      tipoActividad == 'Tarea' ? fechaEntrega : fechaFin, 
      tipoActividad == 'Tarea' ? horaEntrega : null,
    );
    DateTime? finalReminder = _combinarFechaHora(fechaRecordatorio, horaRecordatorio);

    //CREAR LA VARIABLE COMPANION
    // Construimos el objeto para Drift usando los valores en español directamente
    final companion = ActivityCompanion(
      type: d.Value(tipoActividad), // Guarda "Tarea" o "Hábito"
      userId: d.Value(currentUser?.id ?? 0),
      title: d.Value(nombreController.text),
      details: d.Value(detallesController.text.isEmpty ? null : detallesController.text),
      priority: d.Value(prioridad.toLowerCase()), // Guarda "alta", "media" o "baja"
      startDate: d.Value(DateTime.now()), 
      dueDate: finalDueDate != null ? d.Value(finalDueDate) : const d.Value.absent(),
      frequency: tipoActividad == 'Hábito' ? d.Value(frecuencia) : const d.Value.absent(), 
      reminderTime: finalReminder != null ? d.Value(finalReminder) : const d.Value.absent(),
      isActive: const d.Value(true),
      createdAt: d.Value(DateTime.now()),
    );

    //GUARDAR EN BASE DE DATOS
    // Ahora sí ejecutamos la inserción o actualización, porque 'companion' ya existe
    if (widget.actividad == null) {
      // MODO CREAR
      globalDatabase.insertActivity(companion);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actividad creada exitosamente')),
      );
    } else {
      // MODO EDITAR
      globalDatabase.updateActivity(
        companion.copyWith(id: d.Value(widget.actividad!.id))
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actividad actualizada exitosamente')),
      );
    }

    // 5. REGRESAR A LA PANTALLA PRINCIPAL
    Navigator.pop(context);
  }

  //DISEÑO DE LA INTERFAZ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.background,
      appBar: AppBar(
        backgroundColor: Colores.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colores.secondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.actividad == null ? 'Nueva Actividad' : 'Editar Actividad',
          style: const TextStyle(color: Colores.secondary, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Selector de Tipo
              const Text('Tipo de actividad', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colores.textPrimary)),
              Row(
                children: [
                  Radio<String>(
                    value: 'Tarea',
                    groupValue: tipoActividad,
                    activeColor: Colores.secondary,
                    onChanged: (val) => setState(() => tipoActividad = val!),
                  ),
                  const Text('Tarea', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 20),
                  Radio<String>(
                    value: 'Hábito',
                    groupValue: tipoActividad,
                    activeColor: Colores.secondary,
                    onChanged: (val) => setState(() => tipoActividad = val!),
                  ),
                  const Text('Hábito', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 15),

              // 2. Nombre
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  hintText: tipoActividad == 'Tarea' ? 'Nombre de la tarea' : 'Nombre del hábito',
                  filled: true,
                  fillColor: Colores.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 30),

              //CAMPOS DINÁMICOS SEGÚN EL TIPO
              if (tipoActividad == 'Tarea') ...[
                //SECCIÓN TAREA
                _buildSeccionFechaHora(
                  titulo: 'Añadir fecha de entrega',
                  icono: Icons.calendar_today_outlined,
                  activo: tieneFechaEntrega,
                  fecha: fechaEntrega,
                  hora: horaEntrega,
                  onToggle: (val) => setState(() => tieneFechaEntrega = val),
                  onTapFecha: () => _seleccionarFecha(context, (f) => setState(() => fechaEntrega = f)),
                  onTapHora: () => _seleccionarHora(context, (h) => setState(() => horaEntrega = h)),
                ),
                _buildSeccionFechaHora(
                  titulo: 'Añadir recordatorio',
                  icono: Icons.notifications_none_outlined,
                  activo: tieneRecordatorio,
                  fecha: fechaRecordatorio,
                  hora: horaRecordatorio,
                  onToggle: (val) => setState(() => tieneRecordatorio = val),
                  onTapFecha: () => _seleccionarFecha(context, (f) => setState(() => fechaRecordatorio = f)),
                  onTapHora: () => _seleccionarHora(context, (h) => setState(() => horaRecordatorio = h)),
                ),
                _buildPrioridad(),
                const SizedBox(height: 20),
                const Text('Detalles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  controller: detallesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colores.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
              ] else ...[
                //SECCIÓN HÁBITO
                const Row(
                  children: [
                    Icon(Icons.trending_up, color: Colores.textPrimary),
                    SizedBox(width: 10),
                    Text('Frecuencia del hábito', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: frecuencia,
                  decoration: InputDecoration(filled: true, fillColor: Colores.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                  items: ['Diario', 'Semanal', 'Mensual'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() => frecuencia = val!),
                ),
                const SizedBox(height: 30),
                _buildSeccionFechaHora(
                  titulo: 'Añadir recordatorio',
                  icono: Icons.notifications_none_outlined,
                  activo: tieneRecordatorio,
                  fecha: fechaRecordatorio,
                  hora: horaRecordatorio,
                  onToggle: (val) => setState(() => tieneRecordatorio = val),
                  onTapFecha: () => _seleccionarFecha(context, (f) => setState(() => fechaRecordatorio = f)),
                  onTapHora: () => _seleccionarHora(context, (h) => setState(() => horaRecordatorio = h)),
                ),
                _buildSeccionFechaHora(
                  titulo: 'Añadir fecha de finalización',
                  icono: Icons.event_busy_outlined,
                  activo: tieneFechaFin,
                  fecha: fechaFin,
                  hora: null, // Si solo quieres fecha
                  onToggle: (val) => setState(() => tieneFechaFin = val),
                  onTapFecha: () => _seleccionarFecha(context, (f) => setState(() => fechaFin = f)),
                  onTapHora: () {}, // Vacío si no se necesita
                ),
              ],
              
              const SizedBox(height: 40),
              
              //BOTÓN LISTO
              Center(
                child: ElevatedButton(
                  onPressed: _guardarActividad,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colores.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Listo', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //Widgets auxiliares para secciones de fecha/hora y prioridad, para mantener el build limpio
  
  Widget _buildSeccionFechaHora({
    required String titulo, required IconData icono, required bool activo,
    required DateTime? fecha, required TimeOfDay? hora,
    required Function(bool) onToggle, required VoidCallback onTapFecha, required VoidCallback onTapHora,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icono, color: Colores.textPrimary),
              const SizedBox(width: 10),
              Text(titulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              Switch( // Reemplazo del radio circular del diseño por un switch moderno
                value: activo,
                activeColor: Colores.primary,
                onChanged: onToggle,
              ),
            ],
          ),
          if (activo) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onTapFecha,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      decoration: BoxDecoration(color: Colores.surface, borderRadius: BorderRadius.circular(10)),
                      child: Text(fecha != null ? DateFormat('dd MMM yyyy').format(fecha) : 'Seleccionar Fecha', textAlign: TextAlign.center, style: TextStyle(color: fecha != null ? Colores.textPrimary : Colores.textSecondary)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: onTapHora,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      decoration: BoxDecoration(color: Colores.surface, borderRadius: BorderRadius.circular(10)),
                      child: Text(hora != null ? hora.format(context) : 'Hora', textAlign: TextAlign.center, style: TextStyle(color: hora != null ? Colores.textPrimary : Colores.textSecondary)),
                    ),
                  ),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }

  Widget _buildPrioridad() {
    return Row(
      children: [
        const Icon(Icons.error_outline, color: Colores.textPrimary),
        const SizedBox(width: 10),
        const Text('Prioridad', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 20),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: prioridad,
            decoration: InputDecoration(filled: true, fillColor: Colores.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
            items: ['Alta', 'Media', 'Baja'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => prioridad = val!),
          ),
        ),
      ],
    );
  }
}