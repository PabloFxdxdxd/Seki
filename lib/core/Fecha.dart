import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

//Si se ocupan funciones de fechas se pondrán aquí
class Fecha{

  static String obtenerFecha(){
    initializeDateFormatting('es'); 
  
    DateTime now = DateTime.now();
  
    String fechaFormateada = DateFormat("d 'de' MMMM 'del' yyyy", 'es').format(now);

    return fechaFormateada;
    
  }

}