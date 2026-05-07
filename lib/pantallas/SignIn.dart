import 'package:flutter/material.dart';
import 'package:proyect_seki/core/Colores.dart';
import 'package:proyect_seki/database/database.dart'; //Donde están las funciones de la base de datos
import 'package:drift/drift.dart' as d;

class PantallaRegistro extends StatefulWidget { 

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();

}

class _PantallaRegistroState extends State<PantallaRegistro> {


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
      backgroundColor: const Color.fromARGB(255, 159, 232, 236),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FractionallySizedBox(
              widthFactor: 0.7,
              child: Icon(
                size: 200.0,
                color: const Color.fromARGB(255, 29, 124, 123),
                Icons.person_rounded,
              ),
            ),
            //nombre de Usuario
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextField(
                  decoration: InputDecoration(
                  hintText: "Nombre de usuario",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),  
                  ),
                ),
              ),
            
            //correo electronico
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextField(
                  decoration: InputDecoration(
                  hintText: "Correo electrónico",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),  
                  ),
                ),
              ),
            
            //Campo de contraseña
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                    hintText: "Crear contraseña",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          
                  ),
                ),
              ),

              //Verificacion de contraseña
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                    hintText: "Verificar contraseña",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          
                  ),
                ),
              ),
            ElevatedButton(onPressed: insertar, child: Text("Registrarse")),
          ]
        ),
      ),

    );
  }
 
}