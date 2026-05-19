import 'package:flutter/material.dart';

class PantallaEjemplo extends StatefulWidget {
  @override
  State<PantallaEjemplo> createState() => _PantallaEjemploState();
}

class _PantallaEjemploState extends State<PantallaEjemplo> {
  //-----------------Backend--------------------

  //Se definen las funciones para trabajar con la base de datos

  void insertar() {
    print("Usuario Insertado");
  }

  void eliminar() {
    print("Usuario Eliminado");
  }

  //-----------------Frontend--------------------

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.secondary,
      body: Center(
        child: ElevatedButton(onPressed: insertar, child: Text("Insertar")),
      ),
    );
  }
}
