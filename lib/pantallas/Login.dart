import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:proyect_seki/database/database.dart';
import 'package:proyect_seki/main.dart'; // Cambia 'proyect_seki' por el nombre real de tu proyecto

import 'package:proyect_seki/core/Colores.dart'; 
import 'package:proyect_seki/pantallas/Home.dart';
import 'package:proyect_seki/core/Notifications.dart';

class PantallaLogin extends StatefulWidget { 

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();

}

class _PantallaLoginState extends State<PantallaLogin> {


  //-----------------Backend--------------------

  //Controladores para obtener la información de los campos de texto

  final correoController = TextEditingController();
  final passwordController = TextEditingController();


  //Se definen las funciones para trabajar con la base de datos

  

  void entrar() async{ //Validación y redirección del login
    final usuario = await globalDatabase.validarCredenciales(correoController.text, passwordController.text);
    if (!mounted) return; //Si se usará Navigator.push en una función asincrona debe ir el if (!mounted) para evitar brechas de seguridad

    if(usuario != null){
      currentUser = usuario;
      if(usuario.type.contains("admin")){
        Navigator.pushNamed(context, '/admin');
      }else{
        try{
          Navigator.pushNamed(context, '/home');
        }catch(e){
          print("Algo pasó con la navegación");
        }
        
      }
    }else {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Correo o contraseña incorrectos")),
    );
  }

  }

  void navegarRegistro(){
    print("Registrarse");
    Navigator.pushNamed(context, '/signin');
  }
  //Entra a admin temporalmente
  void navegarAdmin(){
    Navigator.pushNamed(context, '/admin');
  }

  void funcGoogle(){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Inicio de sesión no disponible")),
    );

  }

  @override
  void dispose() {
    passwordController.dispose();
    correoController.dispose();
    super.dispose();
  }

  
  //-----------------Frontend--------------------

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.secondary,
      body: Center(
        
        
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30), //Margen a la izquierda y derecha

        //Utilicen este widget para que scrolee al momento de insertar texto, sino tira un error
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, //Centrar verticalmente
            crossAxisAlignment: CrossAxisAlignment.start, //Alineación a la izquierda
          
            children: [
              //Titulo
              Text("Iniciar sesión", style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.bold, 
                color: Colores.background)),
              const SizedBox(height: 40), //separa los elementos con un espacio
              
              //Campo de Correo
              Text(
                  "Correo electrónico", 
                  style: TextStyle(
                    
                    color: Colores.background,
                    fontSize: 15
                  )
              ),
              const SizedBox(height: 8),
              TextField(
                  controller: correoController,
                  decoration: InputDecoration(
                  hintText: "name@example.com",
                  filled: true,
                  fillColor: Colores.background,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          
                ),
              ),
              
              const SizedBox(height: 20),
              
            //Campo de contraseña
          
              Text(
                  "Contraseña", 
                  style: TextStyle(
          
                    color: Colores.background,
                    fontSize: 15
                  )
              ),
              const SizedBox(height: 8),
              TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                  hintText: "Introduce tu contraseña",
                  filled: true,
                  fillColor: Colores.background,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          
                ),
              ),
              const SizedBox(height: 20),
          
              //Botón de inicio
              Center( 
                child: ElevatedButton(
                  onPressed: entrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.inversePrimary, 
                    minimumSize: Size(double.infinity, 50), //Botón ancho
                  ),
                  child: Text("Entrar"),
                ),
              ),
          
              const SizedBox(height: 20),
          
              Center(
                child: Text(
                  "O",
                  style: TextStyle(
                    color: Colores.background,
                    fontSize: 15
                  )
                 ),
              ),
          
              const SizedBox(height: 20),
          
              //Otras opciones de inicio
          
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {navegarAdmin();},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colores.googleButton, 
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  icon: Image.asset('assets/icons/google.png', height: 24),
                  label: const Text(
                    "Continuar con Google (Temp)",
                    style: TextStyle(
                      color: Colores.background, 
                      fontSize: 15
                  )
                )
              )
              ),
            
             const SizedBox(height: 30),
          
             //Para registrarse
          
              Text(
                "¿No tienes Cuenta?",
                style: TextStyle(
                  color: Colores.background,
                  fontSize: 15
                )
                ),
              
              const SizedBox(height: 10),
              Center( 
                child: ElevatedButton(
                  onPressed: () {navegarRegistro();},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.inversePrimary, 
                    minimumSize: Size(double.infinity, 50), 
                  ),
                  child: Text("¡Registrarse!"),
                ),
              )
          
          
          
            ],
          ),
        ),
      )
      ),
       
    );
  }
 
}