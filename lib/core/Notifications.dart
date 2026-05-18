import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Inicializa la base de datos de tiempos interna
    tz.initializeTimeZones(); 

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    // Solicitamos los permisos nativos correspondientes
    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission(); 

    await _notificationsPlugin.initialize(initSettings);
  }

  // Programar una notificación usando el truco de UTC
  Future<void> programarNotificacion({
    required int id,
    required String titulo,
    required String cuerpo,
    required DateTime fechaProgramada,
  }) async {
    if (fechaProgramada.isBefore(DateTime.now())) return;

    // TRUCO: Convertimos la fecha local del dispositivo a UTC nativo de Dart
    final DateTime fechaUTC = fechaProgramada.toUtc();

    await _notificationsPlugin.zonedSchedule(
      id,
      titulo,
      cuerpo,
      // Le pasamos el tiempo UTC indicándole a la librería que la locación es tz.utc
      tz.TZDateTime.from(fechaUTC, tz.UTC), 
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'seki_actividades_channel',
          'Recordatorios de Actividades',
          channelDescription: 'Canal para las alertas de tareas y hábitos',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelarNotificacion(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Función para testear la programación de tiempo (retraso en minutos)
 // Prueba "a secas" con la hora local del dispositivo + 10 segundos
  static Future<void> lanzarNotificacionTestProgramada(int minutosEnElFuturo) async {
    final DateTime ahora = DateTime.now();
    final DateTime fechaProgramada = ahora.add(Duration(minutes: minutosEnElFuturo));
    final DateTime fechaUTC = fechaProgramada.toUtc();

    // Prints de depuración para ver en la consola de VS Code qué está pasando
    print("==============================================");
    print("⏰ [TEST] INICIANDO PROGRAMACIÓN");
    print("📱 Hora actual del dispositivo: $ahora");
    print("🎯 Programada para sonar en:    $fechaProgramada");
    print("🌍 Convertida a UTC:            $fechaUTC");
    print("==============================================");

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'canal_test_programado_id',
      'Pruebas Programadas',
      channelDescription: 'Canal para verificar alertas con retraso de tiempo',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    try {
      await NotificationService()._notificationsPlugin.zonedSchedule(
        888, // ID fijo de test
        '¡La prueba de tiempo funcionó! ⏰',
        'Esta notificación fue programada para dentro de $minutosEnElFuturo minutos y llegó a tiempo.',
        tz.TZDateTime.from(fechaUTC, tz.UTC),
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
      print("✅ [TEST] Notificación registrada con éxito en Android.");
    } catch (e) {
      print("❌ [TEST] Error al programar la notificación: $e");
    }
  }
}