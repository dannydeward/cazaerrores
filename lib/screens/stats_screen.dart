import 'package:flutter/material.dart';
import '../services/stats_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  bool cargando = true;

  int mejorPuntuacion = 0;
  int partidasJugadas = 0;
  int correctas = 0;
  int incorrectas = 0;

  @override
  void initState() {
    super.initState();
    cargarEstadisticas();
  }

  Future<void> cargarEstadisticas() async {
    final stats = await StatsService.obtenerEstadisticas();

    setState(() {
      mejorPuntuacion = stats["mejorPuntuacion"] ?? 0;
      partidasJugadas = stats["partidasJugadas"] ?? 0;
      correctas = stats["correctas"] ?? 0;
      incorrectas = stats["incorrectas"] ?? 0;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Estadísticas"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              "📊 Tus estadísticas",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.emoji_events),
                title: const Text("Mejor puntuación"),
                trailing: Text("$mejorPuntuacion"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.sports_esports),
                title: const Text("Partidas jugadas"),
                trailing: Text("$partidasJugadas"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text("Respuestas correctas"),
                trailing: Text("$correctas"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text("Respuestas incorrectas"),
                trailing: Text("$incorrectas"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}