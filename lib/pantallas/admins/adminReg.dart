// ignore: file_names
import 'package:flutter/material.dart';
import 'package:proyect_seki/core/adminTheme.dart';
import 'package:proyect_seki/database/database.dart'; //Donde están las funciones de la base de datos
import 'package:drift/drift.dart' as d;
import 'package:proyect_seki/main.dart';

class PantallaAdminRegistro extends StatefulWidget {
  const PantallaAdminRegistro({super.key});

  @override
  State<PantallaAdminRegistro> createState() => _PantallaAdminRegistroState();
}

class _PantallaAdminRegistroState extends State<PantallaAdminRegistro> {
  //-----------------Backend--------------------

  //Controladores para obtener la información de los campos de texto

  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordVerificationController = TextEditingController();

  //Se definen las funciones para trabajar con la base de datos

  void insertar() async {
    if (passwordController.text == passwordVerificationController.text) {
      if (await globalDatabase.existeEmail(correoController.text)) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("El correo ya existe.")));
      } else {
        globalDatabase.insertUser(
          UserCompanion(
            name: d.Value(nombreController.text),
            email: d.Value(correoController.text),
            password: d.Value(passwordController.text),
            type: d.Value("admin"),
            createdAt: d.Value(DateTime.now()),
          ),
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Administrador creado exitosamente")),
        );
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        Navigator.pushNamed(context, '/admin');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Las contraseñas no coinciden")),
      );
    }
  }

  //-----------------Frontend--------------------

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AdminTheme.theme,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: "Registro Admin",
            ),
          ],
          currentIndex: 1,
          onTap: (index) {
            //navegación entre secciones del admin
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/admin');
            }
          },
        ),
        //barra superior
        appBar: AppBar(
          title: const Text("Panel de Adminsitración"),
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => setState(
                () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/admin',
                  (route) => false,
                ),
              ), //recarga los datos al presionar el botón
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Icon(size: 200.0, Icons.add_moderator_rounded),
                ),
                SizedBox(height: 20),
                //nombre de Usuario
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      hintText: "Nombre de usuario",
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                //correo electronico
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: TextField(
                    controller: correoController,
                    decoration: InputDecoration(
                      hintText: "Correo electrónico",
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                //Campo de contraseña
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Crear contraseña",
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                //Verificacion de contraseña
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: TextField(
                    controller: passwordVerificationController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Verificar contraseña",
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: insertar,
                  child: Text("Registrar Administrador"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
