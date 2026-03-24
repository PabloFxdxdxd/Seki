import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SEKI',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8DEAE6)),
        
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.secondary,
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30), //Margen a la izquierda y derecha
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //Centrar verticalmente
          crossAxisAlignment: CrossAxisAlignment.start, //Alineación a la izquierda

          children: [
            //Titulo
            Text("Iniciar sesión", style: TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold, 
              color: Colors.white)),
            const SizedBox(height: 40), //separa los elementos con un espacio
            
            //Campo de Correo
            Text(
                "Correo electrónico", 
                style: TextStyle(

                  color: Colors.white,
                  fontSize: 15
                )
            ),
            const SizedBox(height: 8),
            TextField(

                decoration: InputDecoration(
                hintText: "name@example.com",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),

              ),
            ),
            
            const SizedBox(height: 20),
            
          //Campo de contraseña

            Text(
                "Contraseña", 
                style: TextStyle(

                  color: Colors.white,
                  fontSize: 15
                )
            ),
            const SizedBox(height: 8),
            TextField(
                obscureText: true,
                decoration: InputDecoration(
                hintText: "Introduce tu contraseña",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),

              ),
            ),
            const SizedBox(height: 20),

            //Botón de inicio
            Center( 
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.inversePrimary, 
                  minimumSize: Size(double.infinity, 50), // Botón ancho
                ),
                child: Text("Entrar"),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                "O",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15
                )
               ),
            ),

            const SizedBox(height: 20),

            //Otras opciones de inicio

            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, 
                  minimumSize: Size(double.infinity, 50),
                  
                ),
                icon: Image.asset('assets/icons/google.png', height: 24),
                label: Text(
                  "Continuar con Google",
                  style: TextStyle(
                    color: Colors.black,
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
                color: Colors.white,
                fontSize: 15
              )
              ),
            
            const SizedBox(height: 10),
            Center( 
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.inversePrimary, 
                  minimumSize: Size(double.infinity, 50), 
                ),
                child: Text("¡Registrarse!"),
              ),
            )



          ],
        ),
      )
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
