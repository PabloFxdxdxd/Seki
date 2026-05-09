import 'package:flutter/material.dart';
import 'package:proyect_seki/core/Colores.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.background,
      appBar: AppBar(
        title: const Text(
          'Selección de Opciones',
          style: TextStyle(color: Colores.textPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colores.primary,
        elevation: 0, // Le quita la sombra para que se vea más plano y moderno
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinea el texto a la izquierda
            children: [
              const SizedBox(height: 10),
              const Text(
                '¡Bienvenido!',
                style: TextStyle(fontSize: 20, color: Colores.textSecondary),
              ),
              const SizedBox(height: 8),
              const Text(
                '¿Qué deseas hacer hoy?',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colores.textPrimary, height: 1.2),
              ),
              const SizedBox(height: 40),

              //Boton 1 Agenda de hábitos
              _buildOptionCard(
                context: context,
                title: 'Agenda de hábitos',
                subtitle: 'Organiza tus tareas y rutinas diarias',
                icon: Icons.calendar_month_rounded,
                color: Colores.secondary, // Verde oscuro
                showBorder: true, // Muestra el borde para destacar esta opción
                onTap: () {
                  Navigator.pushNamed(context, '/agendaHome');
                },
              ),
              const SizedBox(height: 40),

              //Boton 2 Fitness
              _buildOptionCard(
                context: context,
                title: 'Fitness',
                subtitle: 'Rutinas de ejercicio y salud física',
                icon: Icons.fitness_center_rounded,
                color: Colores.accent, // Naranja
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('La sección de Fitness está en proceso'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              //Boton 3 Salud Mental
              _buildOptionCard(
                context: context,
                title: 'Salud Mental',
                subtitle: 'Meditación, emociones y bienestar',
                icon: Icons.self_improvement_rounded,
                color: Colores.primary, // Cian de tu paleta
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('La sección de Salud Mental está en proceso'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Widget personalizado para crear las tarjetas de opciones 
  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool showBorder = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colores.surface, // Fondo blanco de la tarjeta
          borderRadius: BorderRadius.circular(20),
          border: showBorder
          ? Border.all(color: color, width: 2.5) // Borde del color base si showBorder es true
          : Border.all(color: Colors.transparent, width: 2.5), // Sin borde si showBorder es false
          boxShadow: const [
            BoxShadow(
              color: Colores.sombra, 
              blurRadius: 15, 
              offset: Offset(0, 5)
            ),
          ],
        ),
        child: Row(
          children: [
            // Círculo con el ícono
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15), // Fondo semitransparente del color base
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 20),
            
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colores.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 16, color: Colores.textSecondary),
                  ),
                ],
              ),
            ),
            
            //flecha indicadora a la derecha
            const Icon(Icons.chevron_right_rounded, color: Colores.textSecondary),
          ],
        ),
      ),
    );
  }
}