import 'package:flutter/material.dart';
import 'package:proyect_seki/database/database.dart'; //Donde están las funciones de la base de datos
import 'package:drift/drift.dart' as d;

class PantallaEjemplo extends StatefulWidget { 

  @override
  State<PantallaEjemplo> createState() => _PantallaEjemploState();

}

class _PantallaEjemploState extends State<PantallaEjemplo> {


  //-----------------Backend--------------------

  //Se definen las funciones para trabajar con la base de datos

  void insertar(){
    print("Usuario Insertado");
  }

  void eliminar(){
    print("Usuario Eliminado");
  }

  //-----------------Frontend--------------------

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.secondary,
      body: Center(
        child: ElevatedButton(onPressed: insertar, child: Text("Insertar"))
      ),
       
    );
  }
 
}